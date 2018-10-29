
from flask_restplus import Api
api = Api()

from .auth import api as auth_api
from .transactions import api as transactions_api
api.add_namespace(auth_api)
api.add_namespace(transactions_api)
