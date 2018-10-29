from flask_restplus import Namespace, Resource, reqparse
from flowey.models import User, TokenBlackList, Transaction
from flowey.ext import db, jwt
from flask_jwt_extended import (get_jwt_identity, get_raw_jwt, jwt_required)
from werkzeug.security import safe_str_cmp
from flask import jsonify
import datetime

api = Namespace('transactions', description='transactions APIs')


@api.route('/')
class AllTransactions(Resource):

    parser = reqparse.RequestParser()
    parser.add_argument('amount', type=int, required=True,
                        help='transaction amount')
    parser.add_argument('currency', type=str, required=True,
                        help='transaction currency')
    parser.add_argument('category', type=int, required=True,
                        help='transaction category')
    parser.add_argument('date', type=str, required=True,
                        help='transaction date')
    parser.add_argument('last_modified', type=str, required=True,
                        help='transaction last modified date and time')

    @jwt_required
    def get(self):
        user_id = get_jwt_identity()
        data = [d.as_dict()
                for d in Transaction.query.filter_by(user_id=user_id).all()]
        return data, 200

    @jwt_required
    def post(self):

        args = self.parser.parse_args()

        try:
            args['date'] = datetime.date(*map(int, args['date'].split('-')))
            args['last_modified'] = datetime.datetime.strptime(
                args['last_modified'], '%Y-%m-%d %H:%M:%S')

            user_id = get_jwt_identity()
            print(user_id)

            new_transaction = Transaction(args['amount'], args['currency'], args['category'],
                                          args['date'], args['last_modified'], user_id)
            db.session.add(new_transaction)
            db.session.commit()
        except Exception as e:
            return {"message": "Got error {!r}".format(e)}, 403
        else:
            return {"message": "Transaction creation succeeded"}, 200


@api.route('/<int:transaction_id>')
class SingleTransaction(Resource):

    parser = reqparse.RequestParser()
    parser.add_argument('amount', type=int, required=False,
                        help='transaction amount')
    parser.add_argument('currency', type=str, required=False,
                        help='transaction currency')
    parser.add_argument('category', type=int, required=False,
                        help='transaction category')
    parser.add_argument('date', type=str, required=False,
                        help='transaction date')
    parser.add_argument('last_modified', type=str, required=False,
                        help='transaction last modified date and time')

    @jwt_required
    def get(self, transaction_id):
        data = Transaction.query.filter_by(
            transaction_id=transaction_id).one()
        if data:
            data = data.as_dict()
            return data, 200
        else:
            return {"message": "Transaction not found"}, 404

    @jwt_required
    def delete(self, transaction_id):
        data = Transaction.query.filter_by(
            transaction_id=transaction_id).one()
        if data:
            db.session.delete(data)
            db.session.commit()
            return {"message": "Transaction deletion succeeded"}, 200
        else:
            return {"message": "Transaction not found"}, 404

    @jwt_required
    def put(self, transaction_id):
        data = Transaction.query.filter_by(
            transaction_id=transaction_id).one()
        if data:
            args = self.parser.parse_args()
            if args['date'] is not None:
                args['date'] = datetime.date(
                    *map(int, args['date'].split('-')))
            if args['last_modified'] is not None:
                args['last_modified'] = datetime.datetime.strptime(
                    args['last_modified'], '%Y-%m-%d %H:%M:%S')
            try:
                for key, value in args.items():
                    if value is not None:
                        setattr(data, key, value)
                db.session.commit()
            except Exception as e:
                return {"message": "Got error {!r}".format(e)}, 403
            else:
                return {"message": "Transaction update succeeded"}, 200
        else:
            return {"message": "Transaction not found"}, 404


@api.route('/show')
class Show(Resource):
    # @jwt_required
    def get(self):
        data = [d.as_dict() for d in Transaction.query.all()]
        return data, 200
