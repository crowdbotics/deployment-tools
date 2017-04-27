rm -rf dist
export AWS_ACCESS_KEY_ID=AKIAIXZXFI4DMGGYMUNA
export AWS_SECRET_ACCESS_KEY=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
npm run deploy -- --region us-west-1 --bucket dashboard-vue &&
  curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"New version has been delivered to S3!\nLast commit: $(git log -1 --pretty=%B)\"}" \
  https://hooks.slack.com/services/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
rm -rf dist
