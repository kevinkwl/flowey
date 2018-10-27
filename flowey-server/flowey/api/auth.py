from flask_restplus import Namespace, Resource, reqparse
from flowey.models import User
from flowey.ext import db
from flask_jwt_extended import create_access_token
from werkzeug.security import safe_str_cmp
from flask import jsonify

api = Namespace('auth', description='authentication APIs')


class Register(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('username', type=str, required=True, help='name to create user')
    parser.add_argument('password', type=str, required=True, help='password to create user')
    parser.add_argument('email', type=str, required=True, help='email to create user')

    def post(self):
        args = self.parser.parse_args()
        tmp = User.query.filter_by(email=args['email']).first()

        if tmp: # already exists
            return {"message": "Email Already Exists"}, 403
        else:
            new_user = User(args['username'], args['password'], args['email'])
            db.session.add(new_user)
            db.session.commit()  # This is needed to write the changes to database
            #print(User.query.all()) # list type
            return {"message": "Register Success!"}, 500



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
        user = User.query.filter_by(username=data['email']).first()

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



@api.route('/show')
class Show(Resource):
    def get(self):
        data = User.query.all()
        result = [{'username':x.username, 'password':x.password, 'email':x.email} for x in data]
        #print(result)
        return jsonify(result)