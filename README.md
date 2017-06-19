# LEMP Server Terraform module

Terraform'd LEMP server, auto-scaling out of the box, with Drupal in mind. It's a work in progress, however
you can use this to experiment with Terraform and AWS by adding it as a module to a new terraform configuration.

**Warning**: following instructions below might result in being billed by AWS.

## What is created

* An Elastic Load Balancer
* An auto-scaling group, which deploys
* nginx server(s), with optional SSH access
* Tagged consistently in AWS for billing
* (todo) Aurora or RDS database

## What is not created

The idea is to spin up the nginx boxes with enough smarts to then hand-off to an
Ansible provisioner. If you use the default settings, a [simple playbook](https://github.com/simesy/tf_lemp/blob/master/nginx/playbook.yml) will run. Use `app_repo` to point at a different repository, which will
get cloned to `/var/www`.

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
