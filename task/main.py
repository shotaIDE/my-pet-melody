# coding: utf-8

import json
import os
import tempfile
from datetime import datetime, timedelta

from firebase_admin import storage
from google.cloud import tasks_v2
from google.protobuf import timestamp_pb2

from auth import verify_authorization_header
from database import (get_registration_tokens, get_template_overlays,
                      set_generated_piece, set_generating_piece)
from detection import detect_non_silence
from firebase import initialize_firebase
from messaging import send_completed_to_generate_piece
from piece import generate_piece_movie, generate_piece_sound
from storage import (TEMPLATE_EXTENSION, TEMPLATE_FILE_NAME,
                     USER_MEDIA_DIRECTORY_NAME)
from subscription import fetch_is_premium_plan
from thumbnail import (generate_equally_divided_segments,
                       generate_specified_segments)

initialize_firebase()


def detect(request):
    authorization_value = request.headers['authorization']

    uid = verify_authorization_header(value=authorization_value)

    request_params_json = request.json

    uploaded_file_name = request_params_json['fileName']
    splitted_file_name = os.path.splitext(uploaded_file_name)
    uploaded_extension = splitted_file_name[1]

    bucket = storage.bucket()

    _, uploaded_local_base_path = tempfile.mkstemp()
    uploaded_local_path = f'{uploaded_local_base_path}{uploaded_extension}'

    uploaded_relative_path = (
        f'{USER_MEDIA_DIRECTORY_NAME}/{uid}/'
        f'unedited/{uploaded_file_name}'
    )
    uploaded_blob = bucket.blob(uploaded_relative_path)

    uploaded_blob.download_to_filename(uploaded_local_path)

    non_silences = detect_non_silence(store_path=uploaded_local_path)

    equally_devided_segment_thumbnails = generate_equally_divided_segments(
        store_path=uploaded_local_path
    )

    non_silence_starts_milliseconds = [
        non_silence[0]
        for non_silence in non_silences['segments']
    ]
    non_silence_segment_thumbnails = generate_specified_segments(
        store_path=uploaded_local_path,
        segments_starts_milliseconds=non_silence_starts_milliseconds,
    )

    results = {
        'detectedSegments': [
            {
                'startMilliseconds': segment_milliseconds[0],
                'endMilliseconds': segment_milliseconds[1],
                'thumbnailBase64': thumbnail,
            }
            for (segment_milliseconds, thumbnail) in zip(
                non_silences['segments'], non_silence_segment_thumbnails)
        ],
        'equallyDividedSegments': [
            {'thumbnailBase64': thumbnail}
            for thumbnail in equally_devided_segment_thumbnails
        ],
        'durationMilliseconds': non_silences['durationMilliseconds'],
    }

    return results


def submit(request):
    GCP_PROJECT_ID = os.environ['GOOGLE_CLOUD_PROJECT_ID']
    TASKS_LOCATION = os.environ['GOOGLE_CLOUD_TASKS_LOCATION']
    TASKS_QUEUE_ID = os.environ['GOOGLE_CLOUD_TASKS_QUEUE_ID']
    FUNCTIONS_ORIGIN = os.environ['FIREBASE_FUNCTIONS_API_ORIGIN']
    should_eliminate_waiting_time = \
        os.environ['FEATURE_ELIMINATE_WAITING_TIME_TO_GENERATE'] == 'true'
    waiting_time_seconds = \
        int(os.environ['WAITING_TIME_SECONDS_TO_GENERATE'])

    authorization_value = request.headers['authorization']
    purchase_user_id = request.headers['purchase-user-id']
    platform = request.headers['platform']

    request_params_json = request.json
    template_id = request_params_json['templateId']
    sound_base_names = request_params_json['soundFileNames']
    display_name = request_params_json['displayName']
    thumbnail_base_name = request_params_json['thumbnailFileName']

    uid = verify_authorization_header(value=authorization_value)

    if should_eliminate_waiting_time:
        is_premium_plan = fetch_is_premium_plan(
            user_id=purchase_user_id,
            platform=platform,
        )
        eliminate_waiting_time = is_premium_plan
    else:
        eliminate_waiting_time = False

    piece_id = set_generating_piece(
        uid=uid,
        display_name=display_name,
        thumbnail_file_name=thumbnail_base_name,
        submitted_at=datetime.now(),
    )

    client = tasks_v2.CloudTasksClient()

    parent = client.queue_path(
        GCP_PROJECT_ID, TASKS_LOCATION, TASKS_QUEUE_ID
    )

    body_dict = {
        'uid': uid,
        'pieceId': piece_id,
        'templateId': template_id,
        'soundFileNames': sound_base_names,
        'displayName': display_name,
        'thumbnailFileName': thumbnail_base_name,
    }
    payload = json.dumps(body_dict)
    converted_payload = payload.encode()

    delayed_timedelta = \
        timedelta() if eliminate_waiting_time \
        else timedelta(seconds=waiting_time_seconds)
    schedule_date_time = datetime.utcnow() + delayed_timedelta

    schedule_timestamp = timestamp_pb2.Timestamp()
    schedule_timestamp.FromDatetime(schedule_date_time)

    task = {
        'http_request': {
            'http_method': tasks_v2.HttpMethod.POST,
            'url': f'{FUNCTIONS_ORIGIN}/piece',
            'headers': {
                'Content-type': 'application/json',
            },
            'body': converted_payload,
        },
        'schedule_time': schedule_timestamp,
    }

    response = client.create_task(request={
        'parent': parent,
        'task': task,
    })

    print(f'Created task {response}')

    return {}


