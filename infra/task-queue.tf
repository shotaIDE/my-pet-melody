provider "google" {
  project     = google_project.default.project_id
  region      = var.google_project_location
  credentials = file("google-cloud-credentials.json")
}

resource "google_cloud_tasks_queue" "advanced_configuration" {
  name     = "${google_project.default.project_id}-service"
  location = var.google_project_location

  rate_limits {
    max_concurrent_dispatches = 1
  }

  retry_config {
    max_attempts = 2
  }

  depends_on = [
    google_project_service.default
  ]
}
