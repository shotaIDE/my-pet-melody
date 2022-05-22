# coding: utf-8

from flask import url_for

from utils import detect_non_silence, generate_store_file_name

_STATIC_DIRECTORY = 'static'
_UPLOADS_DIRECTORY = 'uploads'


def upload(request):
    f = request.files['file']

    file_name = f.filename
    store_file_name_base, store_file_extension = generate_store_file_name(
        file_name=file_name)

    store_file_name = f'{store_file_name_base}{store_file_extension}'
    store_path_on_static = f'{_UPLOADS_DIRECTORY}/{store_file_name}'
    store_path = f'{_STATIC_DIRECTORY}/{store_path_on_static}'

    f.save(store_path)

    store_url_path = url_for('static', filename=store_path_on_static)

    return {
        'id': store_file_name_base,
        'extension': store_file_extension,
        'path': store_url_path,
    }


def detect(request):
    f = request.files['file']

    file_name = f.filename

    store_file_name_base, store_file_extension = generate_store_file_name(
        file_name=file_name,
    )
    store_file_name = f'{store_file_name_base}{store_file_extension}'
    store_path_on_static = f'{_UPLOADS_DIRECTORY}/{store_file_name}'
    store_path = f'{_STATIC_DIRECTORY}/{store_path_on_static}'

    f.save(store_path)

    return detect_non_silence(store_path=store_path)
