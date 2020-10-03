import random
import string

from flask import session
from flask.globals import request
from flask.templating import render_template
from flask_socketio import emit, join_room, leave_room, rooms

from .globals import app, socketio


@app.route('/getroom')
def generate_room():
    return ''.join(random.choices(f'{string.ascii_uppercase}{string.digits}', k=64))


@socketio.on('joined', namespace='/chat')
def joined(_):
    """Sent by clients when they enter a room.
    A status message is broadcast to all people in the room."""
    room = request.args.get('room')
    name = request.args.get('name')
    if name is None:
        name = ''
    join_room(room)
    emit('status', {'msg': name + ' has entered the room.'}, room=room)


@socketio.on('text', namespace='/chat')
def text(message):
    """Sent by a client when the user entered a new message.
    The message is sent to all people in the room."""
    room = request.args.get('room')
    name = request.args.get('name')
    if name is None:
        name = ''
    emit('message', {'msg': name + ':' + message['msg']}, room=room)


@socketio.on('left', namespace='/chat')
def left(_):
    """Sent by clients when they leave a room.
    A status message is broadcast to all people in the room."""
    room = request.args.get('room')
    name = request.args.get('name')
    leave_room(room)
    emit('status', {'msg': name + ' has left the room.'}, room=room)


@app.route('/chat')
def chat():
    name = request.args.get('name')
    room = request.args.get('room')
    return render_template('chat.html', room=room, name=name)
