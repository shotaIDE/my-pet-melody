# coding: utf-8

import statistics
from typing import Any, Optional

from pydub import AudioSegment

_OUTPUT_SOUND_EXTENSION = '.mp3'


def generate_piece(
    template_path: str,
    sound_paths: list[str],
    overlays: list[dict[str, Any]],
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

    for overlay in overlays:
        position = overlay['positionMilliseconds']
        overlayed = overlayed.overlay(normalized_sounds[0], position=position)

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
