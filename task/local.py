# coding: utf-8

import os
import tempfile
from datetime import datetime

from auth import verify_authorization_header
from database import (get_registration_tokens, get_template_overlays,
                      set_generated_piece, set_generating_piece)
from detection import detect_non_silence
from messaging import send_completed_to_generate_piece
from piece import generate_piece_movie, generate_piece_sound
from storage_local import (download_edited_user_media, download_template_bgm,
                           download_unedited_user_media, upload_piece_movie,
                           upload_piece_thumbnail, upload_user_media)
from subscription import fetch_is_premium_plan
from thumbnail import (generate_equally_divided_segments,
                       generate_specified_segments)
from utils import generate_store_file_name


def upload(request):
    file = request.files['file']
    original_file_name = file.filename

    _, file_path = tempfile.mkstemp()
    file.save(file_path)

    file_base_name, file_extension = generate_store_file_name(
        file_name=original_file_name
    )
    file_name = f'{file_base_name}{file_extension}'

    upload_user_media(file_name=file_name, file_path=file_path)

    return {
        'id': file_base_name,
        'extension': file_extension,
    }


def detect(request):
    request_params_json = request.json

    uploaded_file_name = request_params_json['fileName']

    sound_path = download_unedited_user_media(
        file_name=uploaded_file_name
    )

    non_silences = detect_non_silence(file_path=sound_path)

    equally_devided_segment_thumbnails = generate_equally_divided_segments(
        store_path=sound_path
    )

    non_silence_starts_milliseconds = [
        non_silence[0]
        for non_silence in non_silences['segments']
    ]
    non_silence_segment_thumbnails = generate_specified_segments(
        store_path=sound_path,
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
    should_eliminate_waiting_time = \
        os.environ['FEATURE_ELIMINATE_WAITING_TIME_TO_GENERATE'] == 'true'

    authorization_value = request.headers['authorization']
    purchase_user_id = request.headers['purchase-user-id']
    platform = request.headers['platform']

    request_params_json = request.json
    _ = request_params_json['templateId']
    _ = request_params_json['soundFileNames']
    display_name = request_params_json['displayName']
    thumbnail_file_name = request_params_json['thumbnailFileName']

    uid = verify_authorization_header(value=authorization_value)

    if should_eliminate_waiting_time:
        is_premium_plan = fetch_is_premium_plan(
            user_id=purchase_user_id,
            platform=platform,
        )
        eliminate_waiting_time = is_premium_plan
    else:
        eliminate_waiting_time = False

    print(f'Eliminate waiting time: {eliminate_waiting_time}')

    piece_id = set_generating_piece(
        uid=uid,
        display_name=display_name,
        thumbnail_file_name=thumbnail_file_name,
        submitted_at=datetime.now(),
    )

    return {
        'pieceId': piece_id,
    }


def piece(request):
    authorization_value = request.headers['authorization']

    uid = verify_authorization_header(value=authorization_value)

    request_params_json = request.json

    piece_id = request_params_json['pieceId']

    template_id = request_params_json['templateId']
    sound_file_names = request_params_json['soundFileNames']
    display_name = request_params_json['displayName']
    thumbnail_file_name = request_params_json['thumbnailFileName']

    template_path = download_template_bgm(template_id=template_id)

    sound_paths = [
        download_edited_user_media(file_name=sound_file_name)
        for sound_file_name in sound_file_names
    ]

    overlays = get_template_overlays(id=template_id)

    _, piece_sound_base_path = tempfile.mkstemp()

    piece_sound_path = generate_piece_sound(
        template_path=template_path,
        sound_paths=sound_paths,
        overlays=overlays,
        export_base_path=piece_sound_base_path,
    )

    thumbnail_path = download_edited_user_media(
        file_name=thumbnail_file_name
    )

    _, piece_movie_base_path = tempfile.mkstemp()

    _, piece_thumbnail_base_path = tempfile.mkstemp()

    piece_movie_path, piece_thumbnail_path = generate_piece_movie(
        thumbnail_path=thumbnail_path,
        piece_sound_path=piece_sound_path,
        title=display_name,
        thumbnail_export_base_path=piece_thumbnail_base_path,
        movie_export_base_path=piece_movie_base_path,
    )

    current = datetime.now()
    piece_movie_base_name = f'{current.strftime("%Y%m%d%H%M%S")}_movie'
    splitted_piece_movie_file_name = os.path.splitext(piece_movie_path)
    piece_movie_extension = splitted_piece_movie_file_name[1]
    piece_movie_file_name = f'{piece_movie_base_name}{piece_movie_extension}'

    upload_piece_movie(
        file_name=piece_movie_file_name,
        file_path=piece_movie_path
    )

    piece_thumbnail_base_name = f'{current.strftime("%Y%m%d%H%M%S")}_thumbnail'
    splitted_piece_thumbnail_file_name = os.path.splitext(piece_thumbnail_path)
    piece_thumbnail_extension = splitted_piece_thumbnail_file_name[1]
    piece_thumbnail_file_name = (
        f'{piece_thumbnail_base_name}{piece_thumbnail_extension}'
    )

    upload_piece_thumbnail(
        file_name=piece_thumbnail_file_name,
        file_path=piece_thumbnail_path
    )

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

    return {}
