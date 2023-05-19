# -------------------------------------------
# Docs : https://docs.aws.amazon.com/directoryservice/latest/admin-guide/gsg_create_vpc.html (Dashboard)
#        https://thecloudbootcamp.com/pt/blog/aws/criando-uma-instancia-ec2-utilizando-o-terraform/
#        https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
#        https://www.youtube.com/watch?v=KJYJj32PUbw
# -------------------------------------------

# Internet VPC
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenacy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    enable_classiclink = false

    tags = {
        Name = "main-vpc"
    }
}

# Subnets
resource "aws_subnet" "vpc-public-1" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block =  "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = var.aval_zone
    tags = {
        Name = "subnet_1"
    }
}