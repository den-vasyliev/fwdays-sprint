#!/bin/bash

# Install OpenTofu
curl -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method standalone 

# Instrall K9S to manage the cluster
curl -sS https://webi.sh/k9s | sh

# Initialize Tofu
cd tf-bootstrap
tofu init

# Prompt the user to enter the GitHub organization
read -p "Enter your GitHub organization: " TF_VAR_github_org

# Prompt the user to enter the GitHub repository
read -p "Enter your GitHub repository: " TF_VAR_github_repository

# Prompt the user to enter the GitHub token securely
read -s -p "Enter your GitHub token: " TF_VAR_github_token
echo

# Export GitHub organization, repository, and token as environment variables
export TF_VAR_github_org="$TF_VAR_github_org"
export TF_VAR_github_repository="$TF_VAR_github_repository"
export TF_VAR_github_token="$TF_VAR_github_token"

# Optionally, you can print the variables to verify (token is hidden)
echo "GitHub Organization: $TF_VAR_github_org"
echo "GitHub Repository: $TF_VAR_github_repository"
echo "GitHub Token: [HIDDEN]"

# Apply terrafrom configuration
tofu apply

# Create alias for k9s, kubectl and command-line autocompletion
#alias kk="EDITOR='code --wait' k9s"
#alias k=kubectl
#source <(kubectl completion zsh)

# Check your <GITHUB_REPO> repo for flux setup
# Check your local Kubernetes cluster
