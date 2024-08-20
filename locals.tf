locals {
  server_user_data = <<EOF
#!/bin/bash

set -x

{
echo --- install docker ---
dnf update -y
dnf install -y docker tmux jq
systemctl enable docker
systemctl start docker
newgrp
touch .docker-installed
} &

{
echo --- download model ---
mkdir models
curl -sL -o /models/model ${var.model_url}
touch .model-downloaded
} &

echo --- waiting for docker installation and model download ---
while [ ! -f .docker-installed ] || [ ! -f .model-downloaded ]; do
  sleep 5
done

echo --- start llama.cpp server ---
docker run -v /models:/models \
    -d \
    --restart unless-stopped \
    -p ${var.port}:8000 \
    ${var.llama_cpp_server_image} \
    -m /models/model \
    --port ${var.port} \
    --host 0.0.0.0 \
    -n 512 \
    -p "${var.system_prompt}"
EOF
}
