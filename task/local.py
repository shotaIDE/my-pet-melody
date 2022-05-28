# coding: utf-8

import os
import tempfile
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
        file_name=file_name
    )

    store_file_name = f'{store_file_name_base}{store_file_extension}'
    store_path_path = (
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{store_file_name}'
    )

    f.save(store_path_path)

    return {
        'id': store_file_name_base,
        'extension': store_file_extension,
    }


def detect(request):
    request_params_json = request.json

    uploaded_file_name = request_params_json['fileName']

    uploaded_path_on_static = f'{_UPLOADS_DIRECTORY}/{uploaded_file_name}'
    uploaded_path = f'{_STATIC_DIRECTORY}/{uploaded_path_on_static}'

    return detect_non_silence(store_path=uploaded_path)


def piece(request):
    request_params_json = request.json

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

    splitted_file_name = os.path.splitext(export_path)
    export_extension = splitted_file_name[1]
    export_path_on_static = f'{export_base_path_on_static}{export_extension}'

    export_url_path = url_for('static', filename=export_path_on_static)

    return {
        'id': export_file_name,
        'path': export_url_path,
    }
