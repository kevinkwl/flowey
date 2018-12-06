import json


def login(test):
    test.client.post('/auth/register', data={
        "email": "kevin@columbia.edu",
        "username": "real_kevin",
        "password": "123"
    })

    response = test.client.post('/auth/login', data={
        'email': 'kevin@columbia.edu',
        'password': '123'
    }, follow_redirects=True)

    d = json.loads(response.get_data(as_text=True))
    header = {'authorization': ' Bearer ' + d['jwt_token']}
    return header


def auth(test, email, username):
    test.client.post('/auth/register', data={
        "email": email,
        "username": username,
        "password": "123"
    })

    response = test.client.post('/auth/login', data={
        'email': email,
        'password': "123"
    }, follow_redirects=True)

    d = json.loads(response.get_data(as_text=True))
    header = {'authorization': ' Bearer ' + d['jwt_token']}
    return header
