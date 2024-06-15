variable "firebase_apple_app_id" {
  type        = string
  description = "App ID for Firebase Apple app, such as 1:000000000000:ios:xxxxxxxxxxxxxxxxxxxxxx."
}

variable "firebase_android_app_id" {
  type        = string
  description = "App ID for Firebase Android app, such as 1:000000000000:android:xxxxxxxxxxxxxxxxxxxxxx."
}

locals {
  google_project_id = "${var.google_project_id}${var.google_project_id_suffix}"
}

import {
  id = local.google_project_id
  to = google_project.default
}

import {
  id = "projects/${local.google_project_id}"
  to = google_firebase_project.default
}

import {
  id = "projects/${local.google_project_id}/iosApps/${var.firebase_apple_app_id}"
  to = google_firebase_apple_app.default
}

import {
  id = "projects/${local.google_project_id}/androidApps/${var.firebase_android_app_id}"
  to = google_firebase_android_app.default
}

import {
  id = local.google_project_id
  to = google_identity_platform_config.auth
}

# TODO: import to google_identity_platform_project_default_config.auth

import {
  id = "projects/${local.google_project_id}/databases/(default)"
  to = google_firestore_database.default
}

# TODO: import to google_firebaserules_ruleset.firestore

# TODO: import to google_firebaserules_release.firestore

