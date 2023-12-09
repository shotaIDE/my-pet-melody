provider "google" {
  project     = "colomney-my-pet-melody${var.google_project_id_suffix}"
  region      = var.google_project_location
  credentials = file("google-cloud-credentials.json")
}

resource "google_cloud_tasks_queue" "advanced_configuration" {
  name     = "colomney-my-pet-melody${var.google_project_id_suffix}-service"
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
