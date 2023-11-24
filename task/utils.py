# coding: utf-8
# Test

import os
from datetime import datetime


def generate_store_file_name(file_name: str) -> tuple[str, str]:
    splitted_file_name = os.path.splitext(file_name)

    current = datetime.now()
    store_file_name_base = current.strftime('%Y%m%d%H%M%S')
    store_file_extension = splitted_file_name[1]

    return (store_file_name_base, store_file_extension)
