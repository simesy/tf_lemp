# Drupal Hosting as a Terraform module

The goal of this project is to be a drop-in AWS hosting solution for a Drupal site. Does it need to be a Drupal site? No, but that's what it's being built to do, and there are already some architecture decisions around how to manage blue/green deployments. Some of the long term requirements are:

* Load balanced with auto-scaling for nginx/php application instances
* Aurora or RDS database with optional replication
* Out-of-box integration with load balancing and performance monitoring to be able to tune for cost/performance
* Deploying application instances with Ansible (ansible-pull)
* Consistent tagging of AWS resources for effective cost monitoring
* Ability to pass through parameters from Terraform to Ansible to control application versioning
* Efficient database backups to S3
* A solution for schedule jobs
* Can spin up parallel/identical environmetn and destroy after use, which allows...
* CI/Smoke test environments or QA demos.

# Out of scope

The idea is to spin up an AWS architecture with enough smarts to then hand-off to an
Ansible provisioner, which might live in another repository. So the Ansible playbook is parametized combination of a repository url and a playbook path within that repository.

Current we are not using our own pre-baked AMIs, to keep things generic, but if we did the AMI would have nginx and PHP preinstalled. You can pass in a custom AMI of course.

## Requirements

Before you begin you will need to:

* Install [Terraform](https://www.terraform.io/intro/getting-started/install.html)
* Sign up for AWS, [store your credentials locally](http://docs.aws.amazon.com/sdk-for-net/v2/developer-guide/net-dg-config-creds.html#creds-file).
* Your SSH Public Key (eg `cat ~/.ssh/id_rsa.pub`)
* A valid AMI, see next section.

## The AMI

The project currently uses an [Amazon Machine Image](https://aws.amazon.com/marketplace/pp/B01N0MCONW)
(AMI) that has nginx pre-installed (available in Sydney region). This is a short term solution *it will soon
be replaced* with a Ubuntu AMI.

In the meantime, feel free to do an experimental `terraform apply`. You'll just need to
accept the AMIs service [terms and conditions](https://aws.amazon.com/marketplace/fulfillment?productId=7dc83b25-1a57-418d-acea-06bd8e0855fb&ref_=dtl_psb_continue&region=ap-southeast-2#manual-launch)
while logged into your AWS account. 

## Hello world

1. Create a new directory and a main.tf (see sample below).
2. From the directory, run `terraform get` to pull in the module
3. Run `terraform plan` and `terraform apply` to create lots of AWS.
4. *AVOID PAYING $$$* - Run `terraform destroy`.

```
# main.tf
module "mymodule" {
    # This repo
    source            = "github.com/simesy/tf_lemp"

    # Something short and pithy that is used for naming AWS resources.
    identifier        = "test"

    # Used as the AWS "Application ID"
    application_id    = "Web-R-Us Apps"

    # A repo and (within that repo) an Ansible playbook path.
    # Path to the playbook file in the `app_repo` repository.
    app_repo          = "https://github.com/simesy/tf_lemp"
    app_playbook      = "nginx/playbook.yml"
    
    # A public key (eg the contents of `cat ~/.ssh/id_rsa.pub`.
    # This will be deployed into the nginx servers.
    public_key        = "ssh-rsa ..."

    # Whether to allow remote (SSH) access to the nginx servers.
    # (Note currently working)
    remote_access     = "true"
    
    # Other defaults.
    # aws_region   = "ap-southeast-2"
    # aws_az       = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
    # aws_ami      = "ami-ba231ad9"
    # asg_min      = "1"
    # asg_max      = "2"
    # asg_desired  = "1"
    # asg_size     = "t1.micro"
}
```

## Useful links:

On a new AWS account, on the [EC2 overview](https://ap-southeast-2.console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#)
page, you should see: 
* 1x Running Instance (nginx)
* 1x Volume
* 1x Load Balancer
* 1x Key pair
* 2x Security Groups (1 was already there)

There will also be 1x [Launch configuration](https://ap-southeast-2.console.aws.amazon.com/ec2/autoscaling/home?region=ap-southeast-2#LaunchConfigurations:) and 1x [Autoscaling group](https://ap-southeast-2.console.aws.amazon.com/ec2/autoscaling/home?region=ap-southeast-2#AutoScalingGroups:view=details).

To track all the resources, you can create a [Resource Group](https://resources.console.aws.amazon.com/r/group) - use the Application ID you set in the main.tf as a filter. 

## Tests

See the tests/README.md
