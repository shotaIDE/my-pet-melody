# coding: utf-8

import tempfile
from os.path import splitext

from firebase_admin import storage

from storage_path import USER_MEDIA_DIRECTORY_NAME


def get_unedited_user_media_path(uid: str, file_name: str) -> str:
    splitted_file_name = splitext(file_name)
    uploaded_extension = splitted_file_name[1]

    bucket = storage.bucket()

    _, uploaded_local_base_path = tempfile.mkstemp()
    uploaded_local_path = f'{uploaded_local_base_path}{uploaded_extension}'

    uploaded_relative_path = (
        f'{USER_MEDIA_DIRECTORY_NAME}/{uid}/'
        f'unedited/{file_name}'
    )
    uploaded_blob = bucket.blob(uploaded_relative_path)

    uploaded_blob.download_to_filename(uploaded_local_path)

    return uploaded_local_path
