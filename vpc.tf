module "vpc" {

        # Import the module from Github
        # It's probably better to fork or clone this repo if you intend to use in production
        # so any future changes dont mess up your existing infrastructure.
        source = "github.com/hopkinsju/terraform-aws-vpc"
        access_key = "${var.access_key}"
        secret_key = "${var.secret_key}"
    }