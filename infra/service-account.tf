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
