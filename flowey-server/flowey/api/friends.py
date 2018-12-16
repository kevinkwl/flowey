from flask_restplus import Namespace, Resource, reqparse
from flowey.models import User, Transaction
from flowey.ext import db, jwt
from flask_jwt_extended import (get_jwt_identity, get_raw_jwt, jwt_required)
from werkzeug.security import safe_str_cmp
from flask import jsonify
import datetime


api = Namespace('friends', description='friends APIs')


@api.route('/')
class ListFriends(Resource):
    @jwt_required
    def get(self):
        user_id = get_jwt_identity()
        user = User.query.filter_by(id=user_id).first_or_404()
        results = []
        for friend in user.friends:
            # also get related transactions
            finfo = {}
            finfo['username'] = friend.username
            finfo['user_id'] = friend.id
            related_trans = Transaction.query.filter_by(
                                                user_id=user_id,
                                                object_user_id=friend.id).all()
            finfo['flows'] = [trans.as_dict() for trans in related_trans]
            results.append(finfo)
        results = sorted(results, key=lambda fi: fi['username'])
        return results, 200


@api.route('/<int:friend_id>')
class Friend(Resource):
    @jwt_required
    def delete(self, friend_id):
        user_id = get_jwt_identity()
        user = User.query.filter_by(id=user_id).first_or_404()
        friend = User.query.filter_by(id=friend_id).first_or_404()

        if not user.has_friend(friend):
            return {'message': 'friend not found'}, 404

        db.session.add(user.remove_friend(friend))
        db.session.commit()
        return {'message': 'delete friend succeed.'}, 200


@api.route('/request')
@api.doc(params={'friend_id':
                 'the id of the user that you want to make friend with',
                 'action': 'choices are "new", "agree", "reject".'})
class FriendRequest(Resource):
    @jwt_required
    def get(self):
        user_id = get_jwt_identity()
        user = User.query.filter_by(id=user_id).first_or_404()
        return user.get_friend_requests(), 200

    @jwt_required
    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('email', type=str, required=True,
                            help="email address of the friend")
        user_id = get_jwt_identity()
        args = parser.parse_args()
        user = User.query.filter_by(id=user_id).first_or_404()
        friend = User.query.filter_by(email=args['email']).first_or_404()

        if user.has_friend_request_to(friend):
            return {'message': 'friend request already exist.'}, 200

        user.send_friend_request_to(friend)
        return {'message': 'action succeeded.'}, 200

    @jwt_required
    def put(self):
        parser = reqparse.RequestParser()

        parser.add_argument('friend_id', type=int, required=True,
                            help="id of the friend")
        parser.add_argument('action', type=str, required=True)
        user_id = get_jwt_identity()
        args = parser.parse_args()
        user = User.query.filter_by(id=user_id).first_or_404()
        friend = User.query.filter_by(id=args['friend_id']).first_or_404()
        action = args['action']

        if not user.has_friend_request_from(friend):
            return {'message': 'no friend request found.'}, 404

        if action == 'agree':
            user.agree_friend_request_from(friend)
        elif action == 'reject':
            user.reject_friend_request_from(friend)
        return {'message': 'action succeeded.'}, 200
