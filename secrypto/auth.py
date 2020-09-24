# handle auth related tasks
import re
from flask.globals import request
from flask_bcrypt import Bcrypt
import sqlalchemy

from .globals import db, app

EMAIL_REGEX = re.compile("""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""")


class User(db.Model):
    id: int = db.Column(db.Integer, primary_key=True)
    email: str = db.Column(db.String, unique=True, nullable=False)
    profile: str = db.Column(db.String(30), nullable=False, default='default.png')
    password: str = db.Column(db.String(60), nullable=False)

    def __repr__(self) -> str:
        return f'{self.id}\t{self.email}\t{self.profile}'


@app.route('/login')
def login():
    email: str = request.args.get('u')
    password: str = request.args.get('p')

    if email is not None and password is not None:
        reponse: str = User.query.filter_by(email=email).first()
        if reponse is not None:
            return f'Login sucessful {reponse.email}'
    return 'Login unsuccessful, check your email and password'


@app.route('/register')
def register():
    email: str = request.args.get('u')
    password: str = request.args.get('p')

    if password is not None and len(password) < 8:
        return 'Password should be atleast 8 characters long'
    if email is not None and not EMAIL_REGEX.match(email):
        return 'Enter valid email address'

    try:
        db.session.add(User(email=email, password=password))
        db.session.commit()
    except sqlalchemy.exc.IntegrityError as error:
        # (sqlite3.IntegrityError) UNIQUE constraint failed: user.email
        if str(error).find('UNIQUE constraint failed') > -1:
            return 'Already registered'
        elif str(error).find('NOT NULL constraint failed: user.password') > -1:
            return 'Password not specified'
        elif str(error).find('NOT NULL constraint failed: user.email') > -1:
            return 'Email not specified'
        return 'SQL Error'
    return 'Success'
