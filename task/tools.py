# coding: utf-8

import json
import os

from database import set_template
from firebase import initialize_firebase


def generate_template():
    initialize_firebase()

    parent_directory = 'templates'
    target_directories = os.listdir(path=parent_directory)

    for target_directory in target_directories:
        meta_json_path = f'{parent_directory}/{target_directory}/meta.json'
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

        template_doc = set_template(
            name=meta_json['name'],
            overlays=overlays,
        )

        print(template_doc)


if __name__ == '__main__':
    generate_template()
