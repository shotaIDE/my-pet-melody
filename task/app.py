# coding: utf-8

import os

from flask import Flask, request

import local
import main

app = Flask(__name__)

_IS_LOCAL = os.environ.get('FUNCTION_NAME') is None


@app.route("/", methods=['POST'])
def hello_world():
    return main.hello_world(request)


@app.route('/upload', methods=['POST'])
def upload():
    if _IS_LOCAL:
        return local.upload(request)
    else:
        return main.upload(request)


@app.route('/detect', methods=['POST'])
def detect_non_silence():
    if _IS_LOCAL:
        return local.detect(request)
    else:
        return main.detect(request)


@app.route('/hello_get', methods=['GET'])
def index():
    return main.hello_get(request)
