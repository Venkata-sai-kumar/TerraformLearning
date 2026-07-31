output "id" {
  description = "The ID of the Elastic IP."
  value       = aws_eip.main.id
}

output "public_ip" {
  description = "The public IP address of the Elastic IP."
  value       = aws_eip.main.public_ip
}
