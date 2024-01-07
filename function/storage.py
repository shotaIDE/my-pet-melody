# coding: utf-8

import os
import tempfile

from storage_rule import (TEMPLATE_EXTENSION, TEMPLATE_FILE_NAME,
                          THUMBNAIL_FILE_NAME)


def download_template_bgm(template_id: str) -> str:
    _, local_base_path = tempfile.mkstemp()
    local_path = f'{local_base_path}{TEMPLATE_EXTENSION}'

    parent_relative_directory = \
        _get_template_directory(template_id=template_id)
    relative_path = f'{parent_relative_directory}/{TEMPLATE_FILE_NAME}'

    _download(relative_path=relative_path, local_path=local_path)

    return local_path


def upload_template_bgm(template_id: str, file_path: str):
    parent_relative_directory = \
        _get_template_directory(template_id=template_id)
    relative_path = f'{parent_relative_directory}/{TEMPLATE_FILE_NAME}'

    _upload(relative_path=relative_path, local_path=file_path)


def upload_template_thumbnail(template_id: str, file_path: str):
    parent_relative_directory = \
        _get_template_directory(template_id=template_id)
    relative_path = f'{parent_relative_directory}/{THUMBNAIL_FILE_NAME}'

    _upload(relative_path=relative_path, local_path=file_path)


def download_unedited_user_media(uid: str, file_name: str) -> str:
    splitted_file_name = os.path.splitext(file_name)
    file_extension = splitted_file_name[1]

    _, local_base_path = tempfile.mkstemp()
    local_path = f'{local_base_path}{file_extension}'

    parent_relative_directory = \
        _get_unedited_user_media_relative_directory(uid=uid)
    relative_path = f'{parent_relative_directory}/{file_name}'

    _download(relative_path=relative_path, local_path=local_path)

    return local_path


def download_edited_user_media(uid: str, file_name: str) -> str:
    splitted_file_name = os.path.splitext(file_name)
    file_extension = splitted_file_name[1]

    _, local_base_path = tempfile.mkstemp()
    local_path = f'{local_base_path}{file_extension}'

    parent_relative_directory = \
        _get_edited_user_media_relative_directory(uid=uid)
    relative_path = f'{parent_relative_directory}/{file_name}'

    _download(relative_path=relative_path, local_path=local_path)

    return local_path


def upload_piece_movie(uid: str, file_name: str, file_path: str):
    parent_relative_directory = \
        _get_generated_pieces_relative_directory(uid=uid)
    relative_path = f'{parent_relative_directory}/{file_name}'

    _upload(relative_path=relative_path, local_path=file_path)


def upload_piece_thumbnail(uid: str, file_name: str, file_path: str):
    parent_relative_directory = \
        _get_generated_thumbnail_relative_directory(uid=uid)
    relative_path = f'{parent_relative_directory}/{file_name}'

    _upload(relative_path=relative_path, local_path=file_path)


def _get_template_directory(template_id: str):
    return f'systemMedia/templates/{template_id}'


def _get_unedited_user_media_relative_directory(uid: str):
    return _get_user_temporary_media_parent_relative_directory(
        uid=uid,
        type='unedited'
    )


def _get_edited_user_media_relative_directory(uid: str):
    return _get_user_temporary_media_parent_relative_directory(
        uid=uid,
        type='edited'
    )


def _get_generated_pieces_relative_directory(uid: str):
    user_media_parent_directory = \
        _get_user_media_parent_relative_directory(uid=uid)
    return f'{user_media_parent_directory}/generatedPieces'


def _get_generated_thumbnail_relative_directory(uid: str):
    user_media_parent_directory = \
        _get_user_media_parent_relative_directory(uid=uid)
    return f'{user_media_parent_directory}/generatedThumbnail'


def _get_user_temporary_media_parent_relative_directory(uid: str, type: str):
    return f'userTemporaryMedia/{type}/{uid}'


def _get_user_media_parent_relative_directory(uid: str):
    return f'userMedia/{uid}'


def _download(relative_path: str, local_path: str):
    bucket = storage.bucket()

    blob = bucket.blob(relative_path)

    blob.download_to_filename(local_path)


def _upload(relative_path: str, local_path: str):
    bucket = storage.bucket()

    blob = bucket.blob(relative_path)

    blob.upload_from_filename(local_path)
