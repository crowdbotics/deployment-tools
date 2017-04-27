## Step 1
Make sure you installed [s3-deploy](https://www.npmjs.com/package/s3-deploy) as a development dependency.
```bash
yarn add --dev s3-deploy
# or
npm install --save-dev s3-deploy
```

## Step 2
Create script in `package.json` for deployment:

```json
{
  "scripts": {
    "deploy": "npm run build && s3-deploy './dist/**' --cwd './dist/'"
  }
}
```

## Step 3
Choose one of AWS authentication [methods](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#config-settings-and-precedence), which is suitable for your needs. (script below will be using environment variables)

## Step 4
Download or just copy-paste this script to your `.deploy.sh` file. Change your credentials, aws bucket and region, your slack hook endpoint.

```bash
rm -rf dist
export AWS_ACCESS_KEY_ID=AKIAIXZXFI4DMGGYMUNA
export AWS_SECRET_ACCESS_KEY=RPft4sgoFBIQRzKIKpYFzDFE76SW0MTCKbibPgRV
npm run deploy -- --region us-west-1 --bucket dashboard-vue &&
  curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"New version has been delivered to S3!\nLast commit: $(git log -1 --pretty=%B)\"}" \
  https://hooks.slack.com/services/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
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
