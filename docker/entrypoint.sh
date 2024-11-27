#!/bin/bash
set -e

if [[ "$@" == "bash" ]]; then
    exec $@
fi

test -z "${DB_USER}" && echo "DB_USER is not defined" && exit 1
test -z "${DB_PASS}" && echo "DB_PASS is not defined" && exit 1
test -z "${DB_NAME}" && echo "DB_NAME is not defined" && exit 1
test -z "${DB_HOST}" && echo "DB_HOST is not defined" && exit 1
test -z "${S3_BACKET}" && echo "S3_BACKET is not defined" && exit 1
test -z "${S3_ACCESS_KEY}" && echo "S3_ACCESS_KEY is not defined" && exit 1
test -z "${S3_SECRET_KEY}" && echo "S3_SECRET_KEY is not defined" && exit 1
test -z "${S3_PATH}" && S3_PATH=''
test -z "${S3_NAME_PREFIX}" && S3_NAME_PREFIX='' || S3_NAME_PREFIX=${S3_NAME_PREFIX}_
test -z "${S3_PROVIDER}" && S3_PROVIDER='yandex'
test -z "${ADD_TIME}" && ADD_TIME='false'

if [ "${ADD_TIME}" = "true" ]; then
  POSTFIX=$(date +%Y-%m-%d_%H-%M).sql
else
  POSTFIX=$(date +%Y-%m-%d).sql
fi

if [ "${S3_PROVIDER}" = "selectel" ]; then
  mv /root/.s3cfg_selectel ~/.s3cfg
else
  mv /root/.s3cfg_yandex ~/.s3cfg
fi

echo "access_key = ${S3_ACCESS_KEY}" >> ~/.s3cfg
echo "secret_key = ${S3_SECRET_KEY}" >> ~/.s3cfg

PGPASSWORD=${DB_PASS} pg_dump --host=${DB_HOST} --username=${DB_USER} ${DB_NAME} > /${DB_NAME}_${POSTFIX}
gzip /${DB_NAME}_${POSTFIX}
s3cmd --storage-class COLD put /${DB_NAME}_${POSTFIX}.gz s3://${S3_BACKET}/${S3_PATH}/${S3_NAME_PREFIX}${DB_NAME}_${POSTFIX}.gz

exec "$@"
