# coding: utf-8

import functools
import os
from datetime import datetime

from flask import Flask, request, url_for
from pydub import AudioSegment

app = Flask(__name__)

_STATIC_DIRECTORY = 'static'
_TEMPLATES_DIRECTORY = 'templates'
_UPLOADS_DIRECTORY = 'uploads'
_EXPORTS_DIRECTORY = 'exports'
_OUTPUT_SOUND_EXTENSION = '.mp3'


@app.route("/", methods=['POST'])
def hello_world():
    request_params_json = request.json

    user_id = request_params_json['userId']
    template_id = request_params_json['templateId']
    file_name_bases = request_params_json['fileNames']
    file_names = [
        (f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/'
         f'{file_name_base}')
        for file_name_base in file_name_bases
    ]

    # TODO: ファイルの存在を確認するバリデーションチェック
    # TODO: 鳴き声が2つ存在することを確認するバリデーションチェック

    template = AudioSegment.from_file(
        f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/{template_id}.wav'
    )
    sounds = [
        AudioSegment.from_file(file_name)
        for file_name in file_names
    ]

    normalized_sounds = [
        sound.normalize(headroom=1.0)
        for sound in sounds
    ]

    overlayed = template

    overlayed = overlayed.overlay(normalized_sounds[0], position=3159)
    overlayed = overlayed.overlay(normalized_sounds[1], position=6941)
    overlayed = overlayed.overlay(normalized_sounds[0], position=10099)
    overlayed = overlayed.overlay(normalized_sounds[1], position=10754)
    overlayed = overlayed.overlay(normalized_sounds[0], position=14612)
    overlayed = overlayed.overlay(normalized_sounds[1], position=15352)

    normalized_overlayed = overlayed.normalize(headroom=1.0)

    current = datetime.now()
    export_file_name_base_prefix = current.strftime('%Y%m%d%H%M%S')
    export_file_name_base = (f'{export_file_name_base_prefix}'
                             f'{_OUTPUT_SOUND_EXTENSION}')
    export_path_on_static = f'{_EXPORTS_DIRECTORY}/{export_file_name_base}'

    export_path = f'{_STATIC_DIRECTORY}/{export_path_on_static}'

    normalized_overlayed.export(export_path)

    export_url_path = url_for('static', filename=export_path_on_static)

    return {
        'id': export_file_name_base,
        'path': export_url_path,
    }


@app.route('/upload', methods=['POST'])
def upload_file():
    f = request.files['file']

    file_name = f.filename
    splitted_file_name = os.path.splitext(file_name)

    current = datetime.now()
    store_file_name_base = current.strftime('%Y%m%d%H%M%S')
    store_file_name = f'{store_file_name_base}{splitted_file_name[1]}'
    store_file_extension = splitted_file_name[1]
    store_path_on_static = f'{_UPLOADS_DIRECTORY}/{store_file_name}'

    store_path = f'{_STATIC_DIRECTORY}/{store_path_on_static}'

    f.save(store_path)

    store_url_path = url_for('static', filename=store_path_on_static)

    return {
        'id': store_file_name_base,
        'extension': store_file_extension,
        'path': store_url_path,
    }
