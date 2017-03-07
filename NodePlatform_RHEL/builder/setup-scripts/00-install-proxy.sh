#!/bin/bash -xe
#   Copyright  2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.



. $BUILDER_DIR/CONFIG
yum install -y nginx
chkconfig nginx on
service nginx stop

if [ -e /etc/nginx/conf.d/default.conf ]; then
    rm -f /etc/nginx/conf.d/default.conf
fi
