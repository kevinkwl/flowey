from flask_restplus import Namespace, Resource, reqparse
from flowey.models import Transaction
from flowey.ext import db, jwt
from flowey.utils import Category
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
    parser.add_argument('object_user_id', type=int, help='lend/borrow/return', default=None)
    parser.add_argument('split_with', type=int, help='split bill',
                        action='append', default=None)

    @jwt_required
    def get(self):
        user_id = get_jwt_identity()
        data = [d.as_dict()
                for d in Transaction.query.filter_by(user_id=user_id)
                .order_by(Transaction.date.desc(), Transaction.last_modified.desc()).all()]
        return data, 200

    @jwt_required
    def post(self):
        user_id = get_jwt_identity()
        args = self.parser.parse_args()

        args['date'] = datetime.date(*map(int, args['date'].split('-')))
        # without microsecond
        time_now = datetime.datetime.now().replace(microsecond=0)
        amount, currency, category, tdate = args['amount'], args['currency'],\
                args['category'], args['date']

        # Flow -> Borrow, Lend, or Return money, multiple transactions
        if Category.is_flow(category):
            if args['object_user_id'] is None:
                return {"message": "object user id not found."}, 400
            object_user_id = args['object_user_id']

            trans = Transaction.get_flow_trans(amount, currency, category,
                                               tdate, time_now, user_id,
                                               object_user_id)
            for t in trans:
                db.session.add(t)
                db.session.commit()

            return {"message": "Transaction creation succeeded"}, 200
        try:
            split_with = args['split_with']
            total_amount = args['amount']
            remaining = total_amount
            if split_with is not None and len(split_with) > 0:
                n_split = len(split_with) + 1

                # TODO: implement custom share in the future
                share = total_amount // n_split
                for splitter_id in split_with:
                    myshare = share

                    # B transaction
                    mytrans = Transaction(myshare, args['currency'],
                                          args['category'],
                                          args['date'], time_now, splitter_id)
                    db.session.add(mytrans)
                    db.session.commit()

                    # B borrow from user
                    db.session.add(mytrans.get_borrow_trans(splitter_id,
                    user_id))
                    db.session.commit()

                    # user lend to B
                    db.session.add(mytrans.get_lend_trans(user_id, splitter_id))
                    db.session.commit()

                    remaining -= myshare

            # remaining
            new_transaction = Transaction(remaining, args['currency'],
                                          args['category'],
                                          args['date'], time_now, user_id)
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

    @jwt_required
    def get(self, transaction_id):
        data = Transaction.query.filter_by(
            transaction_id=transaction_id).one_or_none()
        if data:
            data = data.as_dict()
            return data, 200
        else:
            return {"message": "Transaction not found"}, 404

    @jwt_required
    def delete(self, transaction_id):
        data = Transaction.query.filter_by(
            transaction_id=transaction_id).one_or_none()
        if data:
            db.session.delete(data)
            db.session.commit()
            return {"message": "Transaction deletion succeeded"}, 200
        else:
            return {"message": "Transaction not found"}, 404

    @jwt_required
    def put(self, transaction_id):
        data = Transaction.query.filter_by(
            transaction_id=transaction_id).one_or_none()
        if data:
            args = self.parser.parse_args()
            if args['date'] is not None:
                args['date'] = datetime.date(
                    *map(int, args['date'].split('-')))
            args['last_modified'] = datetime.datetime.now().replace(microsecond=0)

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
