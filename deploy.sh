#!/bin/sh

export $(cat .env | xargs)

npm run test

if [ $? -gt 0 ] ;then
  echo "**** oops... ****"
  exit 1
fi

npm run build

aws s3 cp ./dist/index.html s3://aws.noplan.cc/index.html --cache-control no-store
aws s3 cp ./dist/bundle.js s3://aws.noplan.cc/bundle.js --cache-control max-age=31536000
aws cloudfront create-invalidation --distribution-id $CF_DIST_ID --paths / /index.html