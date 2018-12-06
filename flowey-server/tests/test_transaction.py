import unittest
from flowey.app import create_app
from flowey.ext import db
from flowey.models import User
from tests.utils import login, login2, login3, login4
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

    def test_lend_money(self):
        # two users kevin, finn login
        header1 = login(self)
        header2 = login2(self)

        # kevin asks finn to become friends, finn agrees
        user1 = User.query.filter_by(email='kevin@columbia.edu').first_or_404()
        user2 = User.query.filter_by(email='finn@columbia.edu').first_or_404()
        user1.send_friend_request_to(user2)
        user2.agree_friend_request_from(user1)

        # add a new transaction to lend kevin 100 yuan
        response = self.client.post('/transactions/', headers=header2, data={
            'amount': '100',
            'currency': 'CNY',
            'category': '2',
            "date": "2018-10-29",
            'object_user_id': header1['userid']
        })

        self.assertEqual(response.status_code, 200)
        self.assertTrue('Transaction creation succeeded' in response.get_data(
            as_text=True))

        # show this new added transaction from finn's perspective
        response = self.client.get('/transactions/1', headers=header2)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('"category": 2' in response.get_data(
            as_text=True))
        self.assertTrue('"object_user_id": ' + str(header1['userid']) in response.get_data(
            as_text=True))
        # print(response.get_data(as_text=True))

        # show this new added transaction from kevin's perspective
        response = self.client.get('/transactions/2', headers=header1)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('"category": 3' in response.get_data(
            as_text=True))
        self.assertTrue('"object_user_id": ' + str(header2['userid']) in response.get_data(
            as_text=True))
        return header1, header2

    def test_lend_money_without_object(self):
        # two users kevin, finn login
        login(self)
        header2 = login2(self)

        # kevin asks finn to become friends, finn agrees
        user1 = User.query.filter_by(email='kevin@columbia.edu').first_or_404()
        user2 = User.query.filter_by(email='finn@columbia.edu').first_or_404()
        user1.send_friend_request_to(user2)
        user2.agree_friend_request_from(user1)

        # add a new transaction to lend kevin 100 yuan
        response = self.client.post('/transactions/', headers=header2, data={
            'amount': '100',
            'currency': 'CNY',
            'category': '2',
            "date": "2018-10-29"
        })
        self.assertEqual(response.status_code, 400)

    def test_borrow_money(self):
        # two users kevin, finn login
        header1 = login(self)
        header2 = login2(self)

        # kevin asks finn to become friends, finn agrees
        user1 = User.query.filter_by(email='kevin@columbia.edu').first_or_404()
        user2 = User.query.filter_by(email='finn@columbia.edu').first_or_404()
        user1.send_friend_request_to(user2)
        user2.agree_friend_request_from(user1)

        # add a new transaction to lend kevin 100 yuan
        response = self.client.post('/transactions/', headers=header2, data={
            'amount': '100',
            'currency': 'CNY',
            'category': '3',
            "date": "2018-10-29",
            'object_user_id': header1['userid']
        })

        self.assertEqual(response.status_code, 200)
        self.assertTrue('Transaction creation succeeded' in response.get_data(
            as_text=True))

        # show this new added transaction from finn's perspective
        response = self.client.get('/transactions/1', headers=header2)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('"category": 3' in response.get_data(
            as_text=True))
        self.assertTrue('"object_user_id": ' + str(header1['userid']) in response.get_data(
            as_text=True))

        # show this new added transaction from kevin's perspective
        response = self.client.get('/transactions/2', headers=header1)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('"category": 2' in response.get_data(
            as_text=True))
        self.assertTrue('"object_user_id": ' + str(header2['userid']) in response.get_data(
            as_text=True))
        return header1, header2

    def test_return_money(self):
        # finn lends kevin 100 yuan
        header1, header2 = self.test_lend_money()

        # add a new transaction for kevin to return 60 yuan
        response = self.client.post('/transactions/', headers=header1, data={
            'amount': '60',
            'currency': 'CNY',
            'category': '5',
            "date": "2018-10-29",
            'object_user_id': header2['userid']
        })
        self.assertEqual(response.status_code, 200)
        self.assertTrue('Transaction creation succeeded' in response.get_data(
            as_text=True))

        # show the curren flow from finn's perspective
        response = self.client.get('friends/', headers=header1)
        self.assertEqual(response.status_code, 200)
        self.assertTrue('{"transaction_id": 3, "amount": 60, "currency": "CNY", "category": 5, '
                        '"date": "2018-10-29"' in response.get_data(as_text=True))
        self.assertTrue('"user_id": 1, "object_user_id": 2}' in response.get_data(as_text=True))

        return header1, header2

    def test_split_money(self):
        # two users kevin, finn login
        header1 = login(self)
        header2 = login2(self)
        header3 = login3(self)
        header4 = login4(self)

        user1 = User.query.filter_by(email='kevin@columbia.edu').first_or_404()
        user2 = User.query.filter_by(email='finn@columbia.edu').first_or_404()
        user3 = User.query.filter_by(email='blake@columbia.edu').first_or_404()
        user4 = User.query.filter_by(email='alex@columbia.edu').first_or_404()
        user1.send_friend_request_to(user2)
        user2.agree_friend_request_from(user1)
        user1.send_friend_request_to(user3)
        user3.agree_friend_request_from(user1)
        user1.send_friend_request_to(user4)
        user4.agree_friend_request_from(user1)
        user2.send_friend_request_to(user3)
        user3.agree_friend_request_from(user2)
        user2.send_friend_request_to(user4)
        user4.agree_friend_request_from(user2)
        user3.send_friend_request_to(user4)
        user4.agree_friend_request_from(user3)

        # add a new transaction for kevin to split 100 yuan
        response = self.client.post('/transactions/', headers=header1, data={
            'amount': '100',
            'currency': 'CNY',
            'category': '1',
            "date": "2018-10-29",
            'split_with': [header2['userid'], header3['userid'], header4['userid']]
        })
        self.assertEqual(response.status_code, 200)

        # check the money for kevin and alex
        response = self.client.get('transactions/', headers=header1)
        self.assertTrue('"amount": 25' in response.get_data(as_text=True))
        response = self.client.get('transactions/', headers=header3)
        self.assertTrue('"amount": 25' in response.get_data(as_text=True))

    def test_debug(self):
        # test show all
        response = self.client.get('/transactions/show')
        self.assertEqual(response.status_code, 200)
