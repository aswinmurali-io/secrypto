import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config.update({
    'SECRET_KEY': 'test',  # os.environ['SECRET_KEY'],
    'SQLALCHEMY_TRACK_MODIFICATIONS': False,
    'SQLALCHEMY_DATABASE_URI': 'sqlite:///site.db',
})

db = SQLAlchemy(app)
db.create_all()
