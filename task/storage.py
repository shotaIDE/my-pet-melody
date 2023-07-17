# coding: utf-8

import tempfile
from os.path import splitext

from firebase_admin import storage

from storage_rule import (TEMPLATE_EXTENSION, TEMPLATE_FILE_NAME,
                          THUMBNAIL_FILE_NAME)

_USER_MEDIA_RELATIVE_PARENT_PATH = 'userMedia'


def download_template_bgm(template_id: str) -> str:
    bucket = storage.bucket()

    _, local_base_path = tempfile.mkstemp()
    local_path = f'{local_base_path}{TEMPLATE_EXTENSION}'

    relative_path = (
        f'systemMedia/templates/{template_id}/{TEMPLATE_FILE_NAME}'
    )
    blob = bucket.blob(relative_path)

    blob.download_to_filename(local_path)

    return local_path


def upload_template_bgm(template_id: str, file_path: str):
    bucket = storage.bucket()

    relative_path = (
        f'systemMedia/templates/{template_id}/{TEMPLATE_FILE_NAME}'
    )
    blob = bucket.blob(relative_path)

    blob.upload_from_filename(file_path)


def upload_template_thumbnail(template_id: str, file_path: str):
    bucket = storage.bucket()

    relative_path = (
        f'systemMedia/templates/{template_id}/{THUMBNAIL_FILE_NAME}'
    )
    blob = bucket.blob(relative_path)

    blob.upload_from_filename(file_path)


def download_unedited_user_media(uid: str, file_name: str) -> str:
    bucket = storage.bucket()

    splitted_file_name = splitext(file_name)
    file_extension = splitted_file_name[1]

    _, local_base_path = tempfile.mkstemp()
    local_path = f'{local_base_path}{file_extension}'

    parent_relative_directory = (
        f'{_USER_MEDIA_RELATIVE_PARENT_PATH}/{uid}/unedited'
    )
    relative_path = f'{parent_relative_directory}/{file_name}'
    blob = bucket.blob(relative_path)

    blob.download_to_filename(local_path)

    return local_path


def download_edited_user_media(uid: str, file_name: str) -> str:
    _, local_base_path = tempfile.mkstemp()
    splitted_file_name = splitext(file_name)
    file_extension = splitted_file_name[1]
    local_path = f'{local_base_path}{file_extension}'

    bucket = storage.bucket()

    parent_relative_directory = (
        f'{_USER_MEDIA_RELATIVE_PARENT_PATH}/{uid}/edited'
    )
    relative_path = f'{parent_relative_directory}/{file_name}'
    blob = bucket.blob(relative_path)

    blob.download_to_filename(local_path)

    return local_path


def upload_piece_movie(uid: str, file_name: str, file_path: str):
    bucket = storage.bucket()

    parent_relative_directory = (
        f'{_USER_MEDIA_RELATIVE_PARENT_PATH}/{uid}/generatedPieces'
    )
    relative_path = f'{parent_relative_directory}/{file_name}'
    blob = bucket.blob(relative_path)

    blob.upload_from_filename(file_path)


def upload_piece_thumbnail(uid: str, file_name: str, file_path: str):
    bucket = storage.bucket()

    parent_relative_directory = (
        f'{_USER_MEDIA_RELATIVE_PARENT_PATH}/{uid}/generatedThumbnail'
    )
    relative_path = f'{parent_relative_directory}/{file_name}'
    blob = bucket.blob(relative_path)

    blob.upload_from_filename(file_path)