def piece(request):
    request_params_json = request.json

    uid = request_params_json['uid']
    piece_id = request_params_json['pieceId']

    template_id = request_params_json['templateId']
    sound_base_names = request_params_json['soundFileNames']
    display_name = request_params_json['displayName']
    thumbnail_file_name = request_params_json['thumbnailFileName']

    overlays = get_template_overlays(id=template_id)

    bucket = storage.bucket()

    _, template_local_base_path = tempfile.mkstemp()
    template_local_path = f'{template_local_base_path}{TEMPLATE_EXTENSION}'

    template_relative_path = (
        f'systemMedia/templates/{template_id}/{TEMPLATE_FILE_NAME}'
    )
    template_blob = bucket.blob(template_relative_path)

    template_blob.download_to_filename(template_local_path)

    sound_local_paths = []
    for sound_base_name in sound_base_names:
        _, sound_local_base_path = tempfile.mkstemp()
        splitted_piece_movie_file_name = os.path.splitext(sound_base_name)
        sound_extension = splitted_piece_movie_file_name[1]
        sound_local_path = f'{sound_local_base_path}{sound_extension}'

        sound_relative_path = (
            f'{USER_MEDIA_DIRECTORY_NAME}/{uid}/'
            f'edited/{sound_base_name}'
        )
        sound_blob = bucket.blob(sound_relative_path)

        sound_blob.download_to_filename(sound_local_path)

        sound_local_paths.append(sound_local_path)

    # TODO: ファイルの存在を確認するバリデーションチェック
    # TODO: 鳴き声が2つ存在することを確認するバリデーションチェック

    _, piece_sound_local_base_path = tempfile.mkstemp()

    piece_sound_local_path = generate_piece_sound(
        template_path=template_local_path,
        sound_paths=sound_local_paths,
        overlays=overlays,
        export_base_path=piece_sound_local_base_path,
    )

    _, thumbnail_local_base_path = tempfile.mkstemp()
    splitted_thumbnail_file_name = os.path.splitext(thumbnail_file_name)
    thumbnail_extension = splitted_thumbnail_file_name[1]
    thumbnail_local_path = f'{thumbnail_local_base_path}{thumbnail_extension}'

    thumbnail_relative_path = (
        f'{USER_MEDIA_DIRECTORY_NAME}/{uid}/'
        f'edited/{thumbnail_file_name}'
    )
    thumbnail_blob = bucket.blob(thumbnail_relative_path)

    thumbnail_blob.download_to_filename(thumbnail_local_path)

    _, piece_movie_local_base_path = tempfile.mkstemp()

    _, piece_thumbnail_local_base_path = tempfile.mkstemp()

    (piece_movie_local_path, piece_thumbnail_local_path) = \
        generate_piece_movie(
            thumbnail_path=thumbnail_local_path,
            piece_sound_path=piece_sound_local_path,
            title=display_name,
            thumbnail_export_base_path=piece_thumbnail_local_base_path,
            movie_export_base_path=piece_movie_local_base_path,
    )

    current = datetime.now()
    piece_movie_base_name = f'{current.strftime("%Y%m%d%H%M%S")}_movie'
    splitted_piece_movie_file_name = os.path.splitext(
        piece_movie_local_path)
    piece_movie_extension = splitted_piece_movie_file_name[1]
    piece_movie_file_name = f'{piece_movie_base_name}{piece_movie_extension}'

    piece_movie_relative_path = (
        f'{USER_MEDIA_DIRECTORY_NAME}/{uid}/'
        f'generatedPieces/{piece_movie_file_name}'
    )
    piece_movie_blob = bucket.blob(piece_movie_relative_path)

    piece_movie_blob.upload_from_filename(piece_movie_local_path)

    piece_thumbnail_base_name = f'{current.strftime("%Y%m%d%H%M%S")}_thumbnail'
    splitted_piece_thumbnail_file_name = os.path.splitext(
        piece_thumbnail_local_path)
    piece_thumbnail_extension = splitted_piece_thumbnail_file_name[1]
    piece_thumbnail_file_name = (
        f'{piece_thumbnail_base_name}{piece_thumbnail_extension}'
    )

    piece_thumbnail_relative_path = (
        f'{USER_MEDIA_DIRECTORY_NAME}/{uid}/'
        f'generatedThumbnail/{piece_thumbnail_file_name}'
    )
    piece_thumbnail_blob = bucket.blob(piece_thumbnail_relative_path)

    piece_thumbnail_blob.upload_from_filename(piece_thumbnail_local_path)

    set_generated_piece(
        uid=uid,
        id=piece_id,
        display_name=display_name,
        thumbnail_file_name=piece_thumbnail_file_name,
        movie_file_name=piece_movie_file_name,
        generated_at=current
    )

    registration_tokens = get_registration_tokens(uid=uid)

    if registration_tokens is not None:
        send_completed_to_generate_piece(
            display_name=display_name,
            registration_tokens=registration_tokens
        )

    return {
        'id': piece_movie_base_name,
        'path': piece_movie_relative_path,
    }
