# Install Homebrew

curl -sS https://webi.sh/kind | sh
curl -sS https://webi.sh/k9s | sh
curl -s https://fluxcd.io/install.sh | bash
curl -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method standalone 
curl -sS https://webi.sh/ollama | sh
curl -sS https://webi.sh/brew | sh
brew install htop --ignore-dependencies

# Initialize Tofu
cd tf-bootstrap
tofu init

# Read GitHub token from user input
read -s TF_VAR_github_token

# Export GitHub organization, repository, and token as environment variables
export TF_VAR_github_org="<GITHUB_ACCOUNT>"
export TF_VAR_github_repository="fw-non-prod"
export TF_VAR_github_token="<GITHUB_TOKEN>"

# Apply Tofu configuration
tofu apply

# Create alias for kubectl and command-line autocompletion
alias k=kubectl
source <(kubectl completion zsh)

# Enable Flux command-line autocompletion for Zsh
. <(flux completion zsh)

# Watch for changes to Kustomizations
flux get kustomizations --watch

# Get all resources that are not ready
flux get all -A --status-selector ready=false