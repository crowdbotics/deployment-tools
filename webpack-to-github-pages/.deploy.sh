#! /bin/bash

# Declaring variables here since it's only two.
# Once this script grow bigger we can outsource them
# into separate file like shown below.
gh_user=GITHUB_USER
gh_repository=GITHUB_REPOSITORY

# Importing variables
# source ./.deployconf

# Removing dist folder if exists
rm -rf dist

# Clonning production repository to dist folder
git clone git@github.com:${gh_user}/${gh_repository}.git dist

# Deleting everything old from production
(cd dist && rm -rf *)

# Building project for production
npm run build

# Pushing new code to production
(
cd dist
git add -A
git commit -m "$(cd .. && git log -1 --pretty=%B)"
if [ "$?" -ne "0" ]; then
  echo "No last commit in development repository"
  git commit -m "$(date +%Y-%m-%d:%H:%M:%S)"
fi
git push origin +master
)

# Removing dist folder
rm -rf dist