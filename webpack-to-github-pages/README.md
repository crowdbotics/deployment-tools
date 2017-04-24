Note, this script will work only if you configured `HtmlWebpackPlugin`, which handles `index.html` and copies it to the `dist/` folder.

To use the script:

1. Copy `.deploy.sh` to the root folder of webpack project. 
2. Update `GITHUB_USER`, `GITHUB_REPOSITORY` and `BUILD_COMMAND`(build command is `build` by default).
3. Create CI post-succuss hook to execute the script *only on master branch*. You can find example for CircleCI in `circle.yml` file.
4. Make sure your CI container has access to production repository through SSH.
5. Run CI build. Once it's green dist folder should be copied to production repository.
