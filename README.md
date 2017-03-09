# eb-custom-platforms-samples
Elastic Beanstalk samples for running on custom platforms.

## Pre-requisites

Ensure that you have the latest version of the EB CLI installed before using the samples.
Instructions for installing the EB CLI can be found [here](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html).

## Using the provided samples
1. To use these samples, clone this git repo.
2. **cd** into the directory for the platform to test. For example, the Node platform on Ubuntu is under *NodePlatform_Ubuntu*.
```
cd NodePlatform_Ubuntu
```
### Updating Packer template
All provided custom platform samples use [Packer](http://www.packer.io) for creating AMIs. 

We have provided Packer templates (*custom_platform.json* or *tomcat_platform.json*) along with our sample plaforms.

- **Note**: None of the Packer templates in the samples contain values for **region** and **source_ami**. You must supply those values before you attempt to create a custom platform.
- The **source_ami** in the Packer template depends on the *[flavor](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/platform-yaml-format.html)* of the sample. See the value of **platform.yaml** in each sample template for the *flavor*.
- The latest AMI for the *flavor* can be found from the AWS EC2 console by searching for official AMIs provided by the operating system provider. Copy the AMI ID from the EC2 console and update the provided Packer template.
- The **region** in the Packer template should match the region from where you copied the value of the EC2 AMI.

### Creating Custom platforms

Initialize a EB CLI platform workspace by entering the following command and following the prompts.
```
$ ebp init
...
$ ebp create
```
After the platform has been created successfully, you will see the ARN for the Beanstalk platform in the event stream on your console. Note the platform ARN, you will need it to create your environment below. 

**Note** : You will need an instance profile to create a platform successfully. The CLI will create an instance profile for you named **aws-elasticbeanstalk-custom-platform-ec2-role** with the correct permissions for the samples to work. To use your own instance profile, ensure that your instance profile has all of the policies included in the Beanstalk Managed role under the name **AWSElasticBeanstalkCustomPlatformforEC2Role**. You can read more on attaching managed policies to your role [here](http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html#aws-managed-policies)

As your custom platform is creating, you will see logs from the Packer build stream to your console. Any errors when building the platform when running Packer should be relayed back. You can check the logs for any platform build using the logs command below.
```
$ eb platform logs --help
```

### Creating Beanstalk environment
Once you have succesfully created the platform you can test the platform by creating an Elastic Beanstalk environment in a new workspace using the platform ARN that was provided in the previous step.
```
$ cd /path/to/new/environment/workspace
$ eb init
$ eb create -p <platform arn>
```
