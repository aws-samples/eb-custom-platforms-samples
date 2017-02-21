#   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
#
#   http://aws.amazon.com/apache2.0/
#
#   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#!/bin/bash -xe

. /etc/SampleNodePlatform/platform.config

cd $LIVE_DIR
if [ -f pm2/process.json ]; then
	pm2 start pm2/process.json  
else 
	echo "Unable to create PM2 process file. Exiting."
	exit 1
fi

