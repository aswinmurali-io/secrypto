"""
Secrypto is encrypted end-to-end chat service designed to be free
for all with APIs for developers to includea chat system in their
applications.
"""

from .globals import app, db
from .chat import *

__version__ = '0.0.1'

db.create_all()

@app.route('/')
def index() -> str:
    return 'Hi'


if __name__ == '__main__':
    app.run(host='0.0.0.0')
