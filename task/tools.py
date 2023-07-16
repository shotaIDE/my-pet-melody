# coding: utf-8

import json
import os
from shutil import copyfile

from database import set_template
from firebase import initialize_firebase
from storage import TEMPLATE_FILE_NAME, THUMBNAIL_FILE_NAME

_STATIC_DIRECTORY = 'static'
_TEMPLATES_DIRECTORY = 'templates'


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
        if meta_version != 1:
            print(
                f'Invalid meta version: {meta_version}, '
                'so skipped this template.'
            )
            continue

        position_seconds_list: list[float] \
            = meta_json['recipe']['overlayPositionsMilliseconds']

        overlays = [
            {
                'positionMilliseconds': int(position_seconds * 1000),
                'soundTag': 'sound1',
            }
            for position_seconds in position_seconds_list
        ]

        template_id = set_template(
            name=meta_json['name'],
            overlays=overlays,
        )

        print(f'Created template: ID={template_id}')

        if use_firebase_storage:
            continue

        else:
            template_parent_directory = (
                f'{_STATIC_DIRECTORY}/{_TEMPLATES_DIRECTORY}/{template_id}'
            )
            os.makedirs(template_parent_directory)

            bgm_source_path = f'{target_directory}/{TEMPLATE_FILE_NAME}'
            bgm_destination_directory\
                = f'{template_parent_directory}/{TEMPLATE_FILE_NAME}'
            copyfile(bgm_source_path, bgm_destination_directory)
            print(
                f'Copied BGM file "{bgm_source_path}" to '
                f'"{bgm_destination_directory}"'
            )

            thumbnail_source_path = f'{target_directory}/{THUMBNAIL_FILE_NAME}'
            thumbnail_destination_directory\
                = f'{template_parent_directory}/{TEMPLATE_FILE_NAME}'
            copyfile(thumbnail_source_path, thumbnail_destination_directory)
            print(
                f'Copied thumbnail file "{thumbnail_source_path}" to '
                f'"{thumbnail_destination_directory}"'
            )


if __name__ == '__main__':
    generate_template()
