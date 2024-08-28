variable "llama_cpp_server_image" {
  description = "The Docker image for the llama.cpp server"
  type        = string
  default     = "public.ecr.aws/cloudacademy-labs/cloudacademy/labs/llama.cpp-server"
}

variable "system_prompt" {
  description = "The system prompt for the llama.cpp server"
  type        = string
  default     = "<|system|>You are a helpful assistant.<|end|>\n"
}

variable "model_url" {
  description = "The URL of the model to download"
  type        = string
  default     = "https://assets.labs.cloudacademy.com/customizing-large-language-models-using-ollama/Phi-3-mini-4k-instruct-q4.gguf"
}

variable "instance_type" {
  description = "The instance type for the server"
  type        = string
  default     = "m5.xlarge"
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
  default     = "llm-api"
}

variable "port" {
  description = "The port for the llama.cpp server"
  type        = number
  default     = 8000
}

variable "key_pair_name" {
  description = "Key pair name"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "cidr_block" {
  description = "CIDR range to restrict access to the server"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ami_ssm_path" {
  description = "The SSM parameter path for the AMI ID"
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

