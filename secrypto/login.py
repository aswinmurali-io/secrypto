from flask import flash, redirect, render_template, request, url_for
from secrypto.__main__ import app, login_manager
from wtforms import Form, BooleanField, StringField, PasswordField, validators

class RegistrationForm(Form):
    username = StringField('Username', [validators.Length(min=4, max=25)])
    email = StringField('Email Address', [validators.Length(min=6, max=35)])
    password = PasswordField('New Password', [
        validators.DataRequired(),
        validators.EqualTo('confirm', message='Passwords must match')
    ])
    confirm = PasswordField('Repeat Password')
    accept_tos = BooleanField('I accept the TOS', [validators.DataRequired()])

@app.route('/login')
def login():
    return 'Hello, World!'

# @app.route('/register', methods=['GET', 'POST'])
# def register():
#     form = RegistrationForm(request.form)
#     if request.method == 'POST' and form.validate():
#         user = User(form.username.data, form.email.data,
#                     form.password.data)
#         flash('Thanks for registering')
#         return redirect(url_for('login'))
#     return render_template('register.html', form=form)

# @login_manager.unauthorized_handler
# def unauthorized():
#     # do stuff
#     return 'Cannot access'
