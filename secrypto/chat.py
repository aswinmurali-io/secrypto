import flask
import string
import secrets
import json
import os

from .globals import app, db
from flask_cors import cross_origin

# BASE_URL = "https://secrypto.herokuapp.com"
BASE_URL = 'http://127.0.0.1:5000'


def generate_uid() -> str:
    """generate_uid() function is used to generate a UID. Used for
    user creation and chat room creation.

    Returns:
        str: The UID token
    """
    return ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(64))


@app.route('/new')
def new_chatroom() -> str:
    #     exec(f"""
    # @app.route('/{chat_id}')
    # def chat{chat_id}():
    #     chat{chat_id} = Table(
    #         'chat{chat_id}',
    #         meta,
    #         Column('id', Integer, primary_key=True),
    #         Column('user_id', String),
    #         Column('user_msg', String),
    #     )
    #     return '{chat_id}'
    # """)
    chatid = generate_uid()
    userid = generate_uid()
    return flask.jsonify({
        "Chat ID": chatid,
        "User ID": userid,
        "Link": f'{BASE_URL}/chat',
    })


@app.route('/chat', methods=['POST', 'GET'])
@cross_origin()
def chat() -> str:
    if flask.request.method == 'POST':
        data = dict(flask.request.form)
        json_file = open(data['Chat ID'], 'w')
        json_file.write(json.dumps(data))
        json_file.close()
        return data
    else:
        chatid = flask.request.args.get('id')
        if os.path.exists(chatid):
            json_file = open(chatid)
            content = json_file.read()
            json_file.close()
            return content
    return '{}'
