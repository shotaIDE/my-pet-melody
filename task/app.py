# coding: utf-8

import os

from flask import Flask, request

import local
import main

app = Flask(__name__)

_IS_LOCAL = os.environ.get('FUNCTION_NAME') is None


@app.route('/upload', methods=['POST'])
def upload():
    if _IS_LOCAL:
        return local.upload(request)
    else:
        return main.upload(request)


@app.route('/detect', methods=['POST'])
def detect():
    if _IS_LOCAL:
        return local.detect(request)
    else:
        return main.detect(request)


@app.route("/submit", methods=['POST'])
def submit():
    return main.submit(request)


@app.route("/piece", methods=['POST'])
def piece():
    if _IS_LOCAL:
        return local.piece(request)
    else:
        return main.piece(request)
