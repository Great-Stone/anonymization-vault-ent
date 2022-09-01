output "server_ip" {
  value = aws_eip.server.public_ip
}

output "client_ips" {
  value = aws_eip.client[*].public_ip
}