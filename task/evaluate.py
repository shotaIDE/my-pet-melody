# coding: utf-8

from typing import Callable

from detection import detect_non_silence, detect_speech_or_music

_expected_results = [
    {
        'fileName': '小さい鳴き声-01.mp4',
        'segmentsMilliseconds': [
            [5241, 5669],
            [10137, 10526],
            [14034, 14109],
        ],
    },
    {
        'fileName': '小さい鳴き声-02.mp4',
        'segmentsMilliseconds': [
            [2055, 2270],
            [28946, 29583],
        ],
    },
    {
        'fileName': '大きい鳴き声-01.mp4',
        'segmentsMilliseconds': [
            [426, 1219],
            [3498, 4127],
            [10765, 11550],
            [12699, 13780],
        ],
    },
    {
        'fileName': '大きい鳴き声-01.mp4',
        'segmentsMilliseconds': [
            [1244, 2321],
            [6540, 7677],
            [25753, 26737],
            [42625, 43686],
            [44915, 45942],
            [47882, 51140],
            [53324, 54387],
        ],
    },
    {
        'fileName': '低い鳴き声-01.mov',
        'segmentsMilliseconds': [
            [292, 941],
        ],
    },
]


def evaluate_detection_methods():
    methods = [
        ('silenceDetector', detect_non_silence),
        ('inaSpeechSegmenter', detect_speech_or_music),
    ]

    accuracies = [
        _evaluate_one_method(
            name=method[0],
            method=method[1],
        )
        for method in methods
    ]

    for accuracy in accuracies:
        print('----------')
        print(f'Method: {accuracy["name"]}')
        print(f'Accuracy: {accuracy["accuracy"]}')
        print(f'Each accuracy: {accuracy["eachAccuracies"]}')


def _evaluate_one_method(name: str, method: Callable[[str], dict]) -> dict:
    accuracies = [
        _calculate_accuracy(
            file_path=f'samples/{expected_result["fileName"]}',
            method=method,
            expected_segments=expected_result['segmentsMilliseconds']
        )
        for expected_result in _expected_results
    ]

    accuracy = sum(accuracies) / len(accuracies)

    return {
        'name': name,
        'accuracy': accuracy,
        'eachAccuracies': accuracies,
    }


def _calculate_accuracy(
    file_path: str,
    method: Callable[[str], dict],
    expected_segments: list[list[int]]
) -> float:
    actual_result = method(file_path)

    actual_segments = actual_result['segments']

    detected_scores = [
        _calculate_detection_score_on_one_segment(
            expected_segment=expected_segment, actual_segments=actual_segments
        )
        for expected_segment in expected_segments
    ]

    return sum(detected_scores) / len(expected_segments)


def _calculate_detection_score_on_one_segment(
        expected_segment: list[int],
        actual_segments: list[list[int]],
) -> float:
    for actual_segment in actual_segments:
        allowed_width_in_start_milliseconds = 300
        allowed_width_in_end_milliseconds = 2000

        if (expected_segment[0]
                < (actual_segment[0] - allowed_width_in_start_milliseconds)
                or expected_segment[1]
                > (actual_segment[1] + allowed_width_in_end_milliseconds)):
            continue

        actual_segment_starts_in = actual_segment[0]
        expeced_segment_starts_in = expected_segment[0]

        return max(
            0,
            # Judge that no detection has been made
            # if the segment start time differs from the expected one
            # by certain milliseconds.
            (
                1
                - abs(expeced_segment_starts_in - actual_segment_starts_in)
                / allowed_width_in_start_milliseconds
            )
        )

    return 0


if __name__ == '__main__':
    evaluate_detection_methods()
