# coding: utf-8

import os
import statistics
import tempfile
from datetime import datetime
from fileinput import filename

from flask import url_for
from google.cloud import storage
from pydub import AudioSegment, silence

_STATIC_DIRECTORY = 'static'
_TEMPLATES_DIRECTORY = 'templates'
_UPLOADS_DIRECTORY = 'uploads'
_EXPORTS_DIRECTORY = 'exports'
_OUTPUT_SOUND_EXTENSION = '.mp3'


def hello_world(request):
    request_params_json = request.json

    user_id = request_params_json['userId']
    template_id = request_params_json['templateId']
    file_name_bases = request_params_json['fileNames']
    file_names = [
        (f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/'
         f'{file_name_base}')
        for file_name_base in file_name_bases
    ]

    # TODO: ファイルの存在を確認するバリデーションチェック
    # TODO: 鳴き声が2つ存在することを確認するバリデーションチェック

    template = AudioSegment.from_file(
        f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/{template_id}.wav'
    )
    sounds = [
        AudioSegment.from_file(file_name)
        for file_name in file_names
    ]

    normalized_sounds = [
        sound.normalize(headroom=1.0)
        for sound in sounds
    ]

    overlayed = template

    overlayed = overlayed.overlay(normalized_sounds[0], position=3159)
    overlayed = overlayed.overlay(normalized_sounds[1], position=6941)
    overlayed = overlayed.overlay(normalized_sounds[0], position=10099)
    overlayed = overlayed.overlay(normalized_sounds[1], position=10754)
    overlayed = overlayed.overlay(normalized_sounds[0], position=14612)
    overlayed = overlayed.overlay(normalized_sounds[1], position=15352)

    normalized_overlayed = overlayed.normalize(headroom=1.0)

    current = datetime.now()
    export_file_name_base_prefix = current.strftime('%Y%m%d%H%M%S')
    export_file_name_base = (f'{export_file_name_base_prefix}'
                             f'{_OUTPUT_SOUND_EXTENSION}')
    export_path_on_static = f'{_EXPORTS_DIRECTORY}/{export_file_name_base}'

    export_path = f'{_STATIC_DIRECTORY}/{export_path_on_static}'

    normalized_overlayed.export(export_path)

    export_url_path = url_for('static', filename=export_path_on_static)

    return {
        'id': export_file_name_base,
        'path': export_url_path,
    }


def upload_file_local(request):
    f = request.files['file']

    file_name = f.filename
    store_file_name_base, store_file_extension = _generate_store_file_name(
        file_name=file_name)

    store_file_name = f'{store_file_name_base}{store_file_extension}'
    store_path_on_static = f'{_UPLOADS_DIRECTORY}/{store_file_name}'
    store_path = f'{_STATIC_DIRECTORY}/{store_path_on_static}'

    f.save(store_path)

    store_url_path = url_for('static', filename=store_path_on_static)

    return {
        'id': store_file_name_base,
        'extension': store_file_extension,
        'path': store_url_path,
    }


def upload_file_remote(request):
    _BUCKET_NAME = os.environ['GOOGLE_CLOUD_STORAGE_BUCKET_NAME']

    f = request.files['file']
    file_name = f.filename

    store_file_name_base, store_file_extension = _generate_store_file_name(
        file_name=file_name)

    _, temp_local_base_path = tempfile.mkstemp()
    temp_local_path = f'{temp_local_base_path}{store_file_extension}'

    f.save(temp_local_path)

    store_file_name = f'{store_file_name_base}{store_file_extension}'
    _STORAGE_MEDIA_DIRECTORY = 'media/temp'
    store_path_path = f'{_STORAGE_MEDIA_DIRECTORY}/{store_file_name}'

    storage_client = storage.Client()
    bucket = storage_client.bucket(_BUCKET_NAME)
    blob = bucket.blob(temp_local_path)

    blob.upload_from_filename(store_path_path)

    return {
        'id': store_file_name_base,
        'extension': store_file_extension,
    }


def detect_non_silence_local(request):
    f = request.files['file']

    file_name = f.filename

    store_file_name_base, store_file_extension = _generate_store_file_name(
        file_name=file_name,
    )
    store_file_name = f'{store_file_name_base}{store_file_extension}'
    store_path_on_static = f'{_UPLOADS_DIRECTORY}/{store_file_name}'
    store_path = f'{_STATIC_DIRECTORY}/{store_path_on_static}'

    f.save(store_path)

    return _detect_non_silence(store_path=store_path)


def detect_non_silence_remote(request):
    f = request.files['file']

    file_name = f.filename

    _, store_file_extension = _generate_store_file_name(
        file_name=file_name,
    )

    _, temp_local_base_path = tempfile.mkstemp()

    temp_local_path = f'{temp_local_base_path}{store_file_extension}'

    f.save(temp_local_path)

    return _detect_non_silence(store_path=temp_local_path)


def hello_get(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    Note:
        For more information on how Flask integrates with Cloud
        Functions, see the `Writing HTTP functions` page.
        <https://cloud.google.com/functions/docs/writing/http#http_frameworks>
    """
    return 'Hello World!'


def _generate_store_file_name(file_name: str):
    splitted_file_name = os.path.splitext(file_name)

    current = datetime.now()
    store_file_name_base = current.strftime('%Y%m%d%H%M%S')
    store_file_extension = splitted_file_name[1]

    return (store_file_name_base, store_file_extension)


def _detect_non_silence(store_path: str) -> dict:
    sound = AudioSegment.from_file(store_path)

    duration_seconds = sound.duration_seconds
    duration_milliseconds = int(round(duration_seconds, 3) * 1000)

    normalized_sound = sound.normalize(headroom=1.0)

    non_silences_list_raw = [
        {
            'segments': silence.detect_nonsilent(
                normalized_sound, silence_thresh=threshould),
            'threshould': threshould,
        }
        for threshould in range(-30, -10)
    ]

    non_silences_list = [
        non_silences
        for non_silences in non_silences_list_raw
        if len(non_silences['segments']) > 0
    ]

    # 1000ms との差分の平均が小さい順にソートし、それを候補とする

    non_silences_duratioins = [
        {
            'segment_duration_list': [
                non_silence[1] - non_silence[0]
                for non_silence in non_silences['segments']
            ],
            'threshould': non_silences['threshould'],
        }
        for non_silences in non_silences_list
    ]

    average_list = [
        {
            'segment_duration_average':
                statistics.mean(
                    non_silences_duration['segment_duration_list']),
            'threshould': non_silences_duration['threshould'],
        }
        for non_silences_duration in non_silences_duratioins
    ]

    sorted_average_list = sorted(
        average_list,
        key=lambda x: x['segment_duration_average'])

    target_threshould = sorted_average_list[0]['threshould']

    target_index = target_threshould + 30

    return {
        'segments': non_silences_list_raw[target_index]['segments'],
        'durationMilliseconds': duration_milliseconds,
    }
