#!/bin/bash
mkdir -p reports
pylint --disable=C flowey-server -f colorized > reports/pylint_result.txt


cd flowey-server
FLASK_APP=flasky.py flask test --coverage > ../reports/test_with_coverage.txt 2>&1
cd ..

