# coding: utf-8

from chat import chat_with_function_calling_loop
from function import GetFilesList, ReadFile, RecordLGTM
from git import get_current_diff
from message import LlmMessageContainer


class Reviewer:
    _actor_name = 'Reviewer'

    def __init__(self, prompt: str):
        self._leader_comment = prompt
        self._record_lgtm = RecordLGTM()

    def work(self, programmer_comment: str) -> str:
        print('---------------------------------')
        print(f'{self._actor_name}: Start to work')

        with open('reviewer-prompt.md', encoding='utf-8') as f:
            prompt = f.read()

        message_container = LlmMessageContainer()

        message_container.add_system_message(prompt)

        message_container.add_system_message(
            'The request from the engineer leader is as follows.\n\n'
            + self._leader_comment
            + '\n\n'
        )

        if programmer_comment is not None:
            message_container.add_system_message(
                'The request from the programmer is as follows.\n\n'
                + programmer_comment
                + '\n\n'
            )

        current_diff = get_current_diff()
        if current_diff != '':
            message_container.add_system_message(
                'The modifications made by the programmer are as follows.\n\n'
                + current_diff
                + '\n\n'
            )

        comment = chat_with_function_calling_loop(
            messages=message_container,
            functions=[
                GetFilesList(),
                ReadFile(),
                self._record_lgtm,
            ],
            actor_name=self._actor_name,
        )

        print(f'{self._actor_name}: {comment}')
        return comment

    def lgtm(self) -> bool:
        return self._record_lgtm.lgtm
