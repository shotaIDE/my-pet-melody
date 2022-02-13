# coding: utf-8

import functools
import os
from datetime import datetime

from flask import Flask, request
from pydub import AudioSegment

app = Flask(__name__)

_TEMPLATES_DIRECTORY = 'templates'
_UPLOADS_DIRECTORY = 'uploads'
_EXPORTS_DIRECTORY = 'exports'


@app.route("/", methods=['POST'])
def hello_world():
    request_params_json = request.json

    user_id = request_params_json['userId']
    template_id = request_params_json['templateId']
    file_name_bases = request_params_json['fileNames']
    file_names = [
        f'{_UPLOADS_DIRECTORY}/{file_name_base}'
        for file_name_base in file_name_bases
    ]

    # TODO: ファイルの存在を確認するバリデーションチェック

    template = AudioSegment.from_file(f'{_TEMPLATES_DIRECTORY}/{template_id}.wav')
    sounds = [
        AudioSegment.from_file(file_name)
        for file_name in file_names
    ]

    normalized_sounds = [
        sound.normalize(headroom=1.0)
        for sound in sounds
    ]

    overlayed = template

    for index, normalized_sound in enumerate(normalized_sounds):
        position_milliseconds = 1000 * index
        overlayed = overlayed.overlay(
            normalized_sound,
            position=position_milliseconds
        )

    normalized_overlayed = overlayed.normalize(headroom=1.0)

    current = datetime.now()
    export_file_name_base = current.strftime('%Y%m%d%H%M%S')
    export_file_path = f'{_EXPORTS_DIRECTORY}/{export_file_name_base}.mp3'

    normalized_overlayed.export(export_file_path)

    return {
        'id': export_file_name_base,
        'url': export_file_path,
    }


@app.route('/upload', methods=['POST'])
def upload_file():
    f = request.files['file']

    file_name = f.filename
    splitted_file_name = os.path.splitext(file_name)

    current = datetime.now()
    store_file_name_base = current.strftime('%Y%m%d%H%M%S')
    store_file_name = f'{store_file_name_base}{splitted_file_name[1]}'

    f.save(f'{_UPLOADS_DIRECTORY}/{store_file_name}')

    return {
        'fileName': store_file_name,
    }
