from .ext import db


class User(db.Model):
    pass
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
        #return '<User %r>' % self.username
        return "id:{} username:{} password:{} email:{}".format(self.id, self.username, self.password, self.email)

