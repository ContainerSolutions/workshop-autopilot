#!/bin/sh
set
for app in nginx customers sales
do  
    curl -u $MANTL_LOGIN:$MANTL_PASSWORD -k -X DELETE -H 'Content-Type: application/json' https://${MANTL_CONTROL_HOST}:8080/v2/apps/${IMAGE_PREFIX}/ap-$app
done
