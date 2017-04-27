First of all, make sure you installed [s3-deploy](https://www.npmjs.com/package/s3-deploy) as development dependency.

To install it just execute:
```bash
yarn add --dev s3-deploy
```
or
```bash
npm install --save-dev s3-deploy
```

After it you need to create script in `package.json` for deployment like this:

```json
{
  "scripts": {
    "deploy": "npm run build && s3-deploy './dist/**' --cwd './dist/'"
  }
}
```

Now you need to choose one of AWS authentication [methods](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#config-settings-and-precedence)

We will be using environment variable method:

```bash
rm -rf dist
export AWS_ACCESS_KEY_ID=AKIAIXZXFI4DMGGYMUNA
export AWS_SECRET_ACCESS_KEY=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
npm run deploy -- --region us-west-1 --bucket dashboard-vue &&
  curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"New version has been delivered to S3!\nLast commit: $(git log -1 --pretty=%B)\"}" \
  https://hooks.slack.com/services/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
rm -rf dist
```

```yaml
deployment:
  production:
    branch: master
    commands:
      - sh .deploy.sh

```
