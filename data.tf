data "aws_ssm_parameter" "amazon_linux_2023" {
  name = var.ami_ssm_path
}
