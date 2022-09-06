# resource "tls_private_key" "tls_key" {
#   algorithm = "RSA"
#   rsa_bits = 4096
# }

# resource "aws_key_pair" "helm_key" {
#   public_key = tls_private_key.tls_key.public_key_openssh
#   key_name = "mykey"

#   provisioner "local-exec" {
#     command = "echo '${tls_private_key.tls_key.private_key_pem}' > C:/Pratik's_Workspace/Terraform/Helm_Instance/mykey.pem"
#   }
# }


# output "tls_key_details" {
#   value = tls_private_key.tls_key.private_key_pem
#   sensitive = true
# }

# output "key_details" {
#   value = aws_key_pair.helm_key
# }



resource "aws_key_pair" "helm_key" {
  key_name = "helm_key"
  public_key = file("C:/Users/PArgade/.ssh/id_rsa.pub")
}

output "key_pair_details" {
  value = aws_key_pair.helm_key
}