# coding: utf-8

import glob
import itertools
import json
import os
import subprocess


class GetFilesList:
    definition = {
        "name": 'GetFilesList',
        "description": "Get files list",
        "parameters": {
            "type": "object",
            "properties": {},
        },
    }

    def __init__(self) -> None:
        pass

    def execute_and_generate_message(self, args) -> str:
        files_for_extensions = [
            glob.glob(f'../**/*.{extension}', recursive=True)
            for extension in ['dart', 'yaml']
        ]
        files = list(itertools.chain.from_iterable(files_for_extensions))
        return json.dumps(files)


class ReadFile:
    definition = {
        "name": 'ReadFile',
        "description": "Read file",
        "parameters": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "File path to read.",
                },
            },
            "required": ["path"],
        },
    }

    def __init__(self) -> None:
        pass

    def execute_and_generate_message(self, args) -> str:
        path = args['path']

        if os.path.exists(path) is True:
            with open(path, encoding='utf-8') as f:
                contents = f.read()

            result_dict = {
                'path': path,
                'contents': contents,
            }
        else:
            result_dict = {
                'path': path,
                'error': 'File not found.',
            }

        return json.dumps(result_dict)


class MakeNewFile:
    definition = {
        "name": 'MakeNewFile',
        "description": "Make new file",
        "parameters": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "File path to make.",
                },
                "contents": {
                    "type": "string",
                    "description": "File contents to write.",
                },
            },
            "required": ["path", "contents"],
        },
    }

    def __init__(self) -> None:
        pass

    def execute_and_generate_message(self, args) -> str:
        path = args['path']
        contents = args['contents']

        directory = os.path.dirname(path)
        if directory and not os.path.exists(directory):
            os.makedirs(directory)

        with open(path, 'w', encoding='utf-8') as f:
            f.write(contents)

        return 'Succeeded to make new file.'


class ModifyFile:
    definition = {
        "name": 'ModifyFile',
        "description": "Modify file",
        "parameters": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "File path to modify.",
                },
                "contents": {
                    "type": "string",
                    "description": "File contents to write.",
                },
            },
            "required": ["path", "contents"],
        },
    }

    def __init__(self) -> None:
        pass

    def execute_and_generate_message(self, args) -> str:
        path = args['path']
        contents = args['contents']

        if os.path.exists(path) is True:
            with open(path, 'w', encoding='utf-8') as f:
                f.write(contents)

            return 'Succeeded to modify the file.'
        else:
            return 'Failed to find the file.'


class AnalyzeFlutter:
    definition = {
        "name": 'AnalyzeFlutter',
        "description": "Analyze flutter",
        "parameters": {
            "type": "object",
            "properties": {},
            "required": ["path"],
        },
    }

    def __init__(self) -> None:
        pass

    def execute_and_generate_message(self, args) -> str:
        result = subprocess.run(
            ['flutter', 'analyze'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            cwd='../',
            text=True,
        )
        return f'{result.stdout}\n{result.stderr}'


class RecordLGTM:
    definition = {
        "name": 'RecordLGTM',
        "description": "Record LGTM",
        "parameters": {
            "type": "object",
            "properties": {},
        },
    }

    def __init__(self) -> None:
        self.lgtm = False

    def execute_and_generate_message(self, args) -> str:
        self.lgtm = True

        return 'Succeeded to record LGTM.'
