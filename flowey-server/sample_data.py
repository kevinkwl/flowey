from flowey import db, create_app
from flowey.models import User, Transaction
from faker import Faker
import random


class SampleData():
    fake = Faker()
    uids = set()
    tids = set()
    app = create_app('default')
    app.app_context().push()

    def __init__(self, nusers=5, ntransactions=5):
        self.nusers = nusers
        self.ntransactions = ntransactions

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
    sd = SampleData()
    sd.add_users()
    sd.add_transactions()
    sd.del_transactions()
    sd.del_users()
