# coding: utf-8

import os
import tempfile
from datetime import datetime

from flask import url_for
from google.cloud import storage
from pydub import AudioSegment

from utils import detect_non_silence, generate_store_file_name

_STATIC_DIRECTORY = 'static'
_TEMPLATES_DIRECTORY = 'templates'
_UPLOADS_DIRECTORY = 'uploads'
_EXPORTS_DIRECTORY = 'exports'
_OUTPUT_SOUND_EXTENSION = '.mp3'


def hello_world(request):
    request_params_json = request.json

    user_id = request_params_json['userId']
    template_id = request_params_json['templateId']
    file_name_bases = request_params_json['fileNames']
    file_names = [
        (f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/'
         f'{file_name_base}')
        for file_name_base in file_name_bases
    ]

    # TODO: ファイルの存在を確認するバリデーションチェック
    # TODO: 鳴き声が2つ存在することを確認するバリデーションチェック

    template = AudioSegment.from_file(
        f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/{template_id}.wav'
    )
    sounds = [
        AudioSegment.from_file(file_name)
        for file_name in file_names
    ]

    normalized_sounds = [
        sound.normalize(headroom=1.0)
        for sound in sounds
    ]

    overlayed = template

    overlayed = overlayed.overlay(normalized_sounds[0], position=3159)
    overlayed = overlayed.overlay(normalized_sounds[1], position=6941)
    overlayed = overlayed.overlay(normalized_sounds[0], position=10099)
    overlayed = overlayed.overlay(normalized_sounds[1], position=10754)
    overlayed = overlayed.overlay(normalized_sounds[0], position=14612)
    overlayed = overlayed.overlay(normalized_sounds[1], position=15352)

    normalized_overlayed = overlayed.normalize(headroom=1.0)

    current = datetime.now()
    export_file_name_base_prefix = current.strftime('%Y%m%d%H%M%S')
    export_file_name_base = (f'{export_file_name_base_prefix}'
                             f'{_OUTPUT_SOUND_EXTENSION}')
    export_path_on_static = f'{_EXPORTS_DIRECTORY}/{export_file_name_base}'

    export_path = f'{_STATIC_DIRECTORY}/{export_path_on_static}'

    normalized_overlayed.export(export_path)

    export_url_path = url_for('static', filename=export_path_on_static)

    return {
        'id': export_file_name_base,
        'path': export_url_path,
    }


def upload(request):
    _BUCKET_NAME = os.environ['GOOGLE_CLOUD_STORAGE_BUCKET_NAME']

    f = request.files['file']
    file_name = f.filename

    store_file_name_base, store_file_extension = generate_store_file_name(
        file_name=file_name)

    _, temp_local_base_path = tempfile.mkstemp()
    temp_local_path = f'{temp_local_base_path}{store_file_extension}'

    f.save(temp_local_path)

    store_file_name = f'{store_file_name_base}{store_file_extension}'
    _STORAGE_MEDIA_DIRECTORY = 'media/temp'
    store_path_path = f'{_STORAGE_MEDIA_DIRECTORY}/{store_file_name}'

    storage_client = storage.Client()
    bucket = storage_client.bucket(_BUCKET_NAME)
    blob = bucket.blob(store_path_path)

    blob.upload_from_filename(temp_local_path)

    return {
        'id': store_file_name_base,
        'extension': store_file_extension,
        'path': store_path_path,
    }


def detect(request):
    f = request.files['file']

    file_name = f.filename

    _, store_file_extension = generate_store_file_name(
        file_name=file_name,
    )

    _, temp_local_base_path = tempfile.mkstemp()

    temp_local_path = f'{temp_local_base_path}{store_file_extension}'

    f.save(temp_local_path)

    return detect_non_silence(store_path=temp_local_path)


def hello_get(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    Note:
        For more information on how Flask integrates with Cloud
        Functions, see the `Writing HTTP functions` page.
        <https://cloud.google.com/functions/docs/writing/http#http_frameworks>
    """
    return 'Hello World!'
