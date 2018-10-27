from flask_restplus import Namespace, Resource, reqparse
from flowey.models import User
from flowey.ext import db
from flask_jwt_extended import create_access_token
from werkzeug.security import safe_str_cmp

api = Namespace('auth', description='authentication APIs')


@api.route('/register')
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


@api.route('/login')
class Login(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('email',
                        type=str,
                        required=True,
                        help="This field cannot be blank."
                        )
    parser.add_argument('password',
                        type=str,
                        required=True,
                        help="This field cannot be blank."
                        )

    @api.doc('Test login')
    def post(self):
        data = self.parser.parse_args()
        # read from database to find the user and then check the password
        user = User.query.filter_by(email=data['email']).first()

        if user and safe_str_cmp(user.password, data['password']):
            # when authenticated, return a fresh access token and a refresh token
            access_token = create_access_token(identity=user.id, fresh=True)
            # refresh_token = create_refresh_token(user.id)
            return {
                       'jwt_token': access_token,
                       "user": {
                           "id": user.id,
                           "email": user.email,
                           "username": user.username,
                       }
                   }, 200

        return {"message": "Invalid Credentials!"}, 401


