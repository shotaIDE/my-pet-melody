# coding: utf-8

import os

from programmer import Programmer
from reviewer import Reviewer


def work():
    prompt = os.environ.get('PROMPT')
    if prompt is None or prompt == '':
        issue_title = os.environ.get('ISSUE_TITLE')
        if issue_title is None:
            raise Exception('PROMPT or ISSUE_TITLE must be set')

        issue_description = os.environ.get('ISSUE_DESCRIPTION')
        prompt = (
            f'title: {issue_title}\n'
            f'description: {issue_description}'
        )

    print(f'Engineer leader: {prompt}')

    programmer = Programmer(prompt=prompt)
    reviewer = Reviewer(prompt=prompt)

    reviewer_comment = None
    iteration = 0

    while iteration < 10:
        programmer_comment = programmer.work(reviewer_comment=reviewer_comment)
        reviewer_comment = reviewer.work(programmer_comment=programmer_comment)

        if reviewer.lgtm():
            break

        iteration += 1


if __name__ == "__main__":
    work()
