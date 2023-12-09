resource "google_firestore_database" "default" {
  project                 = google_project.default.project_id
  name                    = "(default)"
  location_id             = var.google_project_location
  type                    = "FIRESTORE_NATIVE"
  delete_protection_state = "DELETE_PROTECTION_ENABLED"
  deletion_policy         = "DELETE"
}

resource "google_app_engine_application" "default" {
  provider    = google-beta
  project     = google_project.default.project_id
  location_id = var.google_project_location

  depends_on = [
    google_firestore_database.default
  ]
}

# Makes the default Storage bucket accessible for Firebase SDKs, authentication, and Firebase Security Rules.
resource "google_firebase_storage_bucket" "default-bucket" {
  provider  = google-beta
  project   = google_project.default.project_id
  bucket_id = google_app_engine_application.default.default_bucket
}

# Creates a ruleset of Cloud Storage Security Rules from a local file.
resource "google_firebaserules_ruleset" "storage" {
  provider = google-beta
  project  = google_project.default.project_id
  source {
    files {
      name    = "storage.rules"
      content = file("../storage.rules")
    }
  }

  # Wait for the default Storage bucket to be provisioned before creating this ruleset.
  depends_on = [
    google_firebase_project.default,
  ]
}

# Releases the ruleset to the default Storage bucket.
resource "google_firebaserules_release" "default-bucket" {
  provider     = google-beta
  name         = "firebase.storage/${google_app_engine_application.default.default_bucket}"
  ruleset_name = "projects/${google_project.default.project_id}/rulesets/${google_firebaserules_ruleset.storage.name}"
  project      = google_project.default.project_id
}
