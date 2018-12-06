import unittest
from flowey.app import create_app
from flowey.ext import db
from flowey.models import User
from tests.utils import login, auth
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

    def test_make_friend(self):
        h1 = auth(self, "f1@t.cc", "f1")
        h2 = auth(self, "f2@t.cc", "f2")

        # email not found
        response = self.client.post('/friends/request', headers=h1, data={
            "email": "fnotfound@ts.xx"
        })

        self.assertEqual(response.status_code, 404)

        # email not found
        response = self.client.post('/friends/request', headers=h1, data={
            "email": "f2@t.cc"
        })

        self.assertEqual(response.status_code, 200)

        res2 = self.client.get('/friends/request', headers=h2)
        frqs2 = json.loads(res2.get_data(as_text=True))

        self.assertEqual(len(frqs2), 1)

        # make a duplicate request
        self.client.post('/friends/request', headers=h1, data={
            "email": "f2@t.cc"
        })
        dup_res2 = self.client.get('/friends/request', headers=h2)
        dup_frqs2 = json.loads(dup_res2.get_data(as_text=True))

        self.assertEqual(len(dup_frqs2), 1)

        # reject request
        response = self.client.put('/friends/request', headers=h2, data={
            "friend_id": dup_frqs2[0]["user_id"],
            "action": "reject"
        })
        self.assertEqual(response.status_code, 200)

        response = self.client.post('/friends/request', headers=h2, data={
            "email": "f1@t.cc"
        })
        self.assertEqual(response.status_code, 200)

        # now f1 agree f2's request
        res1 = self.client.get('/friends/request', headers=h1)
        frqs1 = json.loads(res1.get_data(as_text=True))

        self.assertEqual(len(frqs1), 1)

        response = self.client.put('/friends/request', headers=h1, data={
            "friend_id": frqs1[0]["user_id"],
            "action": "agree"
        })
        self.assertEqual(response.status_code, 200)

        # now f1 and f2 are friends
        response = self.client.get('/friends', headers=h1)
        friends1 = json.loads(response.get_data(as_text=True))
        self.assertEqual(len(friends1), 1)

        self.assertEqual(friends1[0]["username"], "f2")

        response = self.client.get('/friends', headers=h2)
        friends2 = json.loads(response.get_data(as_text=True))
        self.assertEqual(len(friends2), 1)

        self.assertEqual(friends2[0]["username"], "f1")

        # Remove friend

        # remove 404 not found friend
        response = self.client.delete('/friends/88888', headers=h1)
        self.assertEqual(response.status_code, 404)

        # remove f2 from f1's friends list
        response = self.client.delete('/friends/{}'.format(friends1[0]["user_id"]), headers=h1)
        self.assertEqual(response.status_code, 200)

        # now f1 and f2 are not friends
        response = self.client.get('/friends', headers=h1)
        friends1 = json.loads(response.get_data(as_text=True))
        self.assertEqual(len(friends1), 0)

        response = self.client.get('/friends', headers=h2)
        friends2 = json.loads(response.get_data(as_text=True))
        self.assertEqual(len(friends2), 0)
