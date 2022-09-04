# coding: utf-8

import json
import os
import tempfile
from datetime import datetime, timedelta

from firebase_admin import firestore, messaging, storage
from google.cloud import tasks_v2
from google.protobuf import timestamp_pb2

from auth import verify_authorization_header
from database import set_generated_piece, template_overlays
from detection import detect_non_silence
from firebase import initialize_firebase
from piece import generate_piece
from storage import (TEMPLATE_EXTENSION, TEMPLATE_FILE_NAME,
                     USER_MEDIA_DIRECTORY_NAME)

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

    return detect_non_silence(store_path=uploaded_local_path)


def submit(request):
    _GCP_PROJECT_ID = os.environ['GOOGLE_CLOUD_PROJECT_ID']
    _TASKS_LOCATION = os.environ['GOOGLE_CLOUD_TASKS_LOCATION']
    _TASKS_QUEUE_ID = os.environ['GOOGLE_CLOUD_TASKS_QUEUE_ID']
    _FUNCTIONS_ORIGIN = os.environ['FIREBASE_FUNCTIONS_API_ORIGIN']

    authorization_value = request.headers['authorization']

    uid = verify_authorization_header(value=authorization_value)

    request_params_json = request.json

    store_data = {
        'name': 'Generating Piece',
        'submittedAt': datetime.now(),
    }

    db = firestore.client()

    _, created_document = db.collection('userMedia').document(
        uid).collection('generatedPieces').add(store_data)

    piece_id = created_document.id

    template_id = request_params_json['templateId']
    sound_base_names = request_params_json['fileNames']
    display_name = request_params_json['displayName']
    thumbnail_base_name = request_params_json['thumbnailName']

    client = tasks_v2.CloudTasksClient()

    parent = client.queue_path(
        _GCP_PROJECT_ID, _TASKS_LOCATION, _TASKS_QUEUE_ID
    )

    body_dict = {
        'uid': uid,
        'pieceId': piece_id,
        'templateId': template_id,
        'fileNames': sound_base_names,
        'displayName': display_name,
        'thumbnailName': thumbnail_base_name,
    }
    payload = json.dumps(body_dict)
    converted_payload = payload.encode()

    d = datetime.utcnow() + timedelta(minutes=1)

    timestamp = timestamp_pb2.Timestamp()
    timestamp.FromDatetime(d)

    task = {
        'http_request': {
            'http_method': tasks_v2.HttpMethod.POST,
            'url': f'{_FUNCTIONS_ORIGIN}/piece',
            'headers': {
                'Content-type': 'application/json',
            },
            'body': converted_payload,
        },
        'schedule_time': timestamp,
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
    sound_base_names = request_params_json['fileNames']
    display_name = request_params_json['displayName']
    thumbnail_base_name = request_params_json['thumbnailName']

    overlays = template_overlays(id=template_id)

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
        splitted_file_name = os.path.splitext(sound_base_name)
        sound_extension = splitted_file_name[1]
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

    _, export_local_base_path = tempfile.mkstemp()

    export_local_path = generate_piece(
        template_path=template_local_path,
        sound_paths=sound_local_paths,
        overlays=overlays,
        export_base_path=export_local_base_path,
    )

    current = datetime.now()
    export_base_name = current.strftime('%Y%m%d%H%M%S')
    splitted_file_name = os.path.splitext(export_local_path)
    export_extension = splitted_file_name[1]
    export_file_name = f'{export_base_name}{export_extension}'

    export_relative_path = (
        f'{USER_MEDIA_DIRECTORY_NAME}/{uid}/'
        f'generatedPieces/{export_file_name}'
    )
    export_blob = bucket.blob(export_relative_path)

    export_blob.upload_from_filename(export_local_path)

    set_generated_piece(
        uid=uid,
        id=piece_id,
        display_name=display_name,
        file_name=export_file_name,
        generated_at=current
    )

    db = firestore.client()

    user_document_ref = db.collection('users').document(uid)
    user_document = user_document_ref.get()
    if user_document.exists:
        user_data = user_document.to_dict()

        if 'registrationTokens' in user_data:
            registration_tokens = user_data['registrationTokens']

            message = messaging.MulticastMessage(
                tokens=registration_tokens,
                data={
                    'type': 'new_article',
                    'article_id': '128',
                },
                notification=messaging.Notification(
                    title='作品が完成しました！',
                    body='Happy Birthday を使った作品が完成しました',
                ),
            )

            response = messaging.send_multicast(message)

            print('{0} messages were sent successfully'.format(
                response.success_count))

            if response.failure_count > 0:
                responses = response.responses
                failed_tokens = []
                for idx, resp in enumerate(responses):
                    if not resp.success:
                        failed_tokens.append(registration_tokens[idx])

                print('List of tokens that caused failures: {0}'.format(
                    failed_tokens))

    return {
        'id': export_base_name,
        'path': export_relative_path,
    }
