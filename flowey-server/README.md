# flowey-server
This is the backend server of *flowey*

## Setup the environment
First, create a virtual environment, e.g. if you are using conda:
```bash
conda create -n flowey python=3
```
Then install the required packages:
```bash
pip install -r requirements.txt
```

## TODOS

### Register, Login, Authentication
files: flowey/models.py, flowey/api/auth.py
- [ ] Add a User model. (id, email, password, name)
- [ ] Implement a register API. POST (email, password, name)
- [ ] Implement a login API. POST (email, password)
- [ ] Add unit tests for User table and auth API.

for how to do this, refer to:
1. RESTPlus example: https://flask-restplus.readthedocs.io/en/stable/example.html
2. auth with JWT: http://blog.tecladocode.com/jwt-authentication-and-token-refreshing-in-rest-apis/
3. unit test: https://realpython.com/token-based-authentication-with-flask/

### Transactions and expense tracking
- [ ] implement basic API for user expense tracking (GET, POST, DELETE)