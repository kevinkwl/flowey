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
    header = {'JWT-TOKEN': ' Bearer ' + d['jwt_token'], 'userid': d['user']['id']}
    return header


def login2(test):
    test.client.post('/auth/register', data={
        "email": "finn@columbia.edu",
        "username": "real_finn",
        "password": "123"
    })

    response = test.client.post('/auth/login', data={
        'email': 'finn@columbia.edu',
        'password': '123'
    }, follow_redirects=True)

    d = json.loads(response.get_data(as_text=True))
    header = {'JWT-TOKEN': ' Bearer ' + d['jwt_token'], 'userid': d['user']['id']}
    return header

def login3(test):
    test.client.post('/auth/register', data={
        "email": "alex@columbia.edu",
        "username": "real_alex",
        "password": "123"
    })

    response = test.client.post('/auth/login', data={
        'email': 'alex@columbia.edu',
        'password': '123'
    }, follow_redirects=True)

    d = json.loads(response.get_data(as_text=True))
    header = {'JWT-TOKEN': ' Bearer ' + d['jwt_token'], 'userid': d['user']['id']}
    return header


def login4(test):
    test.client.post('/auth/register', data={
        "email": "blake@columbia.edu",
        "username": "real_finn",
        "password": "123"
    })

    response = test.client.post('/auth/login', data={
        'email': 'blake@columbia.edu',
        'password': '123'
    }, follow_redirects=True)

    d = json.loads(response.get_data(as_text=True))
    header = {'JWT-TOKEN': ' Bearer ' + d['jwt_token'], 'userid': d['user']['id']}
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
    header = {'JWT-TOKEN': ' Bearer ' + d['jwt_token']}
    return header
