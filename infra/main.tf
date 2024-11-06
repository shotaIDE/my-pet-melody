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

variable "ios_app_team_id" {
  type        = string
  description = "Team ID for iOS app."
}

variable "firebase_android_app_sha1_hashes" {
  type        = list(string)
  description = "Allowed SHA-1 hashes for Firebase Android app."
}

locals {
  google_project_id_base           = "colomney-my-pet-melody"
  google_project_display_name_base = "MyPetMelody"
  application_id_base              = "ide.shota.colomney.MyPetMelody"
}

terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "6.10.0"
    }
  }
}

provider "google-beta" {
  user_project_override = true
}

provider "google-beta" {
  alias                 = "no_user_project_override"
  user_project_override = false
}

resource "google_project" "default" {
  provider = google-beta.no_user_project_override

  name            = "${local.google_project_display_name_base}${var.google_project_display_name_suffix}"
  project_id      = "${local.google_project_id_base}${var.google_project_id_suffix}"
  billing_account = var.google_billing_account_id

  labels = {}
}

resource "google_project_service" "default" {
  provider = google-beta.no_user_project_override
  project  = google_project.default.project_id
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudtasks.googleapis.com",
    "firebase.googleapis.com",
    "firebaserules.googleapis.com",
    "firebasestorage.googleapis.com",
    "firestore.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "identitytoolkit.googleapis.com",
    "serviceusage.googleapis.com",
    "sts.googleapis.com",
  ])
  service = each.key

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
  bundle_id    = "${local.application_id_base}${var.application_id_suffix}"
  team_id      = var.ios_app_team_id

  depends_on = [
    google_firebase_project.default,
  ]
}

resource "google_firebase_android_app" "default" {
  provider = google-beta

  project      = google_project.default.project_id
  display_name = "Android"
  package_name = "${local.application_id_base}${var.application_id_suffix}"
  sha1_hashes  = var.firebase_android_app_sha1_hashes

  depends_on = [
    google_firebase_project.default,
  ]
}
