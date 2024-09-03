# Weave AI

This is the fork of [Weave AI GitHub Repository](https://github.com/weave-ai/weave-ai)

Weave AI is a collection of Flux controllers and CLI that manage the
lifecycle of Large Language Models (LLMs) on Kubernetes.

**Weave AI CLI** aims to be the easiest way to onboard LLMs on Kubernetes,
and the **Weave AI controllers** manage the lifecycle of the LLMs, including
training, serving, and monitoring of the models on production Kubernetes
clusters.

## Getting Started with Weave AI

Here's a step-by-step guide to run your first LLM with Weave AI.

### Prerequisites

Please install Kubernetes v1.27+ and Flux v2.1.0+ before proceeding.
Minimum requirements of the Kubernetes cluster are 8 CPUs and 16GB of memory with 100GB of SSD storage.

### Step 1: Create a KIND Cluster and Install Flux

Set up a Kubernetes in Docker (KIND) cluster with terraform/opentofu command:

```sh {"id":"01J6WBMFSRWVXNW3ZA1MSXKEX5"}
cd tf-bootstrap
terraform init
terraform plan
terraform apply
```

Find more details in tf-bootstrap Readme.md file

### Step 3: Install Weave AI in Your Cluster

At this stage, you're ready to install Weave AI and its controller(s):

- clone new flux infrastructure repo
- add weave-ai in your flux infrastructure repo
- commit and push changes

```sh {"id":"01J6WBMFSRWVXNW3ZA1PDKNHMD"}
git clone https://github.com/$TF_VAR_github_org/fw-non-prod
cd fw-non-prod
cp -r ../weave-ai clusters/kind-cluster
git add .
git commit -am 'adding weave-ai'
git push
```

After installation, you can check flux log messages, indicating that the Weave AI controllers and the default model catalog are set up.

### Step 4: Listing Models

To view the available models in your cluster, use:

```sh {"id":"01J6WBMFSRWVXNW3ZA1Q2047EE"}
kubectl get ocirepositories.source.toolkit.fluxcd.io -A
```

This command lists all OCI models, which are initially in an `INACTIVE` state to conserve resources.

```sh {"id":"01J6WBMFSRWVXNW3ZA1QMSCNZ1"}
NAME                               VERSION           FAMILY  STATUS    CREATED
weave-ai/zephyr-7b-beta            v1.0.0-q5km-gguf          INACTIVE  1 minute ago
```

### Step 5: Create and run a model instance.

To activate and run a model, add LanguageModel and UI manifests to kustomisation.yaml. Commit and push your changes:

```sh {"id":"01J6WBMFSRWVXNW3ZA1RKPPK69"}
- LanguageModel.yaml
- Deployment-ui.yaml
```

This command activates the model and sets up a UI for interaction.

```sh {"id":"01J6WBMFSRWVXNW3ZA1VDJEB2R"}
kubectl get languagemodels.ai.contrib.fluxcd.io
kubectl get po
```

Follow the instructions for port forwarding to access the LLM and the UI.

To connect to your LLM:

```sh {"id":"01J6WBMFSRWVXNW3ZA1VMS0KMW"}
kubectl port-forward -n default svc/my-model 8000:8000
```

To connect to the UI:

```sh {"id":"01J6WBMFSRWVXNW3ZA1Y5H2G6H"}
kubectl port-forward -n default deploy/my-model-chat-app 8501:8501
```

Simply run the UI port-forward command.

```sh {"id":"01J6WBMFSRWVXNW3ZA1YEZ95K4"}
kubectl port-forward -n default deploy/my-model-chat-app 8501:8501
```

Then open your browser to `http://localhost:8501` to try the model via our quick chat app.

![Chat UI](https://github.com/weave-ai/weave-ai/assets/10666/ff6e624e-90d5-42d9-9197-245619b1c4fa)

### Delete the LM instance and cluster

Finally, to remove the LM instance and the associated UI, change the kustomisation.yaml. Commit and push your changes.

This deletes the specified language model instance from your cluster, also with the default chat UI if you've created one.

To cleanup the cluster use:

```sh {"id":"01J6WBMFSRWVXNW3ZA1ZRNNHVN"}
terraform destroy
```