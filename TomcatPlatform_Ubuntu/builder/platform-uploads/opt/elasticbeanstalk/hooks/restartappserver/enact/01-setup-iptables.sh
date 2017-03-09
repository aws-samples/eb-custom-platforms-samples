#!/bin/bash -xe
#   Copyright  2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.



# ROUTE ALL TRAFFIC on 80 to 8080
iptables -t nat -I PREROUTING --src 0/0 --dst 127.0.0.1 -p tcp --dport 80 -j REDIRECT --to-port 8080 -m comment --comment added_for_tomcat_app
iptables -t nat -A OUTPUT -o lo  -p tcp --dport 80 -j REDIRECT --to-port 8080 -m comment --comment added_for_tomcat_app
iptables-save

