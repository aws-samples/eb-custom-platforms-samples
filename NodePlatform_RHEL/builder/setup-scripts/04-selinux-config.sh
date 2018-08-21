#!/bin/bash -xe
#   Copyright  2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.



. $BUILDER_DIR/CONFIG

if [ -z ${USE_SELINUX+x} ]; then
    echo "not setting up se linux config"
    exit 0;
elif [ "true" = "$USE_SELINUX" ]; then
    echo "Setting selinux configs."
    setenforce 0
    semanage permissive -a httpd_t
    # in the latest RHEL ami, 8081 && 8080 has already defined
    # semanage port -a -t http_port_t -p tcp 8081
    # semanage port -a -t http_port_t -p tcp 8080
    setsebool -P httpd_can_network_connect 1
    chcon -Rt httpd_sys_content_t /var/app/current/
    chcon -u system_u -t httpd_config_t $NGINX_DEST_DIR/conf.d/proxy.conf
else 
    echo "not setting up se linux config"
fi
    
