#!/bin/bash
mkdir -p report
pylint --disable=C flowey-server -f colorized > report/test_result.txt

