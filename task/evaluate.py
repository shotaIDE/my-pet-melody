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

    segments_included_in_actual = [
        True
        for expected_segment in expected_segments
        if _contains_segment(
            target_segment=expected_segment, segments=actual_segments)
    ]

    return len(segments_included_in_actual) / len(expected_segments)


def _contains_segment(
        target_segment: list[int], segments: list[list[int]]) -> bool:
    for segment in segments:
        if target_segment[0] >= segment[0] and target_segment[1] <= segment[1]:
            return True

    return False


if __name__ == '__main__':
    evaluate_detection_methods()
