import os

from flask import Flask
from flask_bcrypt import Bcrypt
from flask_socketio import SocketIO
from flask_sqlalchemy import SQLAlchemy
from flask_httpauth import HTTPDigestAuth

app = Flask(__name__)
app.debug = True

app.config['SECRET_KEY'] = os.environ['SECRET_KEY']
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///site.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

bcrypt = Bcrypt(app)

db = SQLAlchemy(app)

socketio = SocketIO(app)

auth = HTTPDigestAuth()
