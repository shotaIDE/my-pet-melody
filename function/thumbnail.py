# coding: utf-8

import base64

import cv2

from storage_rule import THUMBNAIL_EXTENSION

_NUM_SEGMENT = 10
# Apply x2 size when displayed on mobile side
_EQUALLY_DIVIDED_SEGMENT_THUMBNAIL_HEIGHT = 24 * 2
_SPECIFIED_SEGMENT_THUMBNAIL_HEIGHT = 74 * 2


def generate_equally_divided_segments(sound_path: str) -> list[str]:
    capture = cv2.VideoCapture(sound_path)

    frame_count = int(capture.get(cv2.CAP_PROP_FRAME_COUNT))

    frame_count_for_one_segment = frame_count // _NUM_SEGMENT

    base64_images: list[str] = []

    for i in range(_NUM_SEGMENT):
        start_frame = i * frame_count_for_one_segment

        encoded_frame = _get_resized_base64_frame(
            capture=capture,
            start_frame=start_frame,
            resized_height=_EQUALLY_DIVIDED_SEGMENT_THUMBNAIL_HEIGHT
        )

        if encoded_frame is None:
            # Workaround when frame is not read.
            base64_images.append(base64_images[-1])
            continue

        base64_images.append(encoded_frame)

    capture.release()

    return base64_images


def generate_specified_segments(
        sound_path: str, segments_starts_milliseconds: list[int]
) -> list[str]:
    capture = cv2.VideoCapture(sound_path)

    fps = int(capture.get(cv2.CAP_PROP_FPS))

    base64_images: list[str] = []

    for segment_starts_milliseconds in segments_starts_milliseconds:
        start_frame = fps * (segment_starts_milliseconds / 1000)

        encoded_frame = _get_resized_base64_frame(
            capture=capture,
            start_frame=start_frame,
            resized_height=_SPECIFIED_SEGMENT_THUMBNAIL_HEIGHT
        )

        base64_images.append(encoded_frame)            

    capture.release()

    return base64_images


def _get_resized_base64_frame(
        capture,
        start_frame: int,
        resized_height: int,
) -> str:
    capture.set(cv2.CAP_PROP_POS_FRAMES, start_frame)
    result, frame = capture.read()
    if not result:
        # Ignore when the frame is not read.
        # This is a known issue with OpenCV loading video files.
        # See the following for more details:
        # https://stackoverflow.com/questions/31472155/python-opencv-cv2-cv-cv-cap-prop-frame-count-get-wrong-numbers
        # https://qiita.com/mwww/items/750b38d51010f74a98b0
        print("Failed to read frame at position:", start_frame)
        return None

    height, width = frame.shape[:2]
    new_width = int(
        (resized_height / height) * width
    )
    resized_frame = cv2.resize(
        frame,
        (new_width, resized_height)
    )

    image_encoded_frame = cv2.imencode(THUMBNAIL_EXTENSION, resized_frame)[1]

    return base64.b64encode(image_encoded_frame).decode('utf-8')
