# coding: utf-8

import os
from datetime import datetime

from flask import Flask, request

app = Flask(__name__)

_UPLOAD_DIRECTORY = 'uploads'


@app.route("/", methods=['POST'])
def hello_world():
    user_id = request.json['userId']
    file_name_bases = request.json['fileNames']
    file_names = [
        f'{_UPLOAD_DIRECTORY}/{file_name_base}'
        for file_name_base in file_name_bases
    ]

    # TODO: ファイルの存在を確認するバリデーションチェック

    return {
        'message': 'OK',
    }


@app.route('/upload', methods=['POST'])
def upload_file():
    f = request.files['file']

    file_name = f.filename
    splitted_file_name = os.path.splitext(file_name)

    current = datetime.now()
    store_file_name_base = current.strftime('%Y%m%d%H%M%S')
    store_file_name = f'{store_file_name_base}{splitted_file_name[1]}'

    f.save(f'{_UPLOAD_DIRECTORY}/{store_file_name}')

    return {
        'fileName': store_file_name,
    }
