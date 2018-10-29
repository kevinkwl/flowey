from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()

from flask_jwt_extended import JWTManager
jwt = JWTManager()

from .models import TokenBlackList
from sqlalchemy.orm.exc import NoResultFound


@jwt.token_in_blacklist_loader
def check_if_token_revoked(decoded_token):
    jti = decoded_token['jti']
    try:
        token = TokenBlackList.query.filter_by(jti=jti).one()
        return token.revoked
    except NoResultFound:
        return False
