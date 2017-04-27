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
