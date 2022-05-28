# coding: utf-8

import os

import firebase_admin
from firebase_admin import credentials
from flask import Flask, request

import local

app = Flask(__name__)

_BUCKET_NAME = os.environ['FIREBASE_STORAGE_BUCKET_NAME']


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
    cred = credentials.Certificate('firebase-serviceAccountKey.json')
    firebase_admin.initialize_app(cred, {
        'storageBucket': _BUCKET_NAME
    })
