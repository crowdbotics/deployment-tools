Note, this script will work only if you configured `HtmlWebpackPlugin`, which handles `index.html` and copies it to the `dist/` folder after build process.

## Step 1
Make sure you installed [s3-deploy](https://www.npmjs.com/package/s3-deploy) as a development dependency.
`yarn add --dev s3-deploy` or `npm install --save-dev s3-deploy`

## Step 2
Create `deploy` script in `package.json` with s3-deploy package:

### Recipes
All files from `dist/` to S3 bucket root. (vue-cli webpack template)
```json
{
  "scripts": {
    "deploy": "npm run build && s3-deploy './dist/**' --cwd './dist/'"
  }
}
```
`index.html` to S3 bucket root plus dist folder. (vue-clie webpack-simple template)
```json
{
  "scripts": {
    "deploy": "npm run build && s3-deploy 'index.html' './dist/**' --cwd '.'"
  }
}
```

## Step 3
Choose one of the AWS authentication [methods](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#config-settings-and-precedence), which is suitable for your needs. (script below will be using environment variables)

**Be careful! Don't let your credentials be pushed to public repositories!**

## Step 4
Download or just copy-paste this script to your `.deploy.sh` file. Change your credentials, aws bucket and region, your slack hook endpoint.

```bash
# Credentials section
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
bucket=BUCKET_NAME
region=REGION_NAME (for example us-west-1)
slack_endpoint=https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX


# Removing old dist
rm -rf dist

# Executing deploy script from package.json with region and bucket from credentials
# above. Also, if deploy was successful sending POST request to slack endpoint,
# to activate hook.
npm run deploy -- --region ${region} --bucket ${bucket} &&
  curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"New version has been delivered to S3!\nLast commit: $(git log -1 --pretty=%B)\"}" \
  ${slack_endpoint}

# Removing new dist after deploy
rm -rf dist
```

## Step 5
Configure your CI system to execute the script after successful build. Here's an example for **CircleCI**, you need to paste this configuration to `circle.yml`.
```yaml
deployment:
  production:
    branch: master
    commands:
      - sh .deploy.sh

```
