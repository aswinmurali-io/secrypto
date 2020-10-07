import secrets
import string
import flask

from .globals import app, db

from flask_cors import cross_origin



class ChatQueue(db.Model):
    """ChatQueue class contains the table for storing all the chats in that
    chat room inside a SQL table which can be accessed by both the users to get
    pending messages.

    Args:
        db (Model): app's SQLAlchemy model instance.

    Returns:
        str: The table details
    """
    id: str = db.Column(db.Integer, primary_key=True)
    user_id: str = db.Column(db.String(10), nullable=False)
    user_msg: str = db.Column(db.String, nullable=False)

    def __repr__(self) -> str:
        return f'ChatQueue(user_id={self.user_id}, user_msg={self.user_msg}'


def generate_uid() -> str:
    """generate_uid() function is used to generate a UID. Used for
    user creation and chat room creation.

    Returns:
        str: The UID token
    """
    return ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(64))


@app.route('/new')
def new_chatroom() -> str:
    chat_id: str = generate_uid()
    exec(f"""
@app.route('/{chat_id}')
def chat{chat_id}():
    return '{chat_id}'
""")
    return chat_id


@app.route('/chat', methods=["POST"])
@cross_origin()
def chat() -> str:
    if 'username' not in flask.session:
        flask.session['username'] = generate_uid()
    query: dict = dict(flask.request.form)['query']
    return flask.jsonify({"response": f'{flask.session["username"]} {query}'})
