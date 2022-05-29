# coding: utf-8

import os
import statistics
import time
from datetime import datetime
from typing import Optional

from inaSpeechSegmenter import Segmenter
from pydub import AudioSegment, silence

_OUTPUT_SOUND_EXTENSION = '.mp3'


def generate_store_file_name(file_name: str) -> tuple[str, str]:
    splitted_file_name = os.path.splitext(file_name)

    current = datetime.now()
    store_file_name_base = current.strftime('%Y%m%d%H%M%S')
    store_file_extension = splitted_file_name[1]

    return (store_file_name_base, store_file_extension)


def detect_non_silence(store_path: str) -> dict:
    start_time = time.perf_counter()

    sound = AudioSegment.from_file(store_path)
    duration_seconds: int = sound.duration_seconds
    duration_milliseconds = int(round(duration_seconds, 3) * 1000)

    segmenter = Segmenter(vad_engine='smn')

    segmentations = segmenter(store_path)

    print(f'Detected result(raw): {segmentations}')

    non_silences_list: list[list[int]] = [
        [int(segmentation[1] * 1000), int(segmentation[2] * 1000)]
        for segmentation in segmentations
        if (segmentation[0] == 'speech' or
            segmentation[0] == 'male' or
            segmentation[0] == 'female')
    ]

    print(f'Detected result(ms): {non_silences_list}')

    result = {
        'segments': non_silences_list,
        'durationMilliseconds': duration_milliseconds,
    }

    end_time = time.perf_counter()
    elapsed_time = end_time - start_time
    print(f'Running time to detect non silence: {elapsed_time:.3f}s')

    return result


def generate_piece(
    template_path: str,
    sound_paths: list[str],
    export_base_path: str


) -> str:
    template = AudioSegment.from_file(template_path)
    sounds = [
        AudioSegment.from_file(sound_path)
        for sound_path in sound_paths
    ]

    normalized_sounds = [
        sound.normalize(headroom=1.0)
        for sound in sounds
    ]

    overlayed = template

    overlayed = overlayed.overlay(normalized_sounds[0], position=3159)
    overlayed = overlayed.overlay(normalized_sounds[0], position=6941)
    overlayed = overlayed.overlay(normalized_sounds[0], position=10099)
    overlayed = overlayed.overlay(normalized_sounds[0], position=10754)
    overlayed = overlayed.overlay(normalized_sounds[0], position=14612)
    overlayed = overlayed.overlay(normalized_sounds[0], position=15352)

    normalized_overlayed = overlayed.normalize(headroom=1.0)

    export_path = f'{export_base_path}'f'{_OUTPUT_SOUND_EXTENSION}'

    normalized_overlayed.export(export_path)

    return export_path


def _find_by_segments_duration_meanings(
    candidates: dict[int, list[list[int]]]
) -> Optional[int]:
    some_detected_list = {
        threshould: non_silences
        for threshould, non_silences in candidates.items()
        if len(non_silences) > 0
    }

    if len(some_detected_list) == 0:
        return None

    # 1000ms との差分の平均が小さい順にソートし、それを候補とする

    durations = {
        threshould: [
            abs((non_silence[1] - non_silence[0]) - 1000)
            for non_silence in non_silences
        ]
        for threshould, non_silences in some_detected_list.items()
    }

    averages_of_durations = {
        threshould: statistics.mean(non_silences_duration)
        for threshould, non_silences_duration
        in durations.items()
    }

    sorted_averages_of_durations = sorted(
        averages_of_durations.items(),
        key=lambda x: x[1])

    return sorted_averages_of_durations[0][0]


def _find_by_detection_count(
    candidates: dict[int, list[list[int]]]
) -> Optional[int]:
    some_detected_list = {
        threshould: non_silences
        for threshould, non_silences in candidates.items()
        if len(non_silences) > 0
    }

    if len(some_detected_list) == 0:
        return None

    segment_counts = {
        threshould: len(non_silences)
        for threshould, non_silences in some_detected_list.items()
    }

    sorted_segment_counts = sorted(
        segment_counts.items(),
        key=lambda x: x[1],
        reverse=True,
    )

    return sorted_segment_counts[0][0]
