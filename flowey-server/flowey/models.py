from .ext import db


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
        # return '<User %r>' % self.username
        return "id:{} username:{} password:{} email:{}".format(self.id, self.username, self.password, self.email)



class Transaction(db.Model):
    __tablename__ = 'transactions'
    transaction_id = db.Column(db.Integer, primary_key=True, nullable=False)
    amount = db.Column(db.Integer, nullable=False) # record in the actual amount * 100
    currency = db.Column(db.String(10), nullable=False)
    category = db.Column(db.Integer, nullable=False) # store in int type, each int will be mapped to a string
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
        return "transaction_id:{} amount:{} currency:{} category:{} date:{} last_modify:{} user_id:{}" \
               "".format(self.transaction_id, self.amount, self.currency, self.category, self.date,
                         self.last_modified, self.user_id)



class TokenBlackList(db.Model):
    pass
    __tablename__ = 'tokenblacklist'
    id = db.Column(db.Integer, primary_key=True, nullable=False)
    jti = db.Column(db.String(36), nullable=False)
    revoked = db.Column(db.Boolean, nullable=False)

    def __init__(self, jti):
        self.jti = jti
        self.revoked = True

    def __repr__(self):
        return "id:{} jti:{} revoked:{}".format(self.id, self.jti, self.revoked)
