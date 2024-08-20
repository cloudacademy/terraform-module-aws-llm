# AWS LLM Terraform Module

This module deploys a [lllama.cpp](https://github.com/ggerganov/llama.cpp) server on an AWS instance and serves the [Phi3](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf) model via a REST API. See the [LLaMA.cpp HTTP Server](https://github.com/ggerganov/llama.cpp/blob/master/examples/server/README.md) readme for more information.

Once deployed the `url` output will be able to accept and respond to web requests:

```bash
curl --request POST \
    --url <URL-OUTPUT> \
    --header "Content-Type: application/json" \
    --data '{"prompt": "In one sentence, why is the sky blue?", "n_predict": 128}'
```

See the [variables.tf](variables.tf) file for configurable options, and the [outputs.tf](outputs.tf) file for the available outputs.

## Testing locally

Create a `vars.tfvars` file with the following content, replacing the values with valid ones from your AWS account:

```hcl
key_pair_name = "your-key-pair-name"
security_group_id = "your-security-group-id"
```

Then run the following commands:

```bash
terraform init
terraform plan
terraform apply -var-file=vars.tfvars -auto-approve
```

Notes:

- By default, the server is publicly accessible on port 8000, you can change this by modifying the `variables.tf` file and changing the CIDR block range.
- The default model appears to work equally well on x86_64 and arm64 architectures, with the latter being cheaper.
- In theory, any GGUF model suppoted by llama.cpp should work, testing recommended when using other models.

## Usage

To use in a lab Terraform configuration, add the following code to your template:

```hcl
module "aws_llm" {
    source = "github.com/cloudacademy/terraform-module-aws-llm"

    key_pair_name       = "your-key-pair-name"
    security_group_id   = "your-security-group-id"
}
```

Example with the [AWS data module](https://github.com/cloudacademy/terraform-module-aws-data):

```hcl
module "aws_data" {
  source = "github.com/cloudacademy/terraform-module-aws-data?ref=v1.0.1"
}

module "aws_llm" {
    source = "github.com/cloudacademy/terraform-module-aws-llm"

    key_pair_name       = module.aws_data.aws.key_pair_name
    security_group_id   = module.aws_data.default_vpc.security_group.id
}
```