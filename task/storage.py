# coding: utf-8

import tempfile
from os.path import splitext

from firebase_admin import storage

from storage_rule import (TEMPLATE_EXTENSION, TEMPLATE_FILE_NAME,
                          THUMBNAIL_FILE_NAME, USER_MEDIA_DIRECTORY_NAME)


def download_template_bgm(template_id: str) -> str:
    bucket = storage.bucket()

    _, template_local_base_path = tempfile.mkstemp()
    template_local_path = f'{template_local_base_path}{TEMPLATE_EXTENSION}'

    template_relative_path = (
        f'systemMedia/templates/{template_id}/{TEMPLATE_FILE_NAME}'
    )
    template_blob = bucket.blob(template_relative_path)

    template_blob.download_to_filename(template_local_path)

    return template_local_path


def upload_template_bgm(template_id: str, file_path: str):
    bucket = storage.bucket()

    template_relative_path = (
        f'systemMedia/templates/{template_id}/{TEMPLATE_FILE_NAME}'
    )
    template_blob = bucket.blob(template_relative_path)
    template_blob.upload_from_filename(file_path)


def upload_template_thumbnail(template_id: str, file_path: str):
    bucket = storage.bucket()

    thumbnail_relative_path = (
        f'systemMedia/templates/{template_id}/{THUMBNAIL_FILE_NAME}'
    )
    thumbnail_blob = bucket.blob(thumbnail_relative_path)
    thumbnail_blob.upload_from_filename(file_path)


def download_unedited_user_media(uid: str, file_name: str) -> str:
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


def download_edited_user_media(uid: str, file_name: str) -> str:
    _, sound_local_base_path = tempfile.mkstemp()
    splitted_piece_movie_file_name = splitext(file_name)
    sound_extension = splitted_piece_movie_file_name[1]
    sound_local_path = f'{sound_local_base_path}{sound_extension}'

    bucket = storage.bucket()

    sound_relative_path = (
        f'{USER_MEDIA_DIRECTORY_NAME}/{uid}/'
        f'edited/{file_name}'
    )
    sound_blob = bucket.blob(sound_relative_path)

    sound_blob.download_to_filename(sound_local_path)

    return sound_local_path


def upload_piece_movie(uid: str, file_name: str, file_path: str):
    bucket = storage.bucket()

    piece_movie_relative_path = (
        f'{USER_MEDIA_DIRECTORY_NAME}/{uid}/'
        f'generatedPieces/{file_name}'
    )
    piece_movie_blob = bucket.blob(piece_movie_relative_path)

    piece_movie_blob.upload_from_filename(file_path)


def upload_piece_thumbnail(uid: str, file_name: str, file_path: str):
    bucket = storage.bucket()

    piece_thumbnail_relative_path = (
        f'{USER_MEDIA_DIRECTORY_NAME}/{uid}/'
        f'generatedThumbnail/{file_name}'
    )
    piece_thumbnail_blob = bucket.blob(piece_thumbnail_relative_path)

    piece_thumbnail_blob.upload_from_filename(file_path)
