# Install OpenTofu
curl -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method standalone 

# Instrall K9S to manage the cluster
curl -sS https://webi.sh/k9s | sh

# Initialize Tofu
cd tf-bootstrap
tofu init

# Read GitHub token from user input securely 
read -s TF_VAR_github_token

# Export GitHub organization, repository, and token as environment variables
export TF_VAR_github_org="<GITHUB_ACCOUNT>"
export TF_VAR_github_repository="<GITHUB_REPO>"
export TF_VAR_github_token="<GITHUB_TOKEN>"

# Apply terrafrom configuration
tofu apply

# Create alias for k9s, kubectl and command-line autocompletion
alias kk="EDITOR='code --wait' k9s"
alias k=kubectl
source <(kubectl completion zsh)

# Check your <GITHUB_REPO> repo for flux setup
# Check your local Kubernetes cluster
kk

