# coding: utf-8

from flask import Flask, request

import main

app = Flask(__name__)


@app.route("/", methods=['POST'])
def hello_world():
    return main.hello_world(request)


@app.route('/upload', methods=['POST'])
def upload_file():
    return main.upload_file(request)


@app.route('/detect', methods=['POST'])
def detect_non_silence():
    return main.detect_non_silence(request)


@app.route('/hello_get', methods=['GET'])
def index():
    return main.hello_get(request)
