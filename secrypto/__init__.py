# /usr/local/bin/python
from .globals import app, db
from .auth import login, register
from .chat import generate_room

__version__ = '0.0.1'

db.create_all()

@app.route('/')
def index():
    return 'backend only server'


@app.errorhandler(404)
def page_not_found(_):
    return '404'
