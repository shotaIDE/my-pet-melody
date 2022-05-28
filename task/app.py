# coding: utf-8

import os

from flask import Flask, request

import local
from firebase import initialize_firebase

app = Flask(__name__)


@app.route('/upload', methods=['POST'])
def upload():
    return local.upload(request)


@app.route('/detect', methods=['POST'])
def detect():
    return local.detect(request)


@app.route("/piece", methods=['POST'])
def piece():
    return local.piece(request)


if __name__ == '__main__':
    initialize_firebase()
