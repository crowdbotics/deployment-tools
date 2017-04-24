#! /bin/bash

# Declaring variables here since it's only two.
# Once this script grow bigger we can outsource them
# into separate file like shown below.
gh_user=GITHUB_USER
gh_repository=GITHUB_REPOSITORY
push_user=PUSH_USER
push_email=PUSH_EMAIL
# build_command=BUILD_COMMAND
build_command=build

# Importing variables
# source ./.deployconf

# Removing dist folder if exists
rm -rf dist

# Clonning production repository to dist folder
git clone git@github.com:${gh_user}/${gh_repository}.git dist

# Deleting everything old from production except CNAME file
(
cd dist
ls | grep -v CNAME | xargs rm -rf
)

# Building project for production
npm run ${build_command}

# Pushing new code to production
(
cd dist
git add -A
git -c user.name="${push_user}" -c user.email="${push_email}" commit \
    -m "$(cd .. && git log -1 --pretty=%B)"
if [ "$?" -ne "0" ]; then
  echo "Last commit in development repository does not exists"
  git commit -m "$(date +%Y-%m-%d:%H:%M:%S)"
fi
git push origin master
)

# Removing dist folder
rm -rf dist
