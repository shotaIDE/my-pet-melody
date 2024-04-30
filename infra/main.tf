variable "google_project_id_suffix" {
  type        = string
  description = "ID suffix for GCP project."
}

variable "google_project_display_name_suffix" {
  type        = string
  description = "Display name suffix for GCP project."
}

variable "google_billing_account_id" {
  type        = string
  description = "Billing account ID to be associated with GCP project."
}

variable "google_project_location" {
  type        = string
  description = "Location for GCP project."
}

variable "application_id_suffix" {
  type        = string
  description = "Application ID suffix for iOS and Android."
}

terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.27.0"
    }
  }
}

# Configures the provider to use the resource block's specified project for quota checks.
provider "google-beta" {
  user_project_override = true
}

# Configures the provider to not use the resource block's specified project for quota checks.
# This provider should only be used during project creation and initializing services.
provider "google-beta" {
  alias                 = "no_user_project_override"
  user_project_override = false
}

resource "google_project" "default" {
  provider = google-beta.no_user_project_override

  name            = "MyPetMelody${var.google_project_display_name_suffix}"
  project_id      = "colomney-my-pet-melody${var.google_project_id_suffix}"
  billing_account = var.google_billing_account_id

  labels = {
    "firebase" = "enabled"
  }
}

resource "google_project_service" "default" {
  provider = google-beta.no_user_project_override
  project  = google_project.default.project_id
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudtasks.googleapis.com",
    "firebase.googleapis.com",
    "firebaserules.googleapis.com",
    "firebasestorage.googleapis.com",
    "firestore.googleapis.com",
    "serviceusage.googleapis.com",
    "identitytoolkit.googleapis.com",
  ])
  service = each.key

  # Don't disable the service if the resource block is removed by accident.
  disable_on_destroy = false
}

resource "google_firebase_project" "default" {
  provider = google-beta
  project  = google_project.default.project_id

  depends_on = [
    google_project_service.default
  ]
}

resource "google_firebase_apple_app" "default" {
  provider = google-beta

  project      = google_project.default.project_id
  display_name = "iOS"
  bundle_id    = "ide.shota.colomney.MyPetMelody${var.application_id_suffix}"
  team_id      = "4UGYN353AH"

  depends_on = [
    google_firebase_project.default,
  ]
}

resource "google_firebase_android_app" "default" {
  provider = google-beta

  project      = google_project.default.project_id
  display_name = "Android"
  package_name = "ide.shota.colomney.MyPetMelody${var.application_id_suffix}"

  depends_on = [
    google_firebase_project.default,
  ]
}
