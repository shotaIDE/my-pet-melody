# coding: utf-8

import os
import tempfile

from google.cloud import storage

from utils import detect_non_silence, generate_store_file_name

_STORAGE_MEDIA_DIRECTORY = 'media/temp'


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
