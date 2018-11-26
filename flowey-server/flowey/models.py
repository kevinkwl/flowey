from .ext import db
from datetime import date, datetime


def json_serial(obj):
    """JSON serializer for objects not serializable by default json code"""

    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    return obj


friends = db.Table(
    'friends',
    db.Column('uid', db.Integer, db.ForeignKey('users.id')),
    db.Column('fid', db.Integer, db.ForeignKey('users.id'))
)

friend_reqs = db.Table(
    'friend_reqs',
    db.Column('uid', db.Integer, db.ForeignKey('users.id')),
    db.Column('fid', db.Integer, db.ForeignKey('users.id'))
)


class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    username = db.Column(db.String(100), nullable=False)
    password = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)

    friends = db.relationship("User",
                              secondary=friends,
                              primaryjoin=(friends.c.uid == id),
                              secondaryjoin=(friends.c.fid == id),
                              backref=db.backref('friend_to', lazy='dynamic'),
                              lazy='dynamic')

    friend_requested = db.relationship("User",
                                       secondary=friend_reqs,
                                       primaryjoin=(friend_reqs.c.uid == id),
                                       secondaryjoin=(friend_reqs.c.fid == id),
                                       backref=db.backref('friend_received',
                                                          lazy='dynamic'),
                                       lazy='dynamic')

    def __init__(self, username, password, email):
        self.username = username
        self.password = password
        self.email = email

    def __repr__(self):
        return ', '.join(['{}:{}'.format(c.name, getattr(self, c.name)) for c in self.__table__.columns])

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

    def has_friend(self, user):
        return self.friends.filter(friends.c.fid == user.id).count() > 0

    def add_friend(self, user):
        if not self.has_friend(user):
            self.friends.append(user)
            self.friend_to.append(user)
            return self

    def remove_friend(self, user):
        if self.has_friend(user):
            self.friends.remove(user)
            self.friend_to.remove(user)
            return self

    def has_friend_request_to(self, user):
        return self.friend_requested.filter(friend_reqs.c.fid == user.id) \
                .count() > 0

    def has_friend_request_from(self, user):
        return self.friend_received.filter(friend_reqs.c.uid == user.id) \
                .count() > 0

    @staticmethod
    def exist_friend_request_between(user1, user2):
        return user1.has_friend_request_to(user2) or \
                user2.has_friend_request_to(user1)

    def send_friend_request_to(self, user):
        self.friend_requested.append(user)
        db.session.add(self)
        db.session.commit()

    def agree_friend_request_from(self, user):
        if self.has_friend_request_from(user):
            self.friend_received.remove(user)
            self.add_friend(user)
            db.session.add(self)
            db.session.commit()

    def get_friends(self):
        return [user.username for user in self.friends]



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




