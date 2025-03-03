# Bootstrap Kuberentes, Flux and Weave AI Controllers

This repository contains two main directories: `tf-bootstrap`, `weave-ai` and initialisation script `codespace.bootstrap.sh`
The `tf-bootstrap` directory contains Terraform scripts that set up a Kubernetes in Docker (kind) cluster, a GitHub repository, and FluxCD.


### Install OpenTofu
```
curl -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method standalone
```

### Instrall K9S to manage the cluster
```
curl -sS https://webi.sh/k9s | sh
```

### Initialize Tofu
1. Navigate to the `tf-bootstrap` directory.
2. Initialize Tofu/Terraform with `tofu init`.
```
cd tf-bootstrap 
tofu init
```

### Create your personal GitHub token with proper permitions and set it from user input securely 
```
read -s TF_VAR_github_token
```

### Export GitHub organization, repository, and token as environment variables
```
export TF_VAR_github_org="<GITHUB_ACCOUNT>"
export TF_VAR_github_repository="<GITHUB_REPO>"
export TF_VAR_github_token
```

### Disable IPv6 in dockerd

```shell
sudo tee /etc/docker/daemon.json >/dev/null <<-EOF
{
  "ip6tables": false,
  "ipv6": false
}
EOF
sudo pkill dockerd && sudo pkill containerd
bash /usr/local/share/docker-init.sh
```

### Apply terrafrom configuration
This will create a kind cluster, a GitHub repository, and install FluxCD.

```
tofu apply
```

### Use configuration of newly deployed Kubernetes cluster

```shell
export KUBECONFIG=$(pwd)/.terraform/kubeconfig
```

> **_NOTE:_** You have to run this command in each new shell session.


### Create alias for k9s, kubectl and command-line autocompletion
```
alias kk="EDITOR='code --wait' k9s"
alias k=kubectl
source <(kubectl completion zsh)
```

### Check your <GITHUB_REPO> repo for flux setup

### Check your local Kubernetes cluster
```kk```

# Configure Weave-AI with GitOps

The `weave-ai` directory contains a collection of Flux controllers that manage the lifecycle of Large Language Models (LLMs) on Kubernetes.
This is the fork of [Weave AI GitHub Repository](https://github.com/weave-ai/weave-ai)

Weave AI is a collection of Flux controllers and CLI that manage the
lifecycle of Large Language Models (LLMs) on Kubernetes.

**Weave AI CLI** aims to be the easiest way to onboard LLMs on Kubernetes,
and the **Weave AI controllers** manage the lifecycle of the LLMs, including
training, serving, and monitoring of the models on production Kubernetes
clusters.

## Getting Started with Weave AI

Here's a step-by-step guide to run your first LLM with Weave AI.

Please install Kubernetes v1.27+ and Flux v2.1.0+ before proceeding.
Minimum requirements of the Kubernetes cluster are 8 CPUs and 16GB of memory with 100GB of SSD storage.

### Install Weave AI in Your Cluster

At this stage, you're ready to install Weave AI and its controller(s):

- clone new flux infrastructure repo
- add weave-ai in your flux infrastructure repo
- commit and push changes

```
GITHUB_TOKEN=$TF_VAR_github_token
git clone https://github.com/$TF_VAR_github_org/$TF_VAR_github_repository
cd $TF_VAR_github_repository
cp -r ../weave-ai clusters/kind
git add .
git commit -am 'adding weave-ai'
git push
```

After installation, you can check flux log messages, indicating that the Weave AI controllers and the default model catalog are set up.

### Listing Models

To view the available models in your cluster, use:

```
kubectl get ocirepositories.source.toolkit.fluxcd.io -A
```

This command lists all OCI models, which are initially in an `INACTIVE` state to conserve resources.

```
NAME                               VERSION           FAMILY  STATUS    CREATED
weave-ai/zephyr-7b-beta            v1.0.0-q5km-gguf          INACTIVE  1 minute ago
```

### Create and run a model instance.

To activate and run a model, add LanguageModel and UI manifests to kustomisation.yaml. 
Commit and push your changes:

```
- ./models
```

This command activates the model and sets up a UI for interaction.

```
kubectl get languagemodels.ai.contrib.fluxcd.io
kubectl get po
```

Follow the instructions for port forwarding to access the LLM and the UI.

To connect to your LLM:

```
kubectl port-forward -n default svc/my-model 8000:8000
```

To connect to the UI:

```
kubectl port-forward -n default deploy/my-model-chat-app 8501:8501
```

Simply run the UI port-forward command.

```
kubectl port-forward -n default deploy/my-model-chat-app 8501:8501
```

Then open your browser to `http://localhost:8501` to try the model via our quick chat app.

![Chat UI](https://github.com/weave-ai/weave-ai/assets/10666/ff6e624e-90d5-42d9-9197-245619b1c4fa)

### Delete the LM instance and cluster

Finally, to remove the LM instance and the associated UI, change the kustomisation.yaml. Commit and push your changes.

This deletes the specified language model instance from your cluster, also with the default chat UI if you've created one.

To cleanup the cluster use:

```
tofu destroy
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the terms of the MIT license.
