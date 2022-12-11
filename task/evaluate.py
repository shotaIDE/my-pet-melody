# coding: utf-8

from detection import detect_non_silence


def evaluate_detection_methods():
    expected_results = [
        {
            'fileName': '小さい鳴き声-01.mp4',
            'segmentsMilliseconds': [
                [5241, 5669],
                [10137, 10526],
                [14034, 14109],
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
    ]

    accuracies = [
        _calculate_accuracy(
            file_path=f'samples/{expected_result["fileName"]}',
            expected_segments=expected_result['segmentsMilliseconds']
        )
        for expected_result in expected_results
    ]

    accuracy = sum(accuracies) / len(accuracies)

    print(f'Accuracy: {accuracy}')
    print(f'Each accuracy: {accuracies}')


def _calculate_accuracy(
        file_path: str, expected_segments: list[list[int]]) -> float:
    actual_result = detect_non_silence(store_path=file_path)

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
        if (expected_segment[0] < actual_segment[0]
                or expected_segment[1] > actual_segment[1]):
            continue

        actual_segment_starts_in = actual_segment[0]
        expeced_segment_starts_in = expected_segment[0]

        return max(
            0,
            # Judge that no detection has been made
            # if the time to meow is larger than 300 ms.
            1 - (expeced_segment_starts_in - actual_segment_starts_in) / 300
        )

    return 0


if __name__ == '__main__':
    evaluate_detection_methods()
