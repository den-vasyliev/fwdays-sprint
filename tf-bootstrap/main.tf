terraform {
  required_version = ">= 1.9.0"

  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.5"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.1"
    }
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.8"
    }
  }
}

# ==========================================
# Construct KinD cluster
# ==========================================

resource "kind_cluster" "this" {
  name = "flux-ops"
}

# ==========================================
# Initialise a Github project
# ==========================================

resource "github_repository" "this" {
  name        = var.github_repository
  description = var.github_repository
  visibility  = "private"
  auto_init   = true # This is extremely important as flux_bootstrap_git will not work without a repository that has been initialised

  # Enable vulnerability alerts
  vulnerability_alerts = true
}


# ==========================================
# Bootstrap KinD cluster
# ==========================================

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository.this]

  embedded_manifests = true
  path               = "clusters/my-cluster"
}