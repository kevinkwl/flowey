# Read Me

Flowey is an iOS spending tracker with highlights on bill splits among friends.

Flowey eases the process of calculating receivables and payables and checking each debt's purpose by introducing the convenient bill split and cancelling out receivables and payables in a timely fashion.

## How to build

### `git clone`

To begin with, clone this github repository into a dir named `flowey-s`:

```bash
git clone git@github.com:kevinkwl/flowey.git flowey-s
```

and clone the repository's ios branch into a dir named `flowey`:

```bash
git clone git@github.com:kevinkwl/flowey.git flowey
cd flowey
git checkout ios
```

### Build the server

Navigate into the `flowey-s/flowey-server` dir, use `pip` to install dependencies of the server as indicated in [requirements.txt](./flowey-server/requirements.txt):

```bash
cd flowey-s/flowey-server
conda create --name flowey
source activate flowey
pip install -r "requirements.txt"
```

Remain at `flowey-s/flowey-server` dir and initialize the `FLASK_APP` environment variable

```bash
export FLASK_APP=flasky.py
```

Initialize the database of server:

```bash
flask db init
flask db migrate
```

Start server:
```bash
flask run
```

### Build the iOS app

Firstly, make sure Xcode and Xcode's developer's kit is installed.

Install carthage: Carthage can be installed either via downloading and running a `.pkg` installer, or using `Homebrew` package manager.

Navigate to the root dir of ios and execute `carthage update`:
```bash
cd flowey/flowey
carthage update --platform iOS
```

Open the Xcode project using Xcode
```bash
open flowey.xcodeproj
```

Then build the iOS project in Xcode.

## How to test

### Test the server

There are a set of unit tests under `flowey-s/flowey-server/tests` dir. To run those unit tests, remain at `flowey-s/flowey-server` dir and run
```bash
flask test
```

Tests can also be done by using `flask` app's console:

```bash
flask console
```

or sending URIs to the server via regular browsers or API development environments like [POSTMAN](https://www.getpostman.com/).

File [`test.sh`](./test.sh) in the root dir is for continuous integration tests. It uses `pylint` to find potential bugs and possibly violations of design conventions, unit tests for `flask` app are also executed in the `sh`. The output of the tests are located in `test-reports` branch.

### Test the iOS app

In `flowey/flowey/flowey/Utils/Constants.swift`, specify the `APIBaseURL` to the URL where the `flask` app listens to.
For example,
```swift
static let APIBaseURL = "http://127.0.0.1:5000"
```

After building the iOS project in Xcode, the iOS app simulator will be launched. Tests on the iOS app can be done in the simulator.

## How to install

The flowey app can be installed on iOS device via Xcode:

1. Connect iOS device to Mac
2. Open Xcode, go to `Window -> Devices`
3. Choose the connected device you want to install flowey app on
4. Drag and drop the `.ipa` file into the installed apps

The server app can be deployed on a cloud server like AWS, Google Cloud, or locally on the development computer.

## How to operate

### Registration

1. Launch the flowey app
2. Click "Create a new account"
3. Enter email address, password and username
4. Click "Register"

### Login

1. Lauch the flowey app or navigate to the main scene
2. Enter email address and password
3. Click "Login"

### Logout

1. Click last tab "Setting"
2. Click "Logout"

### Log a new expense

1. Click first tab "Expenses"
2. Click "+"
3. Enter Amount
4. Select Date
5. Select Category
6. Click "Done"

### Log a new interpersonal transaction

1. Click first tab "Expenses"
2. Click "+"
3. Enter Amount
4. Select Date
5. Select Category (Lend or Borrow)
6. Click "Choose a friend"
7. Choose the friend related with the transaction
8. Click "Done"

### Log a new expense with bill split

1. Click first tab "Expenses"
2. Click "+"
3. Enter Amount
4. Select Date
5. Select Category
6. Switch on "Split bill with friends"
7. Click "Split with"
8. Select the friends for bill split
9. Click "Back"
10. Click "Done"

### View transaction history

1. Click first tab "Expenses"
2. The transactions list and summary are shown in the scene

### Delete a transaction

1. Click first tab "Expenses"
2. The transactions list and summary are shown in the scene
3. Find the transaction to delete
4. Short slide left and click "Delete" to delete
5. Or long slide left to delete

### Add a new friend

1. Click second tab "Friends"
2. Click "+"
3. Enter the friend's email address (must be a current user of flowey app)
4. Click "Request"

### Approve/Decline a friend invitation

1. Click third tab "Notifications"
2. Find the friend invitation
3. Click "Accept" to approve the invitaion
4. Slide left and click "Reject" to decline the invitation

### View friends list and current debt status with friends

1. Click second tab "Friends"
2. The friends list and the debt status between the user and his/her friends are shown

### Delete a friend

1. Click second tab "Friends"
2. The friends list and the debt status between the user and his/her friends are shown
3. Find the friend to delete
4. Short slide left and click "Delete" to delete
5. Or long slide left to delete

<!-- # flowey
* flowey-server - server of flowey
* report - store results after running test.sh
* test.sh - a bash used to run pylint (Bugfinder) -->