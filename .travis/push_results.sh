#!/bin/sh

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

commit_website_files() {
  git checkout -b test_reports
  git add reports
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git remote add origin-tests https://${GH_TOKEN}@github.com/kevinkwl/flowey.git > /dev/null 2>&1
  git push --quiet --set-upstream origin-tests test-reports
}

setup_git
commit_website_files
upload_files
