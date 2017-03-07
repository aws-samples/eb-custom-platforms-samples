Node_CustomPlatform_AmazonLinux
===============================
This repository contains the source for an Elastic Beanstalk Custom Platform.
This custom platform is based on **Amazon Linux 2016.09.1** and supports **Node.js 4.4.4**.

See the Packer template, *custom_platform.json*, for details on the AMI and
scripts that the builder runs as it creates the custom platform.

To use this sample app, please update *custom_platform.json* with:

1. The AMI id you would like to use as your base AMI to create the platform.
2. The region you want to create your platform in.


Once Packer has built the custom platform, it is available in the Console,
EB CLI, and APIs/SDKs as "Sample NodeJs Container".

For further information on custom platforms, see the
[Custom Platforms docs](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/custom-platforms.html).
