# coding: utf-8

from typing import Any
from xmlrpc.client import DateTime

from firebase_admin import firestore


def template_overlays(id: str) -> list[dict[str, Any]]:
    db = firestore.client()

    template_document_ref = db.collection('systemMedia').document(id)
    template_document = template_document_ref.get()
    template_data = template_document.to_dict()
    return template_data['overlays']


def set_generated_piece(
        uid: str, id: str, name: str, file_name: str, generated_at: DateTime):
    store_data = {
        'name': f'Generated Piece: {name}',
        'movieFileName': file_name,
        'generatedAt': generated_at,
    }

    db = firestore.client()

    generated_pieces_collection = db.collection('userMedia').document(
        uid).collection('generatedPieces')

    if id is not None:
        generated_pieces_collection.document(id).update(store_data)
    else:
        store_data['submittedAt'] = generated_at

        generated_pieces_collection.add(store_data)


def set_template(name: str, overlays: list[dict[str, Any]]) -> str:
    store_data = {
        'name': name,
        'overlays': overlays,
    }

    db = firestore.client()

    system_media_ref = db.collection('systemMedia')

    generated_template_doc = system_media_ref.add(store_data)

    return generated_template_doc
