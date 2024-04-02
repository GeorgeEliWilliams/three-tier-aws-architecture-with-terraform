# Terraform AWS Three-Tier Architecture

## Project Description
This project aims to provision a three-tier architecture on AWS using Terraform. The architecture consists of a Virtual Private Cloud (VPC), an Application Load Balancer (ALB) for routing traffic to the web tier, Auto Scaling Groups (ASGs) for the web and application tiers, and a Relational Database Service (RDS) instance for the database tier.

## Prerequistes
Before getting started, ensure you have the following prerequisites:

1. AWS account with appropriate permissions to create resources
2. Terraform installed on your local machine
3. AWS CLI installed and configured with access credentials

## Project Structure
The project structure is organized as follows:

1. alb.tf: Defines the Application Load Balancer resources.
2. vpc.tf: Defines the Virtual Private Cloud (VPC) and related networking resources.
3. asg.tf: Defines the Auto Scaling Groups (ASGs) for the web and application tiers.
4. backend.tf: Configures the Terraform backend for storing state remotely.
5. outputs.tf: Specifies the output variables to be displayed after Terraform applies changes.
6. rds.tf: Defines the Relational Database Service (RDS) instance.
7. terraform.tfvars: Contains variable definitions. (Ensure you fill this with your values.)
8. variables.tf: Declares input variables used throughout the configuration.
9. versions.tf: Specifies the required Terraform and provider versions.

## Configuration

1. AWS Credentials
open the terminal on your system and type aws configure . it will ask for your Acess key ID and secret key id.
```
aws configure
```
![environment configuration](https://github.com/GeorgeEliWilliams/three-tier-aws-architecture-with-terraform/assets/103576454/46f6aed4-03ea-4ddb-afee-eed902f62ba6)
2. Terraform backend
* store state files on remote location
so let's first create an s3 bucket to save the state file on a remote location.
* state-locking so that we can keep tfstate file consistent
go to the dynamoDB service dashboard and click on create table. Give the partition key as 'LockID'.
```
terraform {
  backend "s3" {
    bucket         = "george-terraform-backend"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-s3-backend-table"
  }
}
```
3. Input variables
Update terraform.tfvars with the desired values for input variables
```
# Generic variables
region = "us-east-1"

# VPC variables
vpc_name             = "demo-vpc"
vpc_cidr             = "10.0.0.0/16"
vpc_azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_private_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
vpc_database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
vpc_tags             = { "created-by" = "terraform" }

# ASG variables
asg_sg_name                             = "demo-asg-sg"
asg_sg_description                      = "demo-asg-sg"
asg_sg_tags                             = { "Name" = "demo-asg-sg", "created-by" = "terraform" }
asg_name                                = "demo-asg"
asg_min_size                            = 0
asg_max_size                            = 2
asg_desired_capacity                    = 2
asg_wait_for_capacity_timeout           = 0
asg_health_check_type                   = "EC2"
asg_launch_template_name                = "demo-lt"
asg_launch_template_description         = "demo-lt"
asg_update_default_version              = true
asg_image_id                            = "ami-026b57f3c383c2eec"
asg_instance_type                       = "t3.micro"
asg_ebs_optimized                       = true
asg_enable_monitoring                   = true
asg_create_iam_instance_profile         = true
asg_iam_role_name                       = "demo-asg-iam-role"
asg_iam_role_path                       = "/ec2/"
asg_iam_role_description                = "demo-asg-iam-role"
asg_iam_role_tags                       = { "Name" = "demo-asg-iam-role", "created-by" = "terraform" }
asg_block_device_mappings_volume_size_0 = 20
asg_block_device_mappings_volume_size_1 = 30
asg_instance_tags                       = { "Name" = "demo-asg-instance", "created-by" = "terraform" }
asg_volume_tags                         = { "Name" = "demo-asg-volume", "created-by" = "terraform" }
asg_tags                                = { "Name" = "demo-asg", "created-by" = "terraform" }

# ALB variables
alb_sg_name                    = "demo-alb-sg"
alb_sg_ingress_cidr_blocks     = ["0.0.0.0/0"]
alb_sg_description             = "demo-alb-sg"
alb_sg_tags                    = { "Name" = "demo-alb-sg", "created-by" = "terraform" }
alb_name                       = "demo-alb"
alb_http_tcp_listeners_port    = 80
alb_target_group_name          = "demo-alb-tg"
alb_target_groups_backend_port = 80
alb_tags                       = { "Name" = "demo-alb", "created-by" = "terraform" }

# RDS variables
rds_sg_name                               = "demo-rds-sg"
rds_sg_description                        = "demo-rds-sg"
rds_sg_tags                               = { "Name" = "demo-rds-sg", "created-by" = "terraform" }
rds_identifier                            = "demo-rds"
rds_mysql_engine                          = "mysql"
rds_engine_version                        = "8.0.27"
rds_family                                = "mysql8.0" # DB parameter group
rds_major_engine_version                  = "8.0"      # DB option group
rds_instance_class                        = "db.t2.small"
rds_allocated_storage                     = 20
rds_max_allocated_storage                 = 100
rds_db_name                               = "demo_mysql"
rds_username                              = "demo_user"
rds_port                                  = 3306
rds_multi_az                              = false
rds_maintenance_window                    = "Mon:00:00-Mon:03:00"
rds_backup_window                         = "03:00-06:00"
rds_enabled_cloudwatch_logs_exports       = ["general"]
rds_create_cloudwatch_log_group           = true
rds_backup_retention_period               = 0
rds_skip_final_snapshot                   = true
rds_deletion_protection                   = false
rds_performance_insights_enabled          = false
rds_performance_insights_retention_period = 7
rds_create_monitoring_role                = true
rds_monitoring_interval                   = 60
rds_tags                                  = { "Name" = "demo-rds", "created-by" = "terraform" }
rds_db_instance_tags                      = { "Name" = "demo-rds-instance", "created-by" = "terraform" }
rds_db_option_group_tags                  = { "Name" = "demo-rds-option-group", "created-by" = "terraform" }
rds_db_parameter_group_tags               = { "Name" = "demo-rds-db-parameter-group", "created-by" = "terraform" }
rds_db_subnet_group_tags                  = { "Name" = "demo-rds-db-subnet-group", "created-by" = "terraform" }
```

4. Define the configuration files for the rquired resources
5.Terraform Initialization
Open the terminal and navigate to the directory where you have created these configuration files.
After navigating to the directory where your configuration files are located in your IDE's terminal, you can run the following command to initialize Terraform and prepare it for use with AWS:
```
terraform init
```
Running `terraform init` will install the necessary plugins and modules required for connecting to AWS and managing the infrastructure.

## Deployment
To deploy the three-tier architecture on AWS, follow these steps:

1. Plan Deployment: Generate an execution plan to preview changes.
```
terraform plan
```
2. Apply Changes: Apply the Terraform configuration.
```
terraform apply
```

## Output
View outputs after deployment for important information such as ALB URL and database endpoint.

## Cleanup
To avoid incurring unnecessary costs, you can destroy the infrastructure provisioned by Terraform after you're finished using it.
```
terraform destroy
```
