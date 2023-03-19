# coding: utf-8

import base64

import cv2

_NUM_SEGMENT = 10


def generate_equally_divided_segments(store_path: str) -> list[str]:
    capture = cv2.VideoCapture(store_path)

    frame_count = int(capture.get(cv2.CAP_PROP_FRAME_COUNT))

    frame_count_for_one_segment = frame_count // _NUM_SEGMENT

    base64_images: list[str] = []

    for i in range(10):
        start_frame = i * frame_count_for_one_segment

        capture.set(cv2.CAP_PROP_POS_FRAMES, start_frame)
        _, frame = capture.read()

        image_encoded_frame = cv2.imencode('.png', frame)[1]

        encoded_frame = base64.b64encode(
            image_encoded_frame.astype('U13')
        ).decode('utf-8')

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

        capture.set(cv2.CAP_PROP_POS_FRAMES, start_frame)
        _, frame = capture.read()

        image_encoded_frame = cv2.imencode('.png', frame)[1]

        encoded_frame = base64.b64encode(
            image_encoded_frame.astype('U13')
        ).decode('utf-8')

        base64_images.append(encoded_frame)

    capture.release()

    return base64_images
