# Dev Agent

This module is a tool that utilizes Chat-GPT to automatically propose code modifications based on task summaries.

## Prerequisites

Install Python and [virtualenv](https://virtualenv.pypa.io/en/latest/).

Create a Python virtual environment with the following command.

```bash
virtualenv env
```

Activate the environment using the following command (for Mac).

```bash
source env/bin/activate
```

Install the dependencies using the following command.

```bash
pip install -r requirements.txt
```

Create the `.env` file with the following command.

```bash
cp .env.example .env
```

Edit the contents of the `.env` file as needed.

| Key                      | Description                                                                                                                           |
| :----------------------- | :------------------------------------------------------------------------------------------------------------------------------------ |
| `OPENAI_ORGANIZATION_ID` | Organization ID for the OpenAI API. It can be checked at [Organization > Settings](https://platform.openai.com/account/org-settings). |
| `OPENAI_API_KEY`         | API Key issued in the OpenAI API. It can be found at [User > API Keys](https://platform.openai.com/account/api-keys).                 |
| `PROMPT`                 | Summary of the content you want to modify. Example: `Change the title of the home_screen to "Thread List"`                            |

## How to Execute

In VSCode's "Run and Debug" screen, execute "Run".

## References

https://zenn.dev/happy_elements/articles/0b2691b3fc53fd
