# coding: utf-8

import os
import tempfile
from datetime import datetime

from google.cloud import storage

from utils import detect_non_silence, generate_piece, generate_store_file_name

_BUCKET_NAME = os.environ['GOOGLE_CLOUD_STORAGE_BUCKET_NAME']

_UPLOADED_MOVIE_DIRECTORY = 'temp/uploadedMovies'
_SYSTEM_MEDIA_DIRECTORY = 'temp/systemMedia'
_TEMPLATE_FILE_BASE_NAME = 'template'
_TEMPLATE_EXTENSION = '.wav'
_TEMPLATE_FILE_NAME = f'{_TEMPLATE_FILE_BASE_NAME}{_TEMPLATE_EXTENSION}'
_GENERATED_PIECE_DIRECTORY = 'temp/generatedPieces'


def upload(request):
    f = request.files['file']
    file_name = f.filename

    store_file_name_base, store_file_extension = generate_store_file_name(
        file_name=file_name)

    _, temp_local_base_path = tempfile.mkstemp()
    temp_local_path = f'{temp_local_base_path}{store_file_extension}'

    f.save(temp_local_path)

    store_file_name = f'{store_file_name_base}{store_file_extension}'
    store_path_path = f'{_UPLOADED_MOVIE_DIRECTORY}/{store_file_name}'

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


def submit(request):
    request_params_json = request.json

    template_id = request_params_json['templateId']
    sound_base_names = request_params_json['fileNames']

    storage_client = storage.Client()
    bucket = storage_client.bucket(_BUCKET_NAME)

    _, template_local_base_path = tempfile.mkstemp()
    template_local_path = f'{template_local_base_path}{_TEMPLATE_EXTENSION}'

    template_relative_path = (
        f'{_SYSTEM_MEDIA_DIRECTORY}/{template_id}/{_TEMPLATE_FILE_NAME}'
    )
    template_blob = bucket.blob(template_relative_path)

    template_blob.download_to_filename(template_local_path)

    sound_local_paths = []
    for sound_base_name in sound_base_names:
        _, sound_local_base_path = tempfile.mkstemp()
        splitted_file_name = os.path.splitext(sound_base_name)
        sound_extension = splitted_file_name[1]
        sound_local_path = f'{sound_local_base_path}{sound_extension}'

        sound_relative_path = f'{_UPLOADED_MOVIE_DIRECTORY}/{sound_base_name}'
        sound_blob = bucket.blob(sound_relative_path)

        sound_blob.download_to_filename(sound_local_path)

        sound_local_paths.append(sound_local_path)

    # TODO: ファイルの存在を確認するバリデーションチェック
    # TODO: 鳴き声が2つ存在することを確認するバリデーションチェック

    _, export_local_base_path = tempfile.mkstemp()

    export_local_path = generate_piece(
        template_path=template_local_path,
        sound_paths=sound_local_paths,
        export_base_path=export_local_base_path,
    )

    current = datetime.now()
    export_base_name = current.strftime('%Y%m%d%H%M%S')
    splitted_file_name = os.path.splitext(export_local_path)
    export_extension = splitted_file_name[1]
    export_file_name = f'{export_base_name}{export_extension}'

    export_relative_path = f'{_GENERATED_PIECE_DIRECTORY}/{export_file_name}'
    template_blob = bucket.blob(export_relative_path)

    template_blob.upload_from_filename(export_local_path)

    return {
        'id': export_base_name,
        'path': export_relative_path,
    }
