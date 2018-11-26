import unittest
from flowey.app import create_app
from flowey.ext import db
from flowey.models import User
from tests.utils import login
import json


class FriendsTestCase(unittest.TestCase):
    def setUp(self):
        self.app = create_app('testing')
        self.app_context = self.app.app_context()
        self.app_context.push()
        db.create_all()
        self.client = self.app.test_client(use_cookies=True)

    def tearDown(self):
        db.session.remove()
        db.drop_all()
        self.app_context.pop()

    def test_basic_friends(self):
        user1 = User('f1', 'f1', 'f1')
        user2 = User('f2', 'f2', 'f2')

        db.session.add(user1)
        db.session.commit()
        db.session.add(user2)
        db.session.commit()

        users = User.query.all()

        assert user1 in users and user2 in users

        self.assertEqual(len(user1.get_friends()), 0)
        self.assertEqual(len(user1.get_friends()), 0)

        user1.send_friend_request_to(user2)

        self.assertTrue(user1.has_friend_request_to(user2))
        self.assertTrue(user2.has_friend_request_from(user1))

        self.assertTrue(User.exist_friend_request_between(user1, user2))

        user2.agree_friend_request_from(user1)

        self.assertFalse(user1.has_friend_request_to(user2))
        self.assertEqual(len(user1.get_friends()), 1)
        self.assertEqual(len(user2.get_friends()), 1)

        self.assertEqual(user1.get_friends()[0]['username'], user2.username)
        self.assertEqual(user2.get_friends()[0]['username'], user1.username)

