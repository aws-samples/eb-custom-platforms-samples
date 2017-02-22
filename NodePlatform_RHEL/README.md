Node_CustomPlatform_RHEL
========================
This repository contains the source for an Elastic Beanstalk Custom Platform.
This custom platform is based on **RHEL 7.2** and supports **Node.js 4.4.4**.

See the Packer template, *custom_platform.json*, for details on the AMI and
scripts that the builder runs as it creates the custom platform.

Once Packer has built the custom platform, it is available in the Console,
EB CLI, and APIs/SDKs as "Red Hat Enterprise 7.2 NodeJs Container".

For further information on custom platforms, see the
[Custom Platforms docs](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/custom-platforms.html).
