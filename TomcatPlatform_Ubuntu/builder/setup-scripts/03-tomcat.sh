#!/bin/bash -xe
#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

. $BUILDER_DIR/CONFIG

echo "Installing Tomcat7.. "
apt-get -y install tomcat7 tomcat7-user

echo "installing JRE"
apt-get -y install default-jre

mkdir -p /var/log/tomcat-apps/
chown -R tomcat7:tomcat7 /var/log/tomcat-apps/

mkdir -p /etc/tomcat-apps/
chown -R tomcat7:tomcat7 /etc/tomcat-apps

mkdir -p /var/run/tomcat-apps/
chown -R tomcat7:tomcat7 /var/run/tomcat-apps/

mkdir -p /opt/TomcatPlatform/conf
chown -R tomcat7:tomcat7 /opt/TomcatPlatform


cd /usr/share/tomcat7
ln -s /var/lib/tomcat7/common/ common
ln -s /var/lib/tomcat7/server/ server
ln -s /var/lib/tomcat7/shared/ shared
ln -s /var/lib/tomcat7/common/ conf


mkdir -p $CONTAINER_CONFIG_FILE_DIR
