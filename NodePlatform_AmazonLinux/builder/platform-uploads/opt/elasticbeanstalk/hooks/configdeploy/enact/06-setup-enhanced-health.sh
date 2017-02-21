#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#!/bin/bash -xe

. /etc/SampleNodePlatform/platform.config

if [ -d /etc/healthd ]
then
	RESTART_HEALTHD=''
	## Track application pids
	for NAME in `cat $LIVE_DIR/pm2/process.json  | jq '.apps[].name' | sed 's/"//g'`; do 
		for PID_FILE in `ls $PM2_HOME/pids/ | grep $NAME`; do
			if [ ! -z "$PID_FILE" ]; then
				APP=$(echo $PID_FILE | sed 's/.pid//g'); 
				/opt/elasticbeanstalk/bin/healthd-track-pidfile --name $APP --location $PM2_HOME/pids/$PID_FILE 
				RESTART_HEALTHD='true'
			fi
		done
	done

	## restart healthd 
	if [ ! -z "$RESTART_HEALTHD" ]; then
		/opt/elasticbeanstalk/bin/healthd-restart
	else
		echo "Not restarting HealthD since no processes to track"
		exit 1
	fi
fi
