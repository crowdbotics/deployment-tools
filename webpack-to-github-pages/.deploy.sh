#! /bin/bash

# Declaring variables here since it's only two.
# Once this script grow bigger we can outsource them
# into separate file like shown below.
gh_user=crowdbotics
gh_repository=dashboard-vue-production
# build_command=BUILD_COMMAND
build_command=build

# Importing variables
# source ./.deployconf

# Removing dist folder if exists
rm -rf dist

# Clonning production repository to dist folder
git clone git@github.com:${gh_user}/${gh_repository}.git dist

# Deleting everything old from production
(
cd dist
ls | grep -v CNAME | xargs rm -rf
)

# Building project for production
npm run ${build_command}

# Pushing new code to production
(
cd dist
git add .
git -c user.name="CircleCI" -c user.email="deployment@crowdbotics.com" commit \
    -m "$(cd .. && git log -1 --pretty=%B)"
if [ "$?" -ne "0" ]; then
  echo "Last commit in development repository does not exists"
  git commit -m "$(date +%Y-%m-%d:%H:%M:%S)"
fi
git push
)

# Removing dist folder
rm -rf dist
