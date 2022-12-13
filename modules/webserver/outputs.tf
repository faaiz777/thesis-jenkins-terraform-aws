output "public_ip" {
  value  = aws_instance.myapp-server
}

# output "private_key" {
#   value     = tls_private_key.example
#   sensitive = true
# }

 output "aws_ami_id" {
   value = data.aws_ami.latest-Amazon-linux-image
}