from flask import Flask
from config import config
from flowey.ext import db, jwt
from flowey.api import api


def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config[config_name])
    config[config_name].init_app(app)
    register_extensions(app)
    return app


def register_extensions(app):
    db.init_app(app)
    api.init_app(app)
    jwt.init_app(app)