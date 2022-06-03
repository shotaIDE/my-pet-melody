# coding: utf-8

from database import set_template
from firebase import initialize_firebase


def generate_template():
    initialize_firebase()

    position_seconds_list: list[int] = [
        2.419,
        5.323,
        7.742,
        8.226,
        10.161,
        10.645,
        11.129,
        11.613,
        11.855,
        12.097,
        13.306,
        13.548,
        14.032,
        14.395,
        14.516,
        16.210,
        16.452,
        16.694,
        16.935,
        17.056,
        17.298,
        17.903,
        19.355,
        19.597,
        19.839,
        20.806,
        21.290,
        21.774,
        22.258,
    ]

    overlays = [
        {
            'positionMilliseconds': int(position_seconds * 1000),
            'soundTag': 'sound1',
        }
        for position_seconds in position_seconds_list
    ]

    set_template(
        name='Happy Birthday サンバver',
        overlays=overlays,
    )


if __name__ == '__main__':
    generate_template()
