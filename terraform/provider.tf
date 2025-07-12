terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.41.0"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }

}

provider "google" {
  project = var.project
  region  = var.region
}

provider "ansible" {
  # Configuration options
}

