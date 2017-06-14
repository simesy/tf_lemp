# tf_lemp
Terraformed lemp server for Drupal purposes. You can use this to experiment with Terraform and AWS.

Before you begin you will need:

- Terraform installed
- An AWS account
- A SSH Public Key
- LEMP Stack PHP 7 on Debian; can be found here - https://aws.amazon.com/marketplace/pp/B01N0MCONW

Ready to start?

1. Create a new directory
2. Create a main.tf
3. Under main.tf paste the following:
```
#A module to personalise your terraformed experience.
module "YOUR_MODULE_NAME" {
    # This will pull down the Terraformed LEMP repo.
    source            = "github.com/simesy/tf_lemp"
    # Used to label resources.
    identifier        = "YOUR_TAG"
    # Used to tag resources.
    application_id    = "YOUR_ID"
    # Public key which will be deployed to the nginx servers.
    remote_key        = "YOUR_SSH_PUBLIC_KEY"
    # Whether to allow remote (SSH) access to the EC instances in the load balancer.
    remote_access     = "true"
    # A full http path to a repository containing a webroot and a playbook.
    app_repo          = "https://github.com/simesy/tf_lemp"
    # Path to the playbook file in the `app_repo` repository.
    app_playbook      = "nginx/playbook.yml"
}
```
4. In the terminal, navigate to your directory and run `terraform apply`