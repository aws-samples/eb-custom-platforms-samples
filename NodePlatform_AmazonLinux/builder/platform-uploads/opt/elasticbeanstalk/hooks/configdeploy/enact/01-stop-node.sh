#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#!/bin/bash -xe

. /etc/SampleNodePlatform/platform.config

NODE_PS_COUNT=$(ps ax | grep -i 'node ' | grep -v grep | grep -v '.pm2' | wc -l )
if [ $NODE_PS_COUNT -ge 1 ]; then
	echo "Stopping node processes"
        pm2 stop all
	pm2 delete all
	for p in `ps ax | grep -i pm2 | grep -v grep | awk '{print $1}' ` ; do  echo "PROCESS to kill: $p"; kill -9 $p ; done
else
        echo "No node processes to stop. Skipping."
fi

