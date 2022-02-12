# coding: utf-8

from flask import Flask
from flask import request
from datetime import datetime

import os

app = Flask(__name__)


@app.route("/", methods=['POST'])
def hello_world():
    user_id = request.json['userId']

    return "<p>Hello, World!</p>"


@app.route('/upload', methods=['POST'])
def upload_file():
    if request.method == 'POST':
        f = request.files['file']

        file_name = f.filename
        splitted_file_name = os.path.splitext(file_name)

        current = datetime.now()
        store_file_name_base = current.strftime('%Y%m%d%H%M%S')
        store_file_name = f'{store_file_name_base}{splitted_file_name[1]}'

        f.save(f'uploads/{store_file_name}')

        return {
            'fileName': store_file_name,
        }
