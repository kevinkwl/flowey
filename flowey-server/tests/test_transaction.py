import unittest
from flowey.app import create_app
from flowey.ext import db
from flowey.models import User
from tests.utils import login
import json


class FlaskTransactionTestCase(unittest.TestCase):
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

    def test_add_transaction(self):
        # log in
        header = login(self)

        # add a new transaction
        response = self.client.post('/transactions/', headers=header, data={
            'amount': '-100',
            'currency': 'CNY',
            'category': '1',
            "date": "2018-10-29"
        })
        self.assertEqual(response.status_code, 200)
        self.assertTrue('Transaction creation succeeded' in response.get_data(
            as_text=True))
        return header

    def test_add_transaction_before_login(self):
        # add a new transaction without logging in
        response = self.client.post('/transactions/', data={
            'amount': '-100',
            'currency': 'CNY',
            'category': '1',
            "date": "2018-10-29"
        })
        self.assertEqual(response.status_code, 401)

    def test_show_all_transactions(self):
        # add a transaction
        header = self.test_add_transaction()

        # list all transactions
        response = self.client.get('/transactions/', headers=header)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('"date": "2018-10-29"' in response.get_data(as_text=True))

    def test_show_all_transactions_before_login(self):
        # show all transactions without logging in
        response = self.client.get('/transactions/')
        self.assertEqual(response.status_code, 401)

    def test_show_one_transaction(self):
        # add a transaction
        header = self.test_add_transaction()

        # show this new added transaction
        response = self.client.get('/transactions/1', headers=header)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('"date": "2018-10-29"' in response.get_data(
            as_text=True))

    def test_show_one_non_exist_transaction(self):
        # add a transaction
        header = self.test_add_transaction()

        # try to show a non-exist transaction
        response = self.client.get('/transactions/233', headers=header)
        self.assertEqual(response.status_code, 404)
        self.assertTrue('Transaction not found' in response.get_data(
            as_text=True))

    def test_update_one_transaction(self):
        # add a transaction
        header = self.test_add_transaction()

        # update the currency to be USD
        response = self.client.put('/transactions/1', headers=header, data={
            'currency': 'USD'
        })
        self.assertEqual(response.status_code, 200)
        self.assertTrue('Transaction update succeeded' in response.get_data(
            as_text=True))

        # check the update
        response = self.client.get('/transactions/1', headers=header)
        self.assertTrue('"currency": "USD"' in response.get_data(
            as_text=True))

    def test_update_one_non_exist_transaction(self):
        # add a transaction
        header = self.test_add_transaction()

        # try to update a non-exist transaction
        response = self.client.put('/transactions/233', headers=header, data={
            'currency': 'USD'
        })
        self.assertEqual(response.status_code, 404)
        self.assertTrue('Transaction not found' in response.get_data(
            as_text=True))

    def test_delete_one_transaction(self):
        # add a transaction
        header = self.test_add_transaction()

        # delete this new added transaction
        response = self.client.delete('/transactions/1', headers=header)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('Transaction deletion succeeded' in response.get_data(
            as_text=True))

        # try to look up this transaction
        response = self.client.get('/transactions/1', headers=header)
        self.assertEqual(response.status_code, 404)
        self.assertTrue('Transaction not found' in response.get_data(
            as_text=True))

    def test_delete_one_non_exist_transaction(self):
        # add a transaction
        header = self.test_add_transaction()

        # delete this new added transaction
        response = self.client.delete('/transactions/233', headers=header)
        self.assertEqual(response.status_code, 404)
        self.assertTrue('Transaction not found' in response.get_data(
            as_text=True))

    def test_debug(self):
        # test show all
        response = self.client.get('/transactions/show')
        self.assertEqual(response.status_code, 200)
