from flowey import db, create_app
from flowey.models import User, Transaction
from faker import Faker
import random
import argparse
import pickle


class SampleData():
    fake = Faker()
    uids = set()
    tids = set()
    app = create_app('default')
    app.app_context().push()

    def __init__(self, nusers=5, ntransactions=5):
        self.nusers = nusers
        self.ntransactions = ntransactions

    def save_ids(self):
        ids = {
            'uids': self.uids,
            'tids': self.tids
        }
        with open('sample_data_ids.pkl', 'wb') as f:
            pickle.dump(ids, f)

    def load_ids(self):
        with open('sample_data_ids.pkl', 'rb') as f:
            ids = pickle.load(f)
        self.uids = ids['uids']
        self.tids = ids['tids']

    def add_users(self):
        for _ in range(self.nusers):
            new_user = User(self.fake.user_name(),
                            self.fake.password(),
                            self.fake.email())
            db.session.add(new_user)
            db.session.commit()
            self.uids.add(new_user.id)

    def del_users(self):
        for uid in self.uids:
            User.query.filter_by(id=uid).delete()
            db.session.commit()
        self.uids.clear()

    def add_transactions(self):
        for _ in range(self.nusers*self.ntransactions):
            new_transaction = Transaction(self.fake.pyint(),
                                          self.fake.currency_code(),
                                          random.randint(1, 6),
                                          self.fake.date_between(
                                              start_date='-90d', end_date='today'),
                                          self.fake.past_datetime(
                                              start_date='-30d'),
                                          random.sample(self.uids, 1)[0])
            db.session.add(new_transaction)
            db.session.commit()
            self.tids.add(new_transaction.transaction_id)

    def del_transactions(self):
        for tid in self.tids:
            Transaction.query.filter_by(transaction_id=tid).delete()
            db.session.commit()
        self.tids.clear()


if __name__ == '__main__':
    """
    run python sample_data.py [--nu <nu>] [--nt <nt>] to create sample data, 
    where <nu> is number of users to generate, <nt> is number of transactions per user to generate

    run python sample_data.py -d to delete sample data
    """

    parser = argparse.ArgumentParser(description='Sample Data Args')
    parser.add_argument('-d', action='store_true',
                        default=False, help='Delete sample data?')
    parser.add_argument('--nu', type=int, default=5, help='Number of users')
    parser.add_argument('--nt', type=int, default=5,
                        help='Number of transactions per user')
    args = parser.parse_args()

    sd = SampleData(args.nu, args.nt)

    if not args.d:
        sd.add_users()
        sd.add_transactions()
        sd.save_ids()
    else:
        sd.load_ids()
        sd.del_transactions()
        sd.del_users()
