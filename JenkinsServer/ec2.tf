terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  access_key = var.access_key
  secret_key = var.secreate_key
  region = var.region
  
}

############# Ec2 with Kind , Docker , Kubectl , Helm ###########
data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

output "test" {
  value = data.aws_ami.ubuntu
}


resource "aws_instance" "helm" {
  ami = data.aws_ami.ubuntu.id
  key_name = aws_key_pair.helm_key.key_name
  #security_groups = [aws_security_group.helm_sg.id]
  instance_type = var.instance_type
  connection {
    type = "ssh"
    private_key = file("C:/Users/PArgade/.ssh/id_rsa")
    host = self.public_ip
    user = "ubuntu" 
     }
provisioner "remote-exec" {
  inline = [
    #file("helm.sh")
    file("jenkins.sh")
    #file("docker.sh")
  ]
}

}
