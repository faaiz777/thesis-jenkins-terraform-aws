output "s3bucket" {
    value = aws_s3_bucket.terraform_state
}

output "dynamodb_table" {
    value = aws_dynamodb_table.terraform_locks
}