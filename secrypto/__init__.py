# /usr/local/bin/python

from flask import Flask, redirect, render_template, url_for
from flask_login import LoginManager

app = Flask(__name__)
__version__ = '0.0.1'
#login_manager = LoginManager()
#login_manager.init_app(app)
app.debug = True

@app.route('/')
def hello_world():
    return ''  # redirect(url_for('login'))


@app.errorhandler(404)
def page_not_found(_):
    return render_template('404.html'), 404
