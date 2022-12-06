
resource "aws_key_pair" "helm_key" {
  key_name = "helm_key"
  public_key = file("C:/Users/PArgade/.ssh/id_rsa.pub")
}

output "key_pair_details" {
  value = aws_key_pair.helm_key
}
