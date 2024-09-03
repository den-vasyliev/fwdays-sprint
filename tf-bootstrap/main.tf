terraform {
  required_version = ">= 1.7.0"

  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.3.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.1"
    }
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.4"
    }
  }
}

# ==========================================
# Construct KinD cluster
# ==========================================

resource "kind_cluster" "this" {
  name = "flux"
}

# ==========================================
# Initialise a Github project
# ==========================================

resource "github_repository" "this" {
  name        = var.github_repository
  description = var.github_repository
  visibility  = "private"
  auto_init   = true 

  # Enable vulnerability alerts
  vulnerability_alerts = true
}
resource "github_branch_protection" "main" {
  repository_id = github_repository.this.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["validate"]
  }

  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
  }
}

# ==========================================
# Bootstrap Flux
# ==========================================

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository.this]

  embedded_manifests = true
  path               = "clusters/kindcluster"
}
