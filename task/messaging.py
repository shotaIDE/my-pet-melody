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

    print('{0} messages were sent successfully'.format(
        response.success_count))

    if response.failure_count > 0:
        responses = response.responses
        failed_tokens = []
        for idx, resp in enumerate(responses):
            if not resp.success:
                failed_tokens.append(registration_tokens[idx])

        print('List of tokens that caused failures: {0}'.format(
            failed_tokens))
