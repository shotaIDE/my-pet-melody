# coding: utf-8

import subprocess


def get_current_diff() -> str:
    subprocess.run(
        ['git', 'add', '.'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd='../',
    )

    result = subprocess.run(
        ['git', 'diff', '--staged'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd='../',
        text=True,
    )

    subprocess.run(
        ['git', 'reset', '.'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd='../',
    )

    return result.stdout
