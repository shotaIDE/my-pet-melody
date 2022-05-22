# coding: utf-8

import os
import statistics
from datetime import datetime

from google.cloud import storage
from pydub import AudioSegment, silence

_OUTPUT_SOUND_EXTENSION = '.mp3'


def generate_store_file_name(file_name: str) -> tuple[str, str]:
    splitted_file_name = os.path.splitext(file_name)

    current = datetime.now()
    store_file_name_base = current.strftime('%Y%m%d%H%M%S')
    store_file_extension = splitted_file_name[1]

    return (store_file_name_base, store_file_extension)


def detect_non_silence(store_path: str) -> dict:
    sound = AudioSegment.from_file(store_path)

    duration_seconds = sound.duration_seconds
    duration_milliseconds = int(round(duration_seconds, 3) * 1000)

    normalized_sound = sound.normalize(headroom=1.0)

    non_silences_list_raw = [
        {
            'segments': silence.detect_nonsilent(
                normalized_sound, silence_thresh=threshould),
            'threshould': threshould,
        }
        for threshould in range(-30, -10)
    ]

    non_silences_list = [
        non_silences
        for non_silences in non_silences_list_raw
        if len(non_silences['segments']) > 0
    ]

    # 1000ms との差分の平均が小さい順にソートし、それを候補とする

    non_silences_duratioins = [
        {
            'segment_duration_list': [
                non_silence[1] - non_silence[0]
                for non_silence in non_silences['segments']
            ],
            'threshould': non_silences['threshould'],
        }
        for non_silences in non_silences_list
    ]

    average_list = [
        {
            'segment_duration_average':
                statistics.mean(
                    non_silences_duration['segment_duration_list']),
            'threshould': non_silences_duration['threshould'],
        }
        for non_silences_duration in non_silences_duratioins
    ]

    sorted_average_list = sorted(
        average_list,
        key=lambda x: x['segment_duration_average'])

    target_threshould = sorted_average_list[0]['threshould']

    target_index = target_threshould + 30

    return {
        'segments': non_silences_list_raw[target_index]['segments'],
        'durationMilliseconds': duration_milliseconds,
    }


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
    overlayed = overlayed.overlay(normalized_sounds[1], position=6941)
    overlayed = overlayed.overlay(normalized_sounds[0], position=10099)
    overlayed = overlayed.overlay(normalized_sounds[1], position=10754)
    overlayed = overlayed.overlay(normalized_sounds[0], position=14612)
    overlayed = overlayed.overlay(normalized_sounds[1], position=15352)

    normalized_overlayed = overlayed.normalize(headroom=1.0)

    export_path = f'{export_base_path}'f'{_OUTPUT_SOUND_EXTENSION}'

    normalized_overlayed.export(export_path)

    return export_path
