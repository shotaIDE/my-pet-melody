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

import {
  id = "${local.google_project_id}/${var.google_project_location}/detect"
  to = google_cloudfunctions_function.detect
}

import {
  id = "${local.google_project_id}/${var.google_project_location}/detect roles/cloudfunctions.invoker allUsers"
  to = google_cloudfunctions_function_iam_member.detect_invoker
}

import {
  id = "${local.google_project_id}/${var.google_project_location}/submit"
  to = google_cloudfunctions_function.submit
}

import {
  id = "${local.google_project_id}/${var.google_project_location}/submit roles/cloudfunctions.invoker allUsers"
  to = google_cloudfunctions_function_iam_member.submit_invoker
}

import {
  id = "${local.google_project_id}/${var.google_project_location}/piece"
  to = google_cloudfunctions_function.piece
}

import {
  id = "${local.google_project_id}/${var.google_project_location}/piece roles/cloudfunctions.invoker allUsers"
  to = google_cloudfunctions_function_iam_member.piece_invoker
}

import {
  id = "projects/${local.google_project_id}/serviceAccounts/cloud-tasks@${local.google_project_id}.iam.gserviceaccount.com"
  to = google_service_account.cloud_tasks
}

import {
  id = "${local.google_project_id} roles/cloudtasks.enqueuer serviceAccount:cloud-tasks@${local.google_project_id}.iam.gserviceaccount.com"
  to = google_project_iam_member.cloud_tasks_enqueuer
}
