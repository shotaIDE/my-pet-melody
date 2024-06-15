variable "import_firebase_apple_app_id" {
  type        = string
  description = "App ID for Firebase Apple app, such as 1:000000000000:ios:xxxxxxxxxxxxxxxxxxxxxx."
}

variable "import_firebase_android_app_id" {
  type        = string
  description = "App ID for Firebase Android app, such as 1:000000000000:android:xxxxxxxxxxxxxxxxxxxxxx."
}

variable "import_firestore_ruleset_name" {
  type        = string
  description = "Firestore rule set name."
}

variable "import_firebase_storage_ruleset_name" {
  type        = string
  description = "Firebase Storage rule set name."
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
  id = "projects/${local.google_project_id}/iosApps/${var.import_firebase_apple_app_id}"
  to = google_firebase_apple_app.default
}

import {
  id = "projects/${local.google_project_id}/androidApps/${var.import_firebase_android_app_id}"
  to = google_firebase_android_app.default
}

import {
  id = local.google_project_id
  to = google_identity_platform_config.auth
}

import {
  id = "projects/${local.google_project_id}/databases/(default)"
  to = google_firestore_database.default
}

import {
  id = "projects/${local.google_project_id}/rulesets/${var.import_firestore_ruleset_name}"
  to = google_firebaserules_ruleset.firestore
}

import {
  id = "projects/${local.google_project_id}/releases/cloud.firestore"
  to = google_firebaserules_release.firestore
}

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

import {
  id = local.google_project_id
  to = google_app_engine_application.default
}

# import {
#   id = "projects/${local.google_project_id}-deploy"
#   to = google_storage_bucket.deploy
# }

import {
  id = "projects/${local.google_project_id}/buckets/${local.google_project_id}.appspot.com"
  to = google_firebase_storage_bucket.default
}

import {
  id = "projects/${local.google_project_id}/rulesets/${var.import_firebase_storage_ruleset_name}"
  to = google_firebaserules_ruleset.storage
}

import {
  id = "projects/${local.google_project_id}/releases/firebase.storage/${local.google_project_id}.appspot.com"
  to = google_firebaserules_release.storage
}

import {
  id = "projects/${local.google_project_id}/locations/${var.google_project_location}/queues/${local.google_project_id}-service"
  to = google_cloud_tasks_queue.default
}
