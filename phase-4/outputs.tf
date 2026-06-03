output "ec2_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}

output "s3_bucket_name" {
  description = "The name of our new S3 bucket"
  value       = aws_s3_bucket.app_storage.id
}