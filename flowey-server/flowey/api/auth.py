from flask_restplus import Namespace, Resource
from flask_restplus import reqparse
from flowey.models import User
from flowey.ext import db

api = Namespace('auth', description='authentication APIs')

@api.route('/')
class Register(Resource):
    @api.doc('test api hello')

    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('username', type=str, help='name to create user')
        parser.add_argument('password', type=str, help='password to create user')
        parser.add_argument('email', type=str, help='email to create user')
        args = parser.parse_args()

        print(args)

        new_user = User(args['username'], args['password'], args['email'])
        db.session.add(new_user)
        db.session.commit()  # This is needed to write the changes to database
        print(User.query.all()) # list type

        return "Post"


    def get(self):
        all_users = User.query.all()
        return all_users


