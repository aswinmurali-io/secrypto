import os
import flask
import flask_cors
import flask_sqlalchemy

from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

app: Flask = flask.Flask(__name__)

app.config.update({
    'CORS_HEADERS': 'Content-Type',
    'JSONIFY_PRETTYPRINT_REGULAR': True,
    'SECRET_KEY': os.environ['SECRET_KEY'],
    'SQLALCHEMY_TRACK_MODIFICATIONS': False,
    'SQLALCHEMY_DATABASE_URI': 'sqlite:///site.db'
})

cors: CORS = flask_cors.CORS(app)
db: SQLAlchemy = flask_sqlalchemy.SQLAlchemy(app)
