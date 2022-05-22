# coding: utf-8

from datetime import datetime

from flask import url_for

from utils import detect_non_silence, generate_piece, generate_store_file_name

_STATIC_DIRECTORY = 'static'
_TEMPLATES_DIRECTORY = 'templates'
_UPLOADS_DIRECTORY = 'uploads'
_EXPORTS_DIRECTORY = 'exports'


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


def submit(request):
    request_params_json = request.json

    user_id = request_params_json['userId']
    template_id = request_params_json['templateId']
    file_name_bases = request_params_json['fileNames']
    file_paths = [
        (f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/'
         f'{file_name_base}')
        for file_name_base in file_name_bases
    ]

    # TODO: ファイルの存在を確認するバリデーションチェック
    # TODO: 鳴き声が2つ存在することを確認するバリデーションチェック

    template_path = (f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/'
                     f'{template_id}.wav')

    current = datetime.now()
    export_file_name = current.strftime('%Y%m%d%H%M%S')
    export_base_path_on_static = f'{_EXPORTS_DIRECTORY}/{export_file_name}'
    export_base_path = f'{_STATIC_DIRECTORY}/{export_base_path_on_static}'

    export_path = generate_piece(
        template_path=template_path,
        sound_paths=file_paths,
        export_base_path=export_base_path,
    )

    export_url_path = url_for('static', filename=export_path)

    return {
        'id': export_file_name,
        'path': export_url_path,
    }
