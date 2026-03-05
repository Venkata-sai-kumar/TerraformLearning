output "id" {
  description = "The ID of the Internet Gateway."
  value       = aws_route_table.main.id
}

output "arn" {
  description = "The ARN of the Internet Gateway."
  value       = aws_route_table.main.arn
}
