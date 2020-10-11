import types
import uuid
import flask

from enum import Enum
from typing import NewType, Any

from .globals import app, db

SECRYPTO_ID: types[SECRYPTO_ID] = NewType('SECRYPTO_ID', str)
ENCRYPTED_MSG: types[ENCRYPTED_MSG] = NewType('ENCRYPTED_MSG', str)
BASE_URL: str = 'http://127.0.0.1:5000'  # TODO: CHANGE THIS! https://secrypto.herokuapp.com


class IDType(Enum):
    """The ID Type for the SECRYTO ID. The ID can be a user
    type or chat type. Used to identify these respectively.

    Examples:
        IDType.USER
        IDType.CHAT

    Args:
        Enum (Enum): Enum datatype class
    """
    USER: str = 'user'
    CHAT: str = 'chat'


def generate_uid(prefix: IDType) -> SECRYPTO_ID:
    """generate_uid() function is used to generate a UID. Used for
    user creation and chat room creation.

    Returns:
        SECRYPTO_ID: The UID token in an secrypto styled ID
    """
    return SECRYPTO_ID(f'{prefix}_{uuid.uuid4().hex}')


class ChatQueue(db.Model):
    """The queue for each secrypto user

    Args:
        db (Model): The database model

    Returns:
        str: The chat queue is used
    """
    __tablename__: SECRYPTO_ID = SECRYPTO_ID('public_user')

    order_id: db.Integer = db.Column(db.Integer, primary_key=True)
    sender_user_id: db.String = db.Column(db.String)
    msg: db.String = db.Column(db.String)
    time: db.DateTime = db.Column(db.DateTime)
    chat_id: db.String = db.Column(db.String)

    def __init__(self, userid: SECRYPTO_ID, sender_user_id: SECRYPTO_ID = None, msg: ENCRYPTED_MSG = None, time: str = None, chat_id: SECRYPTO_ID = None) -> None:
        """Insert a new row in the chat queue. This is where all the pending messages are
        stored, once received the msg will be deleted from the database. The chat queue
        class will have table name where each table name is a user id. So each user will have
        their own chat queue.

        Args:
            userid (SECRYPTO_ID): The USER ID to where the msg is to be stored.
            sender_user_id (SECRYPTO_ID, optional): The sender user id from which the msg came from. Defaults to None.
            msg (ENCRYPTED_MSG, optional): The content of the message (Encryted). Defaults to None.
            time (str, optional): The time when the message was send to the secrypto server. Defaults to None.
            chat_id (SECRYPTO_ID, optional): The ID of the chat where the message was send to. Defaults to None.
        """
        self.__tablename__ = userid

        self.msg = msg
        self.time = time
        self.chat_id = chat_id
        self.sender_user_id = sender_user_id

    def __repr__(self) -> str:
        """The class return data.

        Returns:
            str: This returns the content of the class.
        """
        return f'<ChatQueue[table={self.__tablename__}](order_id={self.order_id}, sender_user_id={self.sender_user_id}, msg={self.msg}, time={self.time}, chat_id={self.chat_id})>'


@app.route('/new')
def new() -> Any:
    admin_user_id: SECRYPTO_ID = generate_uid(IDType.USER)
    chat_id: SECRYPTO_ID = generate_uid(IDType.CHAT)
    new_chat_queue: ChatQueue = ChatQueue(userid=admin_user_id)
    db.session.add(new_chat_queue)
    db.session.commit()
    return flask.jsonify(admin_user_id=admin_user_id, chat_id=chat_id)


@app.route('/<chatid>', methods=['POST', 'GET'])
def chat() -> None:
    return ''
