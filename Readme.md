# Terraform Bootstrap and Weave AI Controllers

This repository contains two main directories: `tf-bootstrap` and `weave-ai`.

## tf-bootstrap

The `tf-bootstrap` directory contains Terraform scripts that set up a Kubernetes in Docker (kind) cluster, a GitHub repository, and FluxCD.

To use the scripts in this directory:

1. Navigate to the `tf-bootstrap` directory.
2. Initialize Terraform with `terraform init`.
3. Apply the Terraform configuration with `terraform apply`.

This will create a kind cluster, a GitHub repository, and install FluxCD.

## weave-ai

The `weave-ai` directory contains a collection of Flux controllers that manage the lifecycle of Large Language Models (LLMs) on Kubernetes.

To use the controllers in this directory:

1. Navigate to the `weave-ai` directory.
2. Follow the instruction in Readme file.

This will deploy the controller to your Kubernetes cluster.

## Prerequisites

- Docker
- kind
- Terraform
- kubectl
- FluxCD

Please ensure that these are installed and properly configured on your machine before using the scripts and controllers in this repository.

# Infacost
Install Infracost following the https://www.infracost.io/docs/#quick-start
Register on https://www.infracost.io/

Add your API key to the environment:
infracost configure set api_key <KEY>

Add a repository secret called INFRACOST_API_KEY with your API key. https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-encrypted-secrets-for-a-repository

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the terms of the MIT license.