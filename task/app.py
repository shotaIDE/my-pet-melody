# coding: utf-8

import os

from flask import Flask, request

import main

app = Flask(__name__)

_IS_LOCAL = os.environ.get('FUNCTION_NAME') is None


@app.route("/", methods=['POST'])
def hello_world():
    return main.hello_world(request)


@app.route('/upload', methods=['POST'])
def upload_file():
    if _IS_LOCAL:
        return main.upload_file_local(request)
    else:
        return main.upload_file_remote(request)


@app.route('/detect', methods=['POST'])
def detect_non_silence():
    if _IS_LOCAL:
        return main.detect_non_silence_local(request)
    else:
        return main.detect_non_silence_remote(request)


@app.route('/hello_get', methods=['GET'])
def index():
    return main.hello_get(request)
