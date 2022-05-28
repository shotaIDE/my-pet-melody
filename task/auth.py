# coding: utf-8


from firebase_admin import auth


def verify_authorization_header(value: str) -> str:
    id_token = value.replace('Bearer ', '')

    decoded_token = auth.verify_id_token(id_token)

    return decoded_token['uid']
