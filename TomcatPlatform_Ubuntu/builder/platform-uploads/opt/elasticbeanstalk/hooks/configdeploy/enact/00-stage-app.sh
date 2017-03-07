#!/bin/bash -xe
#   Copyright  2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.



mkdir  -p /var/run/tomcat-apps/
chown tomcat7:tomcat7 /var/run/tomcat-apps/

su -p -s /bin/bash tomcat7 << 'EOF'

. /etc/TomcatPlatform/platform.config

#SHUTDOWN EXISTING APP
cd $APP_DIR
if [ -d $LIVE_APP ]; then
        echo "Shutting down current app"
        $LIVE_APP/$APP_NAME/bin/shutdown.sh

        echo "DELETEING CURRENT APP"
        rm -rf $LIVE_APP
fi

mkdir $LIVE_APP
cd $LIVE_APP

tomcat7-instance-create $APP_NAME -p $APP_PORT
rm -rf $APP_NAME/logs
ln -s /var/log/tomcat-apps/ $APP_NAME/logs
mkdir $APP_NAME/webapps/ROOT
cp -r $STAGING_DIR/*  $APP_NAME/webapps/ROOT/

# add this to the bin/setenv.sh file
#echo "source \$CATALINA_BASE/bin/set-app-env.sh" >> $APP_NAME/bin/setenv.sh

# Create /etc/tomcat-apps/$APP_NAME/bin/set-app-env.sh
# CONTENT BELOW
echo "CATALINA_PID=/var/run/tomcat-apps/$APP_NAME-$APP_PORT.pid" > $APP_NAME/bin/setenv.sh

# start tomcat here

$APP_NAME/bin/startup.sh
EOF

. /etc/TomcatPlatform/platform.config
PROCESS_FILE="/var/run/tomcat-apps/$APP_NAME-$APP_PORT.pid"
if [ -e $PROCESS_FILE ]; then
        if [ -e /opt/elasticbeanstalk/bin/healthd-track-pidfile ]; then
                /opt/elasticbeanstalk/bin/healthd-track-pidfile --name application --location "$PROCESS_FILE"
        fi
fi

