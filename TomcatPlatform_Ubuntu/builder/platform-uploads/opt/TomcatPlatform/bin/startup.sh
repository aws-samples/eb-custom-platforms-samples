#!/bin/bash -xe
#   Copyright  2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.



. /etc/TomcatPlatform/platform.config

#SHUTDOWN EXISTING APP
cd $APP_DIR

if [ -f $LIVE_DIR/$APP_NAME-$APP_PORT.pid ] && [ -f $LIVE_DIR/$APP_NAME/bin/shutdown.sh ]; then
        echo "Shutting down current app"
        $LIVE_DIR/$APP_NAME/bin/shutdown.sh
        if [ $? -ne 0 ]; then
                echo "Unable to shutdown tomcat. Exiting."
                exit 1
        fi

        echo "DELETEING CURRENT APP"
        rm -rf $LIVE_DIR
fi

mkdir -p $LIVE_DIR
cd $LIVE_DIR
tomcat7-instance-create $APP_NAME -p $APP_PORT

mkdir $LIVE_DIR/$APP_NAME/webapps/ROOT
cp -r $STAGING_DIR/*  $LIVE_DIR/$APP_NAME/webapps/ROOT/
chown tomcat7:tomcat7 $LIVE_DIR -R

# Create /etc/tomcat-apps/$APP_NAME/bin/set-app-env.sh
# CONTENT BELOW
echo "CATALINA_PID=$LIVE_DIR/$APP_NAME-$APP_PORT.pid" > $LIVE_DIR/$APP_NAME/bin/setenv.sh
echo "CATALINA_OPTS=-Djava.security.egd=file:/dev/./urandom" >> $LIVE_DIR/$APP_NAME/bin/setenv.sh

# start tomcat here
$LIVE_DIR/$APP_NAME/bin/startup.sh

