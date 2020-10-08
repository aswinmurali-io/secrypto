from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)

app.config.update({
    'SECRET_KEY': 'test',  # os.environ['SECRET_KEY'],
    'SQLALCHEMY_TRACK_MODIFICATIONS': False,
    'SQLALCHEMY_DATABASE_URI': 'sqlite:///site.db',
    'CORS_HEADERS': 'Content-Type'
})

db = SQLAlchemy(app)

cors = CORS(app)

db.create_all()
