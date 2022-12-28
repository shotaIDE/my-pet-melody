# coding: utf-8

from detection import detect_non_silence
from evaluate import evaluate_method


def test_default_detection_method():
    result = evaluate_method(
        name='Non-silence Detector, threshould -30dB',
        method=detect_non_silence,
    )

    result_accuracy_percent = int(result['accuracy'] * 100)

    assert result_accuracy_percent == 36, (
        'accuracy is different from expected, '
        'should be consistent with previous values or higher.'
    )
