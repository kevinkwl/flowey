import unittest
from flowey.app import create_app
from flowey.ext import db
from flowey.models import User
import json


class FlaskAuthenticationTestCase(unittest.TestCase):
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

    def test_register(self):
        # register a new account
        response = self.client.post('/auth/register', data={
            "email": "kevin@columbia.edu",
            "username": "real_kevin",
            "password": "123"
        })
        self.assertEqual(response.status_code, 200)

    def test_register_with_email_already_in_db(self):
        # register a new account
        self.test_register()

        # cannot register with an email already in db
        response = self.client.post('/auth/register', data={
            'email': 'kevin@columbia.edu',
            'username': 'kevin233',
            'password': '233',
        })
        self.assertEqual(response.status_code, 403)

    def test_log_in(self):
        # register a new account
        self.test_register()

        # log in with the new account
        response = self.client.post('/auth/login', data={
            'email': 'kevin@columbia.edu',
            'password': '123'
        }, follow_redirects=True)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('real_kevin' in response.get_data(
            as_text=True))
        d = json.loads(response.get_data(as_text=True))
        header = {'authorization': ' Bearer ' + d['jwt_token']}
        return header

    def test_log_in_with_wrong_password(self):
        # register a new account
        self.test_register()

        # log in with the new account with wrong password
        response = self.client.post('/auth/login', data={
            'email': 'kevin@columbia.edu',
            'password': '233'
        }, follow_redirects=True)
        self.assertEqual(response.status_code, 401)
        self.assertTrue('Invalid Credentials!' in response.get_data(
            as_text=True))

    def test_log_out(self):
        # log in with an account
        header = self.test_log_in()

        # log out
        response = self.client.delete(
            '/auth/logout', headers=header, follow_redirects=True)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('Successfully logged out' in response.get_data(
            as_text=True))
