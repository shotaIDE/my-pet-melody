resource "google_service_account" "firebase_admin" {
  project      = google_project.default.project_id
  account_id   = "firebase-adminsdk-zlkov"
  display_name = "firebase-adminsdk"
  description  = "Firebase Admin SDK Service Agent"
}

resource "google_service_account" "cloud_tasks" {
  project      = google_project.default.project_id
  account_id   = "cloud-tasks"
  display_name = "Cloud Tasks"
}
