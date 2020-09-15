#!/bin/bash
#set -x
# Set the ip address you would lik to ping from the master of your EMR cluster
IP_ADDRESS=8.8.8.8
#Set the region where you would like the metrics to be published ( usually same as your EMR Cluster)
REGION=eu-west-3
#PING frequency in seconds
FREQ=1

FILE=/tmp/emr_pingbox.sh
INSTANCE_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
TIMESTAMP=$(date +%s)

echo "#!/bin/bash">$FILE
echo "while true;">>$FILE
echo "do">>$FILE
echo "  AVG_PING=\`ping -c 1 $IP_ADDRESS  | awk -F\/ '/rtt/ {print \$5}'\`">>$FILE
echo "  aws cloudwatch put-metric-data --metric-name ping --namespace EMR --unit Milliseconds --value \"\$AVG_PING\" --dimensions InstanceId=$INSTANCE_ID,timestamp=$TIMESTAMP --storage-resolution 1 --region $REGION">>$FILE
echo "  sleep $FREQ">>$FILE
echo "done">>$FILE

chmod +x $FILE
#launch in background
nohup $FILE 1>/dev/null 2>/dev/null &
