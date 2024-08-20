resource "aws_iam_role" "server" {
  name = var.instance_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]
}

resource "aws_iam_instance_profile" "server" {
  name = var.instance_name
  role = aws_iam_role.server.name
}

resource "aws_instance" "server" {
  ami                    = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [var.security_group_id]
  user_data              = base64encode(local.server_user_data)
  iam_instance_profile   = aws_iam_instance_profile.server.name

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = var.instance_name
  }

  provisioner "local-exec" {
    # wait until the /health endpoint is available
    command = "until curl -s http://${self.public_ip}:${var.port}/health; do sleep 5; done"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = var.security_group_id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "api" {
  security_group_id = var.security_group_id
  ip_protocol       = "tcp"
  from_port         = var.port
  to_port           = var.port
  cidr_ipv4         = var.cidr_block
}
