# coding: utf-8

from storage_path import TEMPLATE_EXTENSION
from utils import generate_store_file_name

_STATIC_DIRECTORY = 'static'
_TEMPLATES_DIRECTORY = 'templates'
_UPLOADS_DIRECTORY = 'uploads'
_EXPORTS_DIRECTORY = 'exports'


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


def get_template_bgm_path(id: str) -> str:
    return (
        f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/'
        f'{id}{TEMPLATE_EXTENSION}'
    )


def get_unedited_user_media_path(file_name: str) -> str:
    return (
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{file_name}'
    )


def get_uploaded_thumbnail_path(id: str) -> str:
    return (
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{id}'
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
