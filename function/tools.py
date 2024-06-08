# coding: utf-8

import json
import os
from datetime import datetime

import storage
import storage_local
from database import set_template
from firebase import initialize_firebase
from storage_rule import TEMPLATE_FILE_NAME, THUMBNAIL_FILE_NAME


def generate_template():
    initialize_firebase()

    use_firebase_storage = os.environ['FEATURE_USE_FIREBASE_STORAGE'] == 'true'

    parent_directory = 'templates'
    target_directory_names = os.listdir(path=parent_directory)

    for target_directory_name in target_directory_names:
        target_directory = f'{parent_directory}/{target_directory_name}'

        meta_json_path = f'{target_directory}/meta.json'
        if not os.path.isfile(meta_json_path):
            continue

        print(f'Registering "{meta_json_path}"...')

        with open(meta_json_path, 'r') as f:
            meta_json = json.load(f)

        meta_version = meta_json['version']
        if meta_version != 2:
            print(
                f'Invalid meta version: {meta_version}, '
                'so skipped this template.'
            )
            continue

        position_seconds_list: list[float] \
            = meta_json['recipe']['overlayPositionSeconds']

        overlays = [
            {
                'positionMilliseconds': int(position_seconds * 1000),
                'soundTag': 'sound1',
            }
            for position_seconds in position_seconds_list
        ]

        template_id = set_template(
            default_name=meta_json['defaultName'],
            published_at=datetime.now(),
            overlays=overlays,
        )

        

        set_localized_template_metadata(
            language_tag='ja',
            template_id=template_id,
            localized_name=meta_json['localized']['ja']['name'],
        )

        print(f'Created template: ID = {template_id}')

        bgm_source_path = f'{target_directory}/{TEMPLATE_FILE_NAME}'
        thumbnail_source_path = f'{target_directory}/{THUMBNAIL_FILE_NAME}'

        if use_firebase_storage:
            storage.upload_template_bgm(
                template_id=template_id,
                file_path=bgm_source_path
            )
            storage.upload_template_thumbnail(
                template_id=template_id,
                file_path=thumbnail_source_path
            )
            continue

        storage_local.upload_template_bgm(
            template_id=template_id,
            file_path=bgm_source_path
        )
        storage_local.upload_template_thumbnail(
            template_id=template_id,
            file_path=thumbnail_source_path
        )


if __name__ == '__main__':
    generate_template()
