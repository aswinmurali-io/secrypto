import flask
import string
import secrets

from .globals import app, db
from flask_cors import cross_origin

BASE_URL = "https://secrypto.herokuapp.com"


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
        "body": {
            "Chat ID": chatid,
            "User ID": userid,
            "Link": f'{BASE_URL}/{chatid}',
        },
    })


@app.route('/chat', methods=["POST"])
@cross_origin()
def chat() -> str:
    if 'username' not in flask.session:
        flask.session['username'] = generate_uid()
    query: dict = dict(flask.request.form)['query']
    return flask.jsonify({"response": f'{flask.session["username"]} {query}'})
