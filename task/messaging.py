# coding: utf-8

from firebase_admin import messaging


def send_completed_to_generate_piece(
        display_name: str,
        template_title: str,
        registration_tokens: list[str]
):
    message = messaging.MulticastMessage(
        tokens=registration_tokens,
        notification=messaging.Notification(
            title=f'{display_name} が完成しました！',
            body=f'{template_title} を使った作品が完成しました',
        ),
        android=messaging.AndroidConfig(
            notification=messaging.AndroidNotification(
                channel_id="completed_to_generate_piece",
            ),
        ),
    )

    response = messaging.send_multicast(message)

    print(
        f'{response.success_count} / {registration_tokens.length} '
        'messages were sent successfully.'
    )

    if response.failure_count == 0:
        return

    responses = response.responses
    for index, response in enumerate(responses):
        if response.success:
            continue

        registration_token = registration_tokens[index]
        print(
            f'Failed to send with "{registration_token}": '
            f'{response.exception}'
        )
