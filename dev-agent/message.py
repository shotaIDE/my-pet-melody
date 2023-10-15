# coding: utf-8

from enum import Enum
from typing import Any, Dict, List

import tiktoken


class Role(Enum):
    SYSTEM = 'system'
    USER = 'user'
    ASSISTANT = 'assistant'
    FUNCTION = 'function'


class MetaData:
    def __init__(self, index: int, token: int, role: Role) -> None:
        self.index = index
        self.token = token
        self.role = role


class LlmMessageContainer:
    def __init__(self):
        self.messages = []
        self.meta_data_list = []
        self.token_encoder = tiktoken.get_encoding("cl100k_base")

    def add_system_message(self, content: str) -> None:
        self.meta_data_list.append(
            MetaData(
                index=len(self.meta_data_list),
                token=len(self.token_encoder.encode(content)),
                role=Role.SYSTEM
            )
        )
        self.messages.append({
            "role": Role.SYSTEM.value,
            "content": content
        })

    def add_user_message(self, content: str) -> None:
        self.meta_data_list.append(
            MetaData(
                index=len(self.meta_data_list),
                token=len(self.token_encoder.encode(content)),
                role=Role.USER
            )
        )
        self.messages.append({
            "role": Role.USER.value,
            "content": content
        })

    def add_raw_message(self, message: Dict[str, Any]) -> None:
        content = message["content"]
        token = \
            len(self.token_encoder.encode(content)) if content is not None \
            else 0
        self.meta_data_list.append(
            MetaData(
                index=len(self.meta_data_list),
                token=token,
                role=Role(message["role"])
            )
        )
        self.messages.append(message)

    def total_token(self) -> int:
        return sum(meta.token for meta in self.meta_data_list)

    def to_capped_messages(self, token_limit: int = 8192) -> List[Dict[str, Any]]:
        if self.total_token() > token_limit:
            system_meta_data_list = [
                meta
                for meta in self.meta_data_list
                if meta.role == Role.SYSTEM
            ]
            not_system_meta_data_list = [
                meta
                for meta in self.meta_data_list
                if meta.role != Role.SYSTEM]
            current_token = sum(meta.token for meta in system_meta_data_list)
            filtered_indexes = [meta.index for meta in system_meta_data_list]

            for meta in reversed(not_system_meta_data_list):
                if current_token + meta.token > token_limit:
                    break
                current_token += meta.token
                filtered_indexes.append(meta.index)

            system_and_filtered_message = [
                message
                for i, message in enumerate(self.messages)
                if i in filtered_indexes
            ]
            return system_and_filtered_message
        else:
            return self.messages
