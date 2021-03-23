
echo -n "Locating S3 bucket ($BUCKET_NAME) ... "
BUCKET_EXISTS=true
S3_CHECK=$(aws s3 ls "s3://${BUCKET_NAME}" 2>&1)

#Some sort of error happened with s3 check
if [ $? != 0 ]
then
  NO_BUCKET_CHECK=$(echo "$S3_CHECK" | grep -c 'NoSuchBucket')
  if [ "$NO_BUCKET_CHECK" = 1 ]; then
    echo "[NOT FOUND]"
    BUCKET_EXISTS=false
  else
    echo "[ERROR CHECKING]"
    echo "$S3_CHECK"
    exit 1
  fi
else
  echo "[FOUND]"
  echo "Deploying files ($BUCKET_NAME) ..."
  aws s3 cp --recursive --acl public-read --cache-control="max-age=0, no-cache, no-store, must-revalidate" ./www s3://$BUCKET_NAME/
fi
