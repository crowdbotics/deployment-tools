Note, this script will work only if you configured `HtmlWebpackPlugin`, which handles `index.html` and copies it to the `dist/` folder after build process.

To use the script:

1. Copy `.deploy.sh` to the root folder of webpack project. 
2. Update `GITHUB_USER`\*, `GITHUB_REPOSITORY`\*, `PUSH_USER`\*, `PUSH_EMAIL`\* and `BUILD_COMMAND`(build command is `build` by default).
3. Create CI post-succuss hook to execute the script **only on master branch**. You can find example for CircleCI in `circle.yml` file.
4. Make sure your CI container has access to production repository through SSH.
5. Run CI build. Once it's green dist folder should be copied to production repository.

\* - required

You can either download files from this folder or copy-paste code below:

`.deploy.sh`:
```bash
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
```

`circle.yml`:
```yaml
deployment:
  production:
    branch: master
    commands:
      - sh .deploy.sh
```
