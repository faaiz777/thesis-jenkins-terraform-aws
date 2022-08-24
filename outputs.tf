 output "aws_ami_id" {
   value = data.aws_ami.latest-Amazon-linux-image.id
}

output "public_ip" {
  value  = aws_instance.myapp-server.public_ip
}

output "private_key_generated_SSH" {
  value     = aws_key_pair.ssh-key
  sensitive = true
}

output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}
