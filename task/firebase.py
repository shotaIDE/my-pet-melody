# coding: utf-8

import os

import firebase_admin
from firebase_admin import credentials


def initialize_firebase():
    _BUCKET_NAME = os.environ['FIREBASE_STORAGE_BUCKET_NAME']

    cred = credentials.Certificate('firebase-serviceAccountKey.json')
    firebase_admin.initialize_app(cred, {
        'storageBucket': _BUCKET_NAME
    })
