# coding: utf-8

import os
from shutil import copyfile

from storage_path import TEMPLATE_FILE_NAME, THUMBNAIL_FILE_NAME
from utils import generate_store_file_name

_STATIC_DIRECTORY = 'static'
_TEMPLATES_DIRECTORY = 'templates'
_UPLOADS_DIRECTORY = 'uploads'
_EXPORTS_DIRECTORY = 'exports'


def get_template_bgm_path(template_id: str) -> str:
    return (
        f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/'
        f'{template_id}/{TEMPLATE_FILE_NAME}'
    )


def upload_template_bgm(template_id: str, file_path: str):
    template_parent_directory = (
        f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/{template_id}'
    )
    os.makedirs(name=template_parent_directory, exist_ok=True)

    bgm_destination_directory\
        = f'{template_parent_directory}/{TEMPLATE_FILE_NAME}'
    copyfile(file_path, bgm_destination_directory)

    print(f'Copied BGM file "{file_path}" to "{bgm_destination_directory}"')


def upload_template_thumbnail(template_id: str, file_path: str):
    template_parent_directory = (
        f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/{template_id}'
    )
    os.makedirs(name=template_parent_directory, exist_ok=True)

    thumbnail_destination_directory\
        = f'{template_parent_directory}/{THUMBNAIL_FILE_NAME}'
    copyfile(file_path, thumbnail_destination_directory)

    print(
        f'Copied thumbnail file "{file_path}" '
        f'to "{thumbnail_destination_directory}"'
    )


def save_user_media(file, file_name: str) -> str:
    store_file_name_base, store_file_extension = generate_store_file_name(
        file_name=file_name
    )

    store_file_name = f'{store_file_name_base}{store_file_extension}'
    store_path = (
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{store_file_name}'
    )

    file.save(store_path)

    return store_path


def get_unedited_user_media_path(file_name: str) -> str:
    return (
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{file_name}'
    )


def get_edited_user_media_path(file_name: str) -> str:
    return (
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{file_name}'
    )


def get_uploaded_thumbnail_path(file_name: str) -> str:
    return (
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{file_name}'
    )


def get_generated_piece_sound_base_path(id: str) -> str:
    return (
        f'{_STATIC_DIRECTORY}/{_EXPORTS_DIRECTORY}/'
        f'{id}'
    )


def get_generated_thumbnail_base_path(id: str) -> str:
    return (
        f'{_STATIC_DIRECTORY}/{_EXPORTS_DIRECTORY}/'
        f'{id}'
    )


def get_generated_piece_movie_base_path(id: str) -> str:
    return (
        f'{_STATIC_DIRECTORY}/{_EXPORTS_DIRECTORY}/'
        f'{id}'
    )


def upload_piece_movie(file_name: str, file_path: str):
    parent_directory = f'{_STATIC_DIRECTORY}/{_EXPORTS_DIRECTORY}'
    os.makedirs(name=parent_directory, exist_ok=True)

    destination_path = f'{parent_directory}/{file_name}'
    copyfile(file_path, destination_path)


def upload_piece_thumbnail(file_name: str, file_path: str):
    parent_directory = f'{_STATIC_DIRECTORY}/{_EXPORTS_DIRECTORY}'
    os.makedirs(name=parent_directory, exist_ok=True)

    destination_path = f'{parent_directory}/{file_name}'
    copyfile(file_path, destination_path)
