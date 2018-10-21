
from flask_restplus import Api
api = Api()

from .auth import api as auth_api
api.add_namespace(auth_api)
