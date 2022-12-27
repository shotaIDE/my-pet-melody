# coding: utf-8

from detection import detect_non_silence
from evaluate import evaluate_one_method


def test_detection_methods():
    result = evaluate_one_method(
        name='Non-silence Detector, threshould -30dB',
        method=detect_non_silence,
    )

    result_accuracy_percent = int(result['accuracy'] * 100)

    assert result_accuracy_percent == 35
