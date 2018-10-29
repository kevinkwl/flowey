from flask_restplus import Namespace, Resource, reqparse
from flowey.models import User, TokenBlackList, Transaction
from flowey.ext import db, jwt
from flask_jwt_extended import (get_jwt_identity, get_raw_jwt, jwt_required)
from werkzeug.security import safe_str_cmp
from flask import jsonify
import datetime

api = Namespace('transactions', description='transactions APIs')


@api.route('/')
class Transactions_all(Resource):

    parser = reqparse.RequestParser()
    parser.add_argument('amount', type=int, required=True,
                        help='transaction amount')
    parser.add_argument('currency', type=str, required=True,
                        help='transaction currency')
    parser.add_argument('category', type=int, required=True,
                        help='transaction category')
    parser.add_argument('date', type=datetime.date, required=True,
                        help='transaction date')
    parser.add_argument('last_modified', type=datetime.datetime, required=True,
                        help='transaction last modified date and time')
    parser.add_argument('user_id', type=int, required=True,
                        help='transaction user id')

    @jwt_required
    def get(self):
        user_id = get_jwt_identity()
        data = Transaction.query.filter_by(user_id=user_id).all()
        return jsonify(data), 200

    @jwt_required
    def post(self):
        args = self.parser.parse_args()
        try:
            new_transaction = Transaction()
            db.session.add(new_transaction)
            db.session.commit()
        except Exception as e:
            return {"message": "Got error {!r}".format(e)}, 403
        else:
            return {"message": "Transaction creation succeeded"}, 200


@api.route('/<transaction_id>')
class Transaction_single(Resource):

    parser = reqparse.RequestParser()
    parser.add_argument('amount', type=int, required=True,
                        help='transaction amount')
    parser.add_argument('currency', type=str, required=True,
                        help='transaction currency')
    parser.add_argument('category', type=int, required=True,
                        help='transaction category')
    parser.add_argument('date', type=datetime.date, required=True,
                        help='transaction date')
    parser.add_argument('last_modified', type=datetime.datetime, required=True,
                        help='transaction last modified date and time')
    parser.add_argument('user_id', type=int, required=True,
                        help='transaction user id')

    def __init__(self, transaction_id):
        self.data = Transaction.query.filter_by(
            transaction_id=transaction_id).one()

    @jwt_required
    def get(self):
        if self.data:
            return jsonify(self.data), 200
        else:
            return {"message": "Transaction not found"}, 404

    @jwt_required
    def delete(self):
        if self.data:
            db.session.delete(self.data)
            db.session.commit()
            return {"message": "Transaction deletion succeeded"}, 200
        else:
            return {"message": "Transaction not found"}, 404

    @jwt_required
    def put(self):
        if self.data:
            args = self.parser.parse_args()
            try:
                for key, value in args.items():
                    if value is not None:
                        setattr(self.data, key, value)
                db.session.commit()
            except Exception as e:
                return {"message": "Got error {!r}".format(e)}, 403
            else:
                return {"message": "Transaction update succeeded"}, 200
        else:
            return {"message": "Transaction not found"}, 404
