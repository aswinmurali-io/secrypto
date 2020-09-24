# /usr/local/bin/python
from .globals import app
from .auth import *

__version__ = '0.0.1'


@app.route('/')
def index():
    return 'backend only server'


@app.errorhandler(404)
def page_not_found(_):
    return '404'
