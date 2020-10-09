"""

id: {
    chat_id: ...,
    user_id: ...,
    message: ...,
}

"""
import flask
import string
import secrets
import json
import os

from .globals import app, db
from flask_cors import cross_origin

# BASE_URL = "https://secrypto.herokuapp.com"
BASE_URL = 'http://127.0.0.1:5000'  # TODO: CHANGE THIS!


def generate_uid() -> str:
    """generate_uid() function is used to generate a UID. Used for
    user creation and chat room creation.

    Returns:
        str: The UID token
    """
    return ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(64))


@app.route('/new')
def new_chatroom() -> any:
    chatid = 'chat'  # generate_uid() TODO: CHANGE THIS!
    userid = generate_uid()
    if not os.path.exists(chatid):
        os.makedirs(chatid)
    if not os.path.exists(f'{chatid}/users'):
        open(f'{chatid}/users', 'w').write(userid)
    else:
        open(f'{chatid}/users', 'a').write(f'\n{userid}')
    if not os.path.exists(f'{chatid}/{userid}.chat_queue'):
        open(f'{chatid}/{userid}.chat_queue', 'w').write('')
    return flask.jsonify({
        "Chat ID": chatid,
        "User ID": userid,
        "Link": f'{BASE_URL}/{chatid}',
    })


@app.route('/chat', methods=['POST', 'GET'])
@cross_origin()
def chat() -> str:
    if flask.request.method == 'POST':
        data = dict(flask.request.form)
        if 'Sender User ID' in data:
            user_list = open(f'{data["Chat ID"]}/users').read().split('\n')
            yes = False
            for user in user_list:
                if user == data['Sender User ID']:
                    yes = True
            if not yes:
                if not os.path.exists(f'{data["Chat ID"]}/{data["Sender User ID"]}.chat_queue'):
                    open(f'{data["Chat ID"]}/users', 'a').write(f"\n{data['Sender User ID']}")
                    open(f'{data["Chat ID"]}/{data["Sender User ID"]}.chat_queue', 'w').write('')
                user_list = open(f'{data["Chat ID"]}/users').read().split('\n')
            for user in user_list:
                if user != data['Sender User ID']:
                    if not os.path.exists(f'{data["Chat ID"]}/{user}.chat_queue'):
                        open(f'{data["Chat ID"]}/{user}.chat_queue', 'w').write('')
                    else:
                        open(f'{data["Chat ID"]}/{user}.chat_queue', 'a').write(f'\n{json.dumps(data)}')
        return data
    else:
        chatid = flask.request.args.get('chatid')
        userid = flask.request.args.get('userid')
        if not os.path.exists(chatid):
            os.makedirs(chatid)
        if not os.path.exists(f'{chatid}/{userid}.chat_queue'):
            open(f'{chatid}/{userid}.chat_queue').write('')
        chat_content = open(f'{chatid}/{userid}.chat_queue').read()
        open(f'{chatid}/{userid}.chat_queue', 'w').write('')
    return chat_content
