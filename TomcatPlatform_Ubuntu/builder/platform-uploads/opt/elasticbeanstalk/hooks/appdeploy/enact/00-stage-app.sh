#!/bin/bash -xe
#   Copyright  2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.



. /etc/TomcatPlatform/platform.config

chown tomcat7:tomcat7 $APP_DIR -R

su -p -s /bin/bash tomcat7 /opt/TomcatPlatform/bin/startup.sh

PROCESS_FILE="$LIVE_DIR/$APP_NAME-$APP_PORT.pid"
if [ -e $PROCESS_FILE ]; then
        if [ -e /opt/elasticbeanstalk/bin/healthd-track-pidfile ]; then
                /opt/elasticbeanstalk/bin/healthd-track-pidfile --name application --location "$PROCESS_FILE"
        fi
fi
