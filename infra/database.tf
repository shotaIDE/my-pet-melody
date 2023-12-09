resource "google_firestore_database" "default" {
  project                 = google_project.default.project_id
  name                    = "(default)"
  location_id             = var.google_project_location
  type                    = "FIRESTORE_NATIVE"
  delete_protection_state = "DELETE_PROTECTION_ENABLED"
  deletion_policy         = "DELETE"
}

# Creates a ruleset of Firestore Security Rules from a local file.
resource "google_firebaserules_ruleset" "firestore" {
  provider = google-beta
  project  = google_project.default.project_id
  source {
    files {
      name    = "firestore.rules"
      content = file("../firestore.rules")
    }
  }

  # Wait for Firestore to be provisioned before creating this ruleset.
  depends_on = [
    google_firestore_database.default,
  ]
}

# Releases the ruleset for the Firestore instance.
resource "google_firebaserules_release" "firestore" {
  provider     = google-beta
  name         = "cloud.firestore" # must be cloud.firestore
  ruleset_name = google_firebaserules_ruleset.firestore.name
  project      = google_project.default.project_id

  # Wait for Firestore to be provisioned before releasing the ruleset.
  depends_on = [
    google_firestore_database.default,
  ]
}
