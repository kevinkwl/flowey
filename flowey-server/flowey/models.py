from .ext import db
from datetime import date, datetime


def json_serial(obj):
    """JSON serializer for objects not serializable by default json code"""

    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    return obj


class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    username = db.Column(db.String(100), nullable=False)
    password = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)

    def __init__(self, username, password, email):
        self.username = username
        self.password = password
        self.email = email

    def __repr__(self):
        return ', '.join(['{}:{}'.format(c.name, getattr(self, c.name)) for c in self.__table__.columns])

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}


class Transaction(db.Model):
    __tablename__ = 'transactions'
    transaction_id = db.Column(db.Integer, primary_key=True, nullable=False)
    # record in the actual amount * 100
    amount = db.Column(db.Integer, nullable=False)
    currency = db.Column(db.String(10), nullable=False)
    # store in int type, each int will be mapped to a string
    category = db.Column(db.Integer, nullable=False)
    date = db.Column(db.Date, nullable=False)
    last_modified = db.Column(db.DateTime, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))

    def __init__(self, amount, currency, category, date, last_modified, user_id):
        self.amount = amount
        self.currency = currency
        self.category = category
        self.date = date
        self.last_modified = last_modified
        self.user_id = user_id

    def __repr__(self):
        return ', '.join(['{}:{}'.format(c.name, getattr(self, c.name)) for c in self.__table__.columns])

    def as_dict(self):
        return {c.name: json_serial(getattr(self, c.name)) for c in self.__table__.columns}


class TokenBlackList(db.Model):
    __tablename__ = 'tokenblacklist'
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    jti = db.Column(db.String(36), nullable=False)
    revoked = db.Column(db.Boolean, nullable=False)

    def __init__(self, jti):
        self.jti = jti
        self.revoked = True

    def __repr__(self):
        return ', '.join(['{}:{}'.format(c.name, getattr(self, c.name)) for c in self.__table__.columns])

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}
