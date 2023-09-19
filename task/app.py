# coding: utf-8
# test

from flask import Flask, request

import local
from firebase import initialize_firebase

app = Flask(__name__)


initialize_firebase()


@app.route('/upload', methods=['POST'])
def upload():
    return local.upload(request)


@app.route('/detect', methods=['POST'])
def detect():
    return local.detect(request)


@app.route('/submit', methods=['POST'])
def submit():
    return local.submit(request)


@app.route("/piece", methods=['POST'])
def piece():
    return local.piece(request)
