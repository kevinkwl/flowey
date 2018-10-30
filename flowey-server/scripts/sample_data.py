from flowey.ext import db
from flowey.models import User, Transaction
from faker import Faker
import random


class SampleData():
    def __init__(self):
        self.nusers = 5
        self.ntransactions = 5
        self.fake = Faker()
        self.uids = []
        self.tids = []

    def add_users(self):
        for _ in range(self.nusers):
            new_user = User(self.fake.user_name(),
                            self.fake.password(),
                            self.fake.email())
            db.session.add(new_user)
            db.session.commit()
            self.uids.append(new_user.id)

    def del_users(self):
        for uid in self.uids:
            User.query.filter_by(id=uid).delete()
            db.session.commit()

    def add_transactions(self):
        for _ in range(self.nusers*self.ntransactions):
            new_transaction = Transaction(self.fake.pyint(),
                                          self.fake.currency_code(),
                                          random.randint(1, 6),
                                          self.fake.date_between(
                                              start_date='-90d', end_date='today'),
                                          self.fake.past_datetime(
                                              start_date='-30d'),
                                          random.choice(self.uids))
            db.session.add(new_transaction)
            db.session.commit()
            self.tids.append(new_transaction.transaction_id)

    def del_transactions(self):
        for tid in self.tids:
            Transaction.query.filter_by(transaction_id=tid).delete()
            db.session.commit()


if __name__ == '__main__':
    sd = SampleData()
    sd.add_users()
    sd.add_transactions()
    sd.del_transactions()
    sd.del_users()
