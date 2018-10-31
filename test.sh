#!/bin/bash
mkdir -p report
pylint --disable=C flowey-server -f colorized > report/test_result.txt


cd flowey-server
FLASK_APP=flasky.py flask test --coverage

