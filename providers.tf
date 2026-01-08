terraform {
  required_version = ">= 1.10.5"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "18.6.1"
    }
  }
}