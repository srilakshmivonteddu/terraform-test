provider "aws" {
  version = "~> 3.0"
  region  = "ap-south-1"
}
locals {
  common_tags = {
    CostGroup1 = "jmsth"
    CostGroup2 = "ec2-servers"
  }
}
resource "aws_instance" "dev" {
  ami           = "ami-0cda377a1b884a1bc"
  instance_type = "t2.micro"
  tags          = local.common_tags
}
resource "aws_instance" "stagging" {
  ami           = "ami-0cda377a1b884a1bc"
  instance_type = "t2.nano"
  tags          = local.common_tags
}
