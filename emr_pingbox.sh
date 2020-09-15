#!/bin/bash
set -x
IP_ADDRESS=8.8.8.8
REGION=eu-west-3
FILE=/tmp/ping_box.sh
INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`

while true;
do
  AVG_PING=`ping -c 1 $IP_ADDRESS  | awk -F\/ '/rtt/ {print $5}'`
  aws cloudwatch put-metric-data --metric-name ping --namespace EMR --unit Milliseconds --value "$AVG_PING" --dimensions InstanceId=$INSTANCE_ID --storage-resolution 1 --region $REGION
  echo "Host is online : $AVG_PING"
  sleep 1
done
