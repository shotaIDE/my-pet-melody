# coding: utf-8

from flask import Flask
from flask import request

app = Flask(__name__)

@app.route("/", methods=['POST'])
def hello_world():
    user_id = request.json['userId']

    return "<p>Hello, World!</p>"
