# /usr/local/bin/python
from flask.globals import request
import flask
from .globals import app, db, auth
from .chat import generate_room

__version__ = '0.0.1'

db.create_all()



@app.route('/')
def index():
    auth = request.authorization
    if auth and auth.username == 'admin' and auth.password == 'admin':
        return 'backend only server'
    return flask.make_response(
        'Could not verify!',
        401,
        {
            'WWW-Authenticate': 'Basic realm="Login Required"',
        },
    )


@app.route('/hi')
@auth.login_required
def p():
    return '3'


@app.errorhandler(404)
def page_not_found(_):
    return '404'

if __name__ == "__main__":
    app.run(debug=True, ssl_context='adhoc')
