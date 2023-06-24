# coding: utf-8

import json
import os
from datetime import datetime

import pytz
import requests
from dateutil.parser import parse

from auth import verify_authorization_header
from database import (get_registration_tokens, get_template_overlays,
                      set_generated_piece)
from detection import detect_non_silence
from messaging import send_completed_to_generate_piece
from piece import generate_piece_movie, generate_piece_sound
from subscription import fetch_is_premium_plan
from thumbnail import (generate_equally_divided_segments,
                       generate_specified_segments)
from utils import generate_store_file_name

_STATIC_DIRECTORY = 'static'
_TEMPLATES_DIRECTORY = 'templates'
_UPLOADS_DIRECTORY = 'uploads'
_EXPORTS_DIRECTORY = 'exports'


def upload(request):
    f = request.files['file']
    file_name = f.filename

    store_file_name_base, store_file_extension = generate_store_file_name(
        file_name=file_name
    )

    store_file_name = f'{store_file_name_base}{store_file_extension}'
    store_path_path = (
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{store_file_name}'
    )

    f.save(store_path_path)

    return {
        'id': store_file_name_base,
        'extension': store_file_extension,
    }


def detect(request):
    request_params_json = request.json

    uploaded_file_name = request_params_json['fileName']

    uploaded_path = (
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{uploaded_file_name}'
    )

    non_silences = detect_non_silence(store_path=uploaded_path)

    equally_devided_segment_thumbnails = generate_equally_divided_segments(
        store_path=uploaded_path
    )

    non_silence_starts_milliseconds = [
        non_silence[0]
        for non_silence in non_silences['segments']
    ]
    non_silence_segment_thumbnails = generate_specified_segments(
        store_path=uploaded_path,
        segments_starts_milliseconds=non_silence_starts_milliseconds,
    )

    results = {
        'detectedSegments': [
            {
                'startMilliseconds': segment_milliseconds[0],
                'endMilliseconds': segment_milliseconds[1],
                'thumbnailBase64': thumbnail,
            }
            for (segment_milliseconds, thumbnail) in zip(
                non_silences['segments'], non_silence_segment_thumbnails)
        ],
        'equallyDividedSegments': [
            {'thumbnailBase64': thumbnail}
            for thumbnail in equally_devided_segment_thumbnails
        ],
        'durationMilliseconds': non_silences['durationMilliseconds'],
    }

    return results


def submit(request):
    _ = request.headers['authorization']
    purchase_user_id = request.headers['purchase-user-id']
    platform = request.headers['platform']

    is_premium_plan = fetch_is_premium_plan(
        user_id=purchase_user_id,
        platform=platform,
    )

    print(
        f'Purchase user ID: {purchase_user_id}, '
        f'premium plan: {is_premium_plan}'
    )

    return {}


def piece(request):
    authorization_value = request.headers['authorization']

    uid = verify_authorization_header(value=authorization_value)

    request_params_json = request.json

    template_id = request_params_json['templateId']
    sound_base_names = request_params_json['soundFileNames']
    display_name = request_params_json['displayName']
    thumbnail_base_name = request_params_json['thumbnailFileName']

    sound_paths = [
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{sound_base_name}'
        for sound_base_name in sound_base_names
    ]

    # TODO: ファイルの存在を確認するバリデーションチェック
    # TODO: 鳴き声が2つ存在することを確認するバリデーションチェック

    template_path = (f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/'
                     f'{template_id}.wav')

    overlays = get_template_overlays(id=template_id)

    current = datetime.now()
    piece_sound_base_name = f'{current.strftime("%Y%m%d%H%M%S")}_sound'
    piece_sound_base_path = (
        f'{_STATIC_DIRECTORY}/{_EXPORTS_DIRECTORY}/'
        f'{piece_sound_base_name}'
    )

    piece_sound_path = generate_piece_sound(
        template_path=template_path,
        sound_paths=sound_paths,
        overlays=overlays,
        export_base_path=piece_sound_base_path,
    )

    thumbnail_path = (
        f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/{thumbnail_base_name}'
    )

    piece_thumbnail_base_name = f'{current.strftime("%Y%m%d%H%M%S")}_thumbnail'
    piece_thumbnail_base_path = (
        f'{_STATIC_DIRECTORY}/{_EXPORTS_DIRECTORY}/'
        f'{piece_thumbnail_base_name}'
    )

    piece_movie_base_name = f'{current.strftime("%Y%m%d%H%M%S")}_movie'
    piece_movie_base_path = (
        f'{_STATIC_DIRECTORY}/{_EXPORTS_DIRECTORY}/'
        f'{piece_movie_base_name}'
    )

    (piece_movie_path, piece_thumbnail_path) = generate_piece_movie(
        thumbnail_path=thumbnail_path,
        piece_sound_path=piece_sound_path,
        title=display_name,
        thumbnail_export_base_path=piece_thumbnail_base_path,
        movie_export_base_path=piece_movie_base_path,
    )

    splitted_piece_movie_file_name = os.path.splitext(piece_movie_path)
    piece_movie_extension = splitted_piece_movie_file_name[1]
    piece_movie_file_name = (
        f'{piece_movie_base_name}{piece_movie_extension}'
    )

    splitted_piece_thumbnail_file_name = os.path.splitext(piece_thumbnail_path)
    piece_thumbnail_extension = splitted_piece_thumbnail_file_name[1]
    piece_thumbnail_file_name = (
        f'{piece_thumbnail_base_name}{piece_thumbnail_extension}'
    )

    set_generated_piece(
        uid=uid,
        id=None,
        display_name=display_name,
        thumbnail_file_name=piece_thumbnail_file_name,
        movie_file_name=piece_movie_file_name,
        generated_at=current
    )

    registration_tokens = get_registration_tokens(uid=uid)

    if registration_tokens is not None:
        send_completed_to_generate_piece(
            display_name=display_name,
            registration_tokens=registration_tokens
        )

    return {}
