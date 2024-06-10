# resource "google_service_account" "firebase_admin" {
#   project      = google_project.default.project_id
#   account_id   = "firebase-adminsdk-zlkov"
#   display_name = "firebase-adminsdk"
#   description  = "Firebase Admin SDK Service Agent"
# }

# resource "google_project_iam_member" "firebase_admin_service_agent" {
#   project = google_project.default.project_id
#   role    = "roles/firebase.sdkAdminServiceAgent"
#   member  = "serviceAccount:${google_service_account.firebase_admin.email}"
# }

# resource "google_project_iam_member" "firebase_admin_auth" {
#   project = google_project.default.project_id
#   role    = "roles/firebaseauth.admin"
#   member  = "serviceAccount:${google_service_account.firebase_admin.email}"
# }

# resource "google_project_iam_member" "firebase_admin_" {
#   project = google_project.default.project_id
#   role    = "roles/firebaseauth.admin"
#   member  = "serviceAccount:${google_service_account.firebase_admin.email}"
# }

resource "google_service_account" "cloud_tasks" {
  project      = google_project.default.project_id
  account_id   = "cloud-tasks"
  display_name = "Cloud Tasks"
}

resource "google_project_iam_member" "cloud_tasks_enqueuer" {
  project = google_project.default.project_id
  role    = "roles/cloudtasks.enqueuer"
  member  = "serviceAccount:${google_service_account.cloud_tasks.email}"
}
