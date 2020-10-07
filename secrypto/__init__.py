"""
Secrypto is encrypted end-to-end chat service designed to be free
for all with APIs for developers to includea chat system in their
applications.
"""

from .globals import app
from .chat import ChatQueue, generate_uid, new_chatroom, chat

__version__ = '0.0.1'


@app.route('/')
def index() -> str:
    return 'Hi'


if __name__ == "__main__":
    app.run()
