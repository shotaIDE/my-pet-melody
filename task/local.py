# coding: utf-8

import os
from datetime import datetime

from auth import verify_authorization_header
from database import set_generated_piece, template_overlays
from detection import detect_non_silence
from piece import generate_piece_movie, generate_piece_sound
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

    uploaded_path_on_static = f'{_UPLOADS_DIRECTORY}/{uploaded_file_name}'
    uploaded_path = f'{_STATIC_DIRECTORY}/{uploaded_path_on_static}'

    return detect_non_silence(store_path=uploaded_path)


def piece(request):
    authorization_value = request.headers['authorization']

    uid = verify_authorization_header(value=authorization_value)

    request_params_json = request.json

    template_id = request_params_json['templateId']
    file_name_bases = request_params_json['fileNames']
    display_name = request_params_json['displayName']
    thumbnail_base_name = request_params_json['thumbnailName']

    file_paths = [
        (f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/'
         f'{file_name_base}')
        for file_name_base in file_name_bases
    ]

    # TODO: ファイルの存在を確認するバリデーションチェック
    # TODO: 鳴き声が2つ存在することを確認するバリデーションチェック

    template_path = (f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/'
                     f'{template_id}.wav')

    overlays = template_overlays(id=template_id)

    current = datetime.now()
    sound_export_base_name = f'{current.strftime("%Y%m%d%H%M%S")}_sound'
    sound_export_base_path_on_static = (
        f'{_EXPORTS_DIRECTORY}/{sound_export_base_name}'
    )
    sound_export_base_path = (
        f'{_STATIC_DIRECTORY}/{sound_export_base_path_on_static}'
    )

    piece_sound_export_path = generate_piece_sound(
        template_path=template_path,
        sound_paths=file_paths,
        overlays=overlays,
        export_base_path=sound_export_base_path,
    )

    thumbnail_path = (f'{_STATIC_DIRECTORY}/{_UPLOADS_DIRECTORY}/'
                      f'{thumbnail_base_name}')

    movie_export_base_name = f'{current.strftime("%Y%m%d%H%M%S")}_movie'
    movie_export_base_path_on_static = (
        f'{_EXPORTS_DIRECTORY}/{movie_export_base_name}'
    )
    movie_export_base_path = (
        f'{_STATIC_DIRECTORY}/{movie_export_base_path_on_static}'
    )

    piece_movie_export_path = generate_piece_movie(
        thumbnail_path=thumbnail_path,
        piece_sound_path=piece_sound_export_path,
        export_base_path=movie_export_base_path
    )

    splitted_file_name = os.path.splitext(piece_movie_export_path)
    export_extension = splitted_file_name[1]
    export_file_name = f'{movie_export_base_name}{export_extension}'

    set_generated_piece(
        uid=uid,
        id=None,
        display_name=display_name,
        file_name=export_file_name,
        generated_at=current
    )

    return {}
