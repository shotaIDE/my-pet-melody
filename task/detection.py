# coding: utf-8

import time

from inaSpeechSegmenter import Segmenter
from pydub import AudioSegment


def detect_non_silence(store_path: str) -> dict:
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
