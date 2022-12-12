# coding: utf-8

import time
from typing import Callable

from inaSpeechSegmenter import Segmenter
from pydub import AudioSegment, effects
from pydub.silence import detect_nonsilent


def detect_speech_or_music(store_path: str) -> dict:
    start_time = time.perf_counter()

    sound = AudioSegment.from_file(store_path)
    duration_seconds: int = sound.duration_seconds
    duration_milliseconds = int(round(duration_seconds, 3) * 1000)

    segmenter = Segmenter(
        vad_engine='sm', detect_gender=False, batch_size=128, energy_ratio=0.5)

    segmentations = segmenter(store_path)

    print(f'Detected result(raw): {segmentations}')

    non_silences_list: list[list[int]] = [
        [int(segmentation[1] * 1000), int(segmentation[2] * 1000)]
        for segmentation in segmentations
        if (segmentation[0] == 'speech' or
            segmentation[0] == 'music')
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


def detect_non_silence_without_normalize(store_path: str) -> dict:
    sound = AudioSegment.from_file(store_path)

    return _detect_non_silence(
        sound=sound, min_silence_len=100, silence_thresh=-48)


def detect_non_silence(store_path: str) -> dict:
    detector = detect_non_silence_by_threshould(silence_threshould=-30)

    return detector(store_path)


def detect_non_silence_by_threshould(
    silence_threshould: int
) -> Callable[[str], dict]:
    def _detect_non_silence_core(store_path: str) -> dict:
        sound = AudioSegment.from_file(store_path)

        normalized_sound = effects.normalize(sound)

        return _detect_non_silence(
            sound=normalized_sound,
            min_silence_len=300,
            silence_thresh=silence_threshould,
        )

    return _detect_non_silence_core


def _detect_non_silence(
    sound: AudioSegment,
    min_silence_len: int,
    silence_thresh: int,
) -> dict:
    start_time = time.perf_counter()

    duration_seconds: int = sound.duration_seconds
    duration_milliseconds = int(round(duration_seconds, 3) * 1000)

    non_silences_list = detect_nonsilent(
        sound, min_silence_len=min_silence_len, silence_thresh=silence_thresh)

    print(f'Detected result(ms): {non_silences_list}')

    result = {
        'segments': non_silences_list,
        'durationMilliseconds': duration_milliseconds,
    }

    end_time = time.perf_counter()
    elapsed_time = end_time - start_time
    print(f'Running time to detect non silence: {elapsed_time:.3f}s')

    return result
