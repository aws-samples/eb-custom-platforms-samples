#!/bin/bash -xe
#   Copyright  2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.




. $BUILDER_DIR/CONFIG

### INSTALL AND VALIDATE NODE ####
echo "SETTING UP NODE ON THE INSTANCE"
yum install -y wget tree

mkdir -p $NODE_DIR
echo "Downloading node from nodejs.org...."
wget https://nodejs.org/dist/v4.4.5/node-v4.4.5-linux-x64.tar.gz  -O $BUILDER_DIR/node-v4.4.5-linux-x64.tar.gz
tar -zxf $BUILDER_DIR/node-v4.4.5-linux-x64.tar.gz -C $NODE_DIR

echo "Validate Node.js got installed."
if [ -a $NODE_DIR/node-v4.4.5-linux-x64/bin/node ]; then
    NODE_VER=`$NODE_DIR/node-v4.4.5-linux-x64/bin/node --version`
    if [ -z "$NODE_VER" ];  then
        echo "Node could not be installed. "
    else
        echo "Node successfully installed.."
    fi
fi

echo "Creating base directories for platform."
mkdir -p $BEANSTALK_DIR/deploy/appsource/
mkdir -p /var/app/staging
mkdir -p /var/app/current
mkdir -p /var/log/nginx/healthd/
chown nginx.nginx /var/log/nginx/healthd/

yum install -y git 

## WRITE NODE_DIR TO CONFIG ON INSTANCE TO BE AVAILABLE FOR HOOKS
mkdir -p $CONTAINER_CONFIG_FILE_DIR
echo "NODE_DIR=$NODE_DIR/node-v4.4.5-linux-x64" >> $CONTAINER_CONFIG
echo "CONTAINER_SCRIPTS_DIR=$CONTAINER_SCRIPTS_DIR" >> $CONTAINER_CONFIG

echo "PATH=\$PATH:\$NODE_DIR/bin" >>  $CONTAINER_CONFIG

##### INSTALL PM2 ######
echo "install pm2 globally"
$NODE_DIR/node-v4.4.5-linux-x64/bin/npm install -g minimatch@3.0.4
$NODE_DIR/node-v4.4.5-linux-x64/bin/npm install -g pm2@2.10.4

ls -l $NODE_DIR/node-v4.4.5-linux-x64/bin

echo "PATH=$PATH:$NODE_DIR/node-v4.4.5-linux-x64/bin" >> ~/.bashrc
PATH=$PATH:$NODE_DIR/node-v4.4.5-linux-x64/bin

echo `which pm2`

echo "Setting up PM2 log-rotate"
$NODE_DIR/node-v4.4.5-linux-x64/bin/pm2 install pm2-logrotate

## Add node path to Beanstalk profile
echo "export PATH=$NODE_DIR/node-v4.4.5-linux-x64/bin:\$PATH:/usr/local/bin" >> /opt/elasticbeanstalk/lib/ruby/profile.sh
echo "export PM2_HOME=/opt/SampleNodePlatform/pids" >> /opt/elasticbeanstalk/lib/ruby/profile.sh

