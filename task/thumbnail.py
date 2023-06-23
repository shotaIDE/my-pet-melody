# coding: utf-8

import base64

import cv2

_NUM_SEGMENT = 10
# Apply x2 size when displayed on mobile side
_EQUALLY_DIVIDED_SEGMENT_THUMBNAIL_HEIGHT = 24 * 2
_SPECIFIED_SEGMENT_THUMBNAIL_HEIGHT = 74 * 2


def generate_equally_divided_segments(store_path: str) -> list[str]:
    capture = cv2.VideoCapture(store_path)

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

        base64_images.append(encoded_frame)

    capture.release()

    return base64_images


def generate_specified_segments(
        store_path: str, segments_starts_milliseconds: list[int]
) -> list[str]:
    capture = cv2.VideoCapture(store_path)

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
    _, frame = capture.read()

    height, width = frame.shape[:2]
    new_width = int(
        (resized_height / height) * width
    )
    resized_frame = cv2.resize(
        frame,
        (new_width, resized_height)
    )

    image_encoded_frame = cv2.imencode('.png', resized_frame)[1]

    return base64.b64encode(image_encoded_frame).decode('utf-8')
