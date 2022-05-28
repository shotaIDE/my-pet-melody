# coding: utf-8

import json
import os
import tempfile
from datetime import datetime, timedelta
from xmlrpc.client import DateTime

from firebase_admin import firestore, storage
from google.cloud import tasks_v2
from google.protobuf import timestamp_pb2

from auth import verify_authorization_header
from utils import detect_non_silence

_USER_MEDIA_DIRECTORY_NAME = 'userMedia'


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
        f'{_USER_MEDIA_DIRECTORY_NAME}/{uid}/'
        f'originalMovies/{uploaded_file_name}'
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

    client = tasks_v2.CloudTasksClient()

    parent = client.queue_path(
        _GCP_PROJECT_ID, _TASKS_LOCATION, _TASKS_QUEUE_ID
    )

    body_dict = {
        'uid': uid,
        'pieceId': piece_id,
        'templateId': template_id,
        'fileNames': sound_base_names,
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


def set_generated_piece(
        uid: str, id: str, name: str, file_name: str, generated_at: DateTime):
    store_data = {
        'name': f'Generated Piece: {name}',
        'movieFileName': file_name,
        'generatedAt': generated_at,
    }

    db = firestore.client()

    generated_pieces_collection = db.collection('userMedia').document(
        uid).collection('generatedPieces')

    if id is not None:
        generated_pieces_collection.document(id).update(store_data)
    else:
        store_data['submittedAt'] = generated_at

        generated_pieces_collection.add(store_data)
