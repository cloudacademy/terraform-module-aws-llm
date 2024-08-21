output "url" {
  value       = "http://${aws_instance.server.public_ip}:${var.port}/"
  description = "The URL of the llama.cpp server"
}

output "test_curl_command" {
  value       = <<EOF
curl --request POST \
    --url http://${aws_instance.server.public_ip}:${var.port}/completion \
    --header "Content-Type: application/json" \
    --data '{"prompt": "Why is the sky blue?", "n_predict": 128}'
EOF
  description = "A curl command to test the llama.cpp server API"
}
