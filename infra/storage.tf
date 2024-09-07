resource "google_app_engine_application" "default" {
  provider    = google-beta
  project     = google_project.default.project_id
  location_id = var.google_project_location

  depends_on = [
    google_firestore_database.default
  ]
}

resource "google_storage_bucket" "deploy" {
  name                        = "${google_project.default.project_id}-deploy"
  provider                    = google-beta
  project                     = google_project.default.project_id
  default_event_based_hold    = false
  enable_object_retention     = false
  location                    = var.google_project_location
  uniform_bucket_level_access = false
  requester_pays              = false

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age                                     = 1
      days_since_custom_time                  = 0
      days_since_noncurrent_time              = 0
      matches_prefix                          = ["userTemporaryMedia/"]
      num_newer_versions                      = 0
      send_days_since_custom_time_if_zero     = false
      send_days_since_noncurrent_time_if_zero = false
      send_num_newer_versions_if_zero         = false
      with_state                              = "ANY"
    }
  }

  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  depends_on = [
    google_firebase_project.default,
  ]
}

resource "google_firebase_storage_bucket" "default" {
  provider  = google-beta
  project   = google_project.default.project_id
  bucket_id = google_app_engine_application.default.default_bucket

  depends_on = [
    google_app_engine_application.default,
  ]
}

resource "google_firebaserules_ruleset" "storage" {
  provider = google-beta
  project  = google_project.default.project_id
  source {
    files {
      name    = "storage.rules"
      content = file("../storage.rules")
    }
  }

  depends_on = [
    google_firebase_project.default,
  ]
}

resource "google_firebaserules_release" "storage" {
  provider     = google-beta
  name         = "firebase.storage/${google_app_engine_application.default.default_bucket}"
  ruleset_name = "projects/${google_project.default.project_id}/rulesets/${google_firebaserules_ruleset.storage.name}"
  project      = google_project.default.project_id
}
