# coding: utf-8

import os
from shutil import copyfile

from storage_rule import TEMPLATE_FILE_NAME, THUMBNAIL_FILE_NAME

_PARENT_DIRECTORY = 'static'
_UNEDITED_USER_MEDIA_DIRECTORY = f'{_PARENT_DIRECTORY}/uploads'
_EDITED_USER_MEDIA_DIRECTORY = f'{_PARENT_DIRECTORY}/uploads'
_GENERATED_PIECE_DIRECTORY = f'{_PARENT_DIRECTORY}/exports'
_GENERATED_THUMBNAIL_DIRECTORY = f'{_PARENT_DIRECTORY}/exports'

class NotAllowedPathException(Exception):
    pass


def download_template_bgm(template_id: str) -> str:
    template_directory = _get_template_directory(template_id=template_id)
    return f'{template_directory}/{TEMPLATE_FILE_NAME}'


def upload_template_bgm(template_id: str, file_path: str):
    template_directory = _get_template_directory(template_id=template_id)
    os.makedirs(name=template_directory, exist_ok=True)

    bgm_destination_directory = f'{template_directory}/{TEMPLATE_FILE_NAME}'
    copyfile(file_path, bgm_destination_directory)

    print(f'Copied BGM file "{file_path}" to "{bgm_destination_directory}"')


def upload_template_thumbnail(template_id: str, file_path: str):
    template_directory = _get_template_directory(template_id=template_id)
    os.makedirs(name=template_directory, exist_ok=True)

    thumbnail_destination_directory = \
        f'{template_directory}/{THUMBNAIL_FILE_NAME}'
    copyfile(file_path, thumbnail_destination_directory)

    print(
        f'Copied thumbnail file "{file_path}" '
        f'to "{thumbnail_destination_directory}"'
    )


def upload_user_media(file_name: str, file_path: str):
    destination_file_path = _get_normalized_path(
        base_directory=_UNEDITED_USER_MEDIA_DIRECTORY,
        file_name=file_name
    )

    os.makedirs(name=_UNEDITED_USER_MEDIA_DIRECTORY, exist_ok=True)

    copyfile(file_path, destination_file_path)


def download_unedited_user_media(file_name: str) -> str:
    return _get_normalized_path(
        base_directory=_UNEDITED_USER_MEDIA_DIRECTORY,
        file_name=file_name
    )


def download_edited_user_media(file_name: str) -> str:
    return _get_normalized_path(
        base_directory=_EDITED_USER_MEDIA_DIRECTORY,
        file_name=file_name
    )


def upload_piece_movie(file_name: str, file_path: str):
    os.makedirs(name=_GENERATED_PIECE_DIRECTORY, exist_ok=True)

    destination_file_path = _get_normalized_path(
        base_directory=_GENERATED_PIECE_DIRECTORY,
        file_name=file_name
    )

    copyfile(file_path, destination_file_path)


def upload_piece_thumbnail(file_name: str, file_path: str):
    destination_file_path = _get_normalized_path(
        base_directory=_GENERATED_THUMBNAIL_DIRECTORY,
        file_name=file_name
    )

    os.makedirs(name=_GENERATED_THUMBNAIL_DIRECTORY, exist_ok=True)

    copyfile(file_path, destination_file_path)


def _get_template_directory(template_id: str):
    return _get_normalized_path(
        base_directory=f'{_PARENT_DIRECTORY}/templates',
        file_name=template_id
    )


def _get_normalized_path(base_directory: str, file_name: str) -> str:
    path = os.path.join(base_directory, file_name)
    normalized_path = os.path.normpath(path)
    if not normalized_path.startswith(path):
        raise NotAllowedPathException(
            f'Not allowed file name has been detected: {file_name}'
        )

    return normalized_path
