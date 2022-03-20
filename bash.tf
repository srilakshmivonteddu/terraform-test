provider "aws" {
  region     = "ap-south-1"
}
resource "aws_instance" "server1" {
  ami  = "ami-04893cdb768d0f9ee"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.keypair.key_name}"
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
     tags = {
       Name = "terraform-test"
   }
 }
resource "aws_key_pair" "keypair" {
  key_name   = "rama999"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+5LKdDl3+JN8Xsg5Wj7q6Ur89/oJ2Lqk5jHxD9fE9GV9wlLuQmPbnjVVfDteoa9c1hEr0OmhmdBBTOKKzBhsqtk97ZOhZLHupY2/ncmMQqSnmFrr6TISVkh/l89m1MK1mUKrv3yeUjZwe8FgKft/I1R9VZew/+WCRTpcjX2pffmEuOUlopv3vfvqgVXRkdmieKc4GqPEUMHDZjhK2A8ZBR53Tz9TT70UeH7ZRPpw2Onn5GvJpIFJQWUSmOz+hpUNmdYhDWw/Ju6kYVpnsBo1hAyWE93rZbnVd222MLQJDE/XTw71lq0RKy4xmuOeNyjng+LlbKg1JkvW6pcTTawJJ ec2-user@ip-172-31-40-155.ap-south-1.compute.internal"
}
resource "aws_eip" "myeip" {
  instance = "${aws_instance.server1.id}"
  vpc      = true
}
resource "aws_default_vpc" "default" {
   tags = {
        Name = "Default VPC"
  }
}
resource "aws_security_group" "allow_ports" {
  name        = "allow_ports"
  description = "Allow inbound traffic"
  vpc_id      = "${aws_default_vpc.default.id}"
  ingress {
     description = "http from VPC"
     from_port        = 80
     to_port          = 80
     protocol         = "tcp"
     cidr_blocks      = ["0.0.0.0/0"]
    }
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
 ingress {
    description      = "tomcat port from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
     Name = "allow_ports"
}
}
