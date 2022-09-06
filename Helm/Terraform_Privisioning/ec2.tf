provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECREATE_KEY"
  region = "ap-south-1"
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

# resource "aws_security_group" "helm_sg" {
#     vpc_id = default.vpc_id
#   ingress {
#       cidr_blocks = [ "0.0.0.0/0" ]
#       from_port = 22
#       to_port = 22
#       protocol = "tcp"
#   }

#   ingress {
#       cidr_blocks = [ "0.0.0.0/0" ]
#       from_port = 0
#       to_port = 0
#       protocol = "tcp"
#   }
#   egress {
#       cidr_blocks = [ "0.0.0.0/0" ]
#       from_port = 0
#       to_port = 0
#       protocol = "tcp"
#   }

# }

resource "aws_instance" "helm" {
  ami = data.aws_ami.ubuntu.id
  key_name = aws_key_pair.helm_key.key_name
  #security_groups = [aws_security_group.helm_sg.id]
  instance_type = "t2.small"
  connection {
    type = "ssh"
    private_key = file("C:/Users/PArgade/.ssh/id_rsa")
    host = self.public_ip
    user = "ubuntu" 
     }

  provisioner "remote-exec" {
    inline = [
      ########### Install Docker ############
      "sudo apt update",
      "sudo apt install docker.io -y",
      ########### Install Kind ###############
      "curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.15.0/kind-linux-amd64",
      "chmod +x ./kind",
      "sudo mv ./kind /usr/local/bin/kind",
      ########### Install Kubectl ############
      "curl -LO 'https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl'",
      "curl -LO 'https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256'",
      "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",
      ############ Install Helm ##############
      "curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3",
      "chmod 700 get_helm.sh",
      "./get_helm.sh",
      ############# Change Hostname ##############
      "sudo hostnamectl set-hostname helm_practice",
      "sudo -i",
      ############ Create Kind cluster #######

      "sudo kind create cluster -n practice"

    ]
  }

}




