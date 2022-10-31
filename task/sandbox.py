# coding: utf-8

import ffmpeg


def generate_movie():
    HEIGHT = 1080
    LENGTH_SECONDS = 3
    FRAME_RATE = 30
    FONT_PATH = '../fonts/uzura.ttf'
    MOVIE_CREDITS = 'Created by Meow Music'

    title = 'サウンドタイトル'

    background_image = (
        ffmpeg
        .input('background.jpg')
        .filter('scale', -1, HEIGHT)
        .filter(
            'drawtext',
            fontfile=FONT_PATH,
            text=title,
            x=40,
            y=920,
            fontsize=48,
            fontcolor='white'
        )
        .filter(
            'drawtext',
            fontfile=FONT_PATH,
            text=MOVIE_CREDITS,
            x=40,
            y=1008,
            fontsize=32,
            fontcolor='white'
        )
    )
    sound = ffmpeg.input('sound.mp3')

    stream = ffmpeg.output(
        background_image,
        sound,
        'output.mp4',
        vcodec='libx264',
        acodec='aac',
        pix_fmt='yuv420p',
        t=LENGTH_SECONDS,
        r=FRAME_RATE,
    )

    ffmpeg.run(stream)


if __name__ == '__main__':
    generate_movie()
