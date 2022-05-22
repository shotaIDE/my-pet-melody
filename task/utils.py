# coding: utf-8

import os
import statistics
from datetime import datetime

from google.cloud import storage
from pydub import AudioSegment, silence


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
