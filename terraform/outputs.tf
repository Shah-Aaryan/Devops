output "jenkins_server_public_ip" {
  description = "Public IP of Jenkins server – open :8080 in your browser"
  value       = aws_instance.jenkins_server.public_ip
}

output "k8s_server_public_ip" {
  description = "Public IP of K8s/Monitoring server"
  value       = aws_instance.k8s_server.public_ip
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = "http://${aws_instance.k8s_server.public_ip}:3000"
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = "http://${aws_instance.k8s_server.public_ip}:9090"
}

output "client_url" {
  description = "PlaybackSpace client URL (NodePort)"
  value       = "http://${aws_instance.k8s_server.public_ip}:31000"
}

output "backend_url" {
  description = "PlaybackSpace backend API URL (NodePort)"
  value       = "http://${aws_instance.k8s_server.public_ip}:31100/api/v1/"
}
