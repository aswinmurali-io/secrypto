# handle auth related tasks

import re
import sqlalchemy
from flask.globals import request

from .globals import db, app, bcrypt

# 00000000 -> $2b$12$QF1xrsxcww5MAsSgASc.p.wIkPhW5qEXk33Hok9jDTYq3dd0iklAu

# https://stackoverflow.com/questions/201323/how-to-validate-an-email-address-using-a-regular-expression
EMAIL_REGEX = re.compile(r"""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""")


class User(db.Model):
    """User data structure to represent all the users in the database.

    Args:
        id (int): The ID for each user (this is auto filled).
        email (str): The EMAIL for the user.
        profile (str): The PROFILE image hash for the user (hash).
        password (str): The PASSWORD for the user (hash).

    Returns:
        str: User info.
    """
    id: int = db.Column(db.Integer, primary_key=True)
    email: str = db.Column(db.String, unique=True, nullable=False)
    profile: str = db.Column(db.String(30), nullable=False, default='default.png')
    password: str = db.Column(db.String(60), nullable=False)

    def __repr__(self) -> str:
        return f'{self.id}\t{self.email}\t{self.profile}'


@app.route('/login')
def login():
    """login() function does the login. Is triggered with the /register route.
    The parameters include 'u' used for email and 'p' is used for password (hashed both email and password).

    Example :-
        /login?u=(hash)&p=(hash)

    Returns:
        str: The login status
    """
    email = request.args.get('u')
    password = request.args.get('p')

    if email is not None and password is not None:
        try:
            reponse: str = User.query.filter_by(email=email).first()
            if reponse is not None:
                if bcrypt.check_password_hash(password, reponse.password):
                    return f'Login successful {reponse.email}'
                else:
                    return 'Password wrong'
        except sqlalchemy.exc.OperationalError:
            pass
    return 'Login unsuccessful, check your email and password'


@app.route('/register')
def register():
    """register() function does the registeration user part. Is triggered with the /register route.
    The parameters include 'u' used for email and 'p' is used for password (hashed both email and password).

    Example :-
        /register?u=(hash)&p=(hash)

    Returns:
        str: The registeration status
    """
    email = request.args.get('u')
    password = request.args.get('p')

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
