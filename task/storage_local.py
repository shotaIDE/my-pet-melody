# coding: utf-8

import os
from shutil import copyfile

from storage_rule import TEMPLATE_FILE_NAME, THUMBNAIL_FILE_NAME

_PARENT_DIRECTORY = 'static'
_TEMPLATES_DIRECTORY = f'{_PARENT_DIRECTORY}/templates'
_UNEDITED_USER_MEDIA_DIRECTORY = f'{_PARENT_DIRECTORY}/uploads'
_EDITED_USER_MEDIA_DIRECTORY = f'{_PARENT_DIRECTORY}/uploads'
_GENERATED_PIECE_DIRECTORY = f'{_PARENT_DIRECTORY}/exports'
_GENERATED_THUMBNAIL_DIRECTORY = f'{_PARENT_DIRECTORY}/exports'


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
    os.makedirs(name=_UNEDITED_USER_MEDIA_DIRECTORY, exist_ok=True)

    destination_file_path = f'{_UNEDITED_USER_MEDIA_DIRECTORY}/{file_name}'
    copyfile(file_path, destination_file_path)


def download_unedited_user_media(file_name: str) -> str:
    return (
        f'{_UNEDITED_USER_MEDIA_DIRECTORY}/{file_name}'
    )


def download_edited_user_media(file_name: str) -> str:
    return (
        f'{_EDITED_USER_MEDIA_DIRECTORY}/{file_name}'
    )


def upload_piece_movie(file_name: str, file_path: str):
    os.makedirs(name=_GENERATED_PIECE_DIRECTORY, exist_ok=True)

    destination_path = f'{_GENERATED_PIECE_DIRECTORY}/{file_name}'
    copyfile(file_path, destination_path)


def upload_piece_thumbnail(file_name: str, file_path: str):
    os.makedirs(name=_GENERATED_THUMBNAIL_DIRECTORY, exist_ok=True)

    destination_path = f'{_GENERATED_THUMBNAIL_DIRECTORY}/{file_name}'
    copyfile(file_path, destination_path)


def _get_template_directory(template_id: str):
    return f'{_TEMPLATES_DIRECTORY}/{template_id}'
