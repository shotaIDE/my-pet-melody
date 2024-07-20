variable "firebase_admin_key_file_name" {
  type        = string
  default     = "firebase-serviceAccountKey_dev.json"
  description = "Service account key JSON file name for Firebase admin."
}

variable "google_application_credentials" {
  type        = string
  default     = "cloud-tasks-serviceAccountKey_dev.json"
  description = "Service account key JSON file name for Cloud tasks."
}

variable "revenue_cat_public_apple_api_key" {
  type        = string
  default     = ""
  description = "Public Apple API key for RevenueCat."
}

variable "revenue_cat_public_google_api_key" {
  type        = string
  default     = ""
  description = "Public Google API key for RevenueCat."
}

variable "feature_eliminate_waiting_time_to_generate" {
  type        = string
  default     = "true"
  description = "Is enabled the feature to eliminate waiting time to generate pieces depends on Premium Plan."
}

variable "waiting_time_seconds_to_generate" {
  type        = string
  default     = "300"
  description = "Waiting time seconds to generate pieces."
}

locals {
  runtime         = "python312"
  docker_registry = "ARTIFACT_REGISTRY"
  timeout         = "20m"
  environment_variables = {
    "FIREBASE_ADMIN_KEY_FILE_NAME"               = var.firebase_admin_key_file_name
    "FIREBASE_STORAGE_BUCKET_NAME"               = google_app_engine_application.default.default_bucket
    "FIREBASE_FUNCTIONS_API_ORIGIN"              = "https://${var.google_project_location}-${google_project.default.project_id}.cloudfunctions.net"
    "GOOGLE_APPLICATION_CREDENTIALS"             = var.google_application_credentials
    "GOOGLE_CLOUD_PROJECT_ID"                    = google_project.default.project_id
    "GOOGLE_CLOUD_TASKS_LOCATION"                = var.google_project_location
    "GOOGLE_CLOUD_TASKS_QUEUE_ID"                = google_cloud_tasks_queue.default.name
    "REVENUE_CAT_PUBLIC_APPLE_API_KEY"           = var.revenue_cat_public_apple_api_key
    "REVENUE_CAT_PUBLIC_GOOGLE_API_KEY"          = var.revenue_cat_public_google_api_key
    "FEATURE_ELIMINATE_WAITING_TIME_TO_GENERATE" = var.feature_eliminate_waiting_time_to_generate
    "WAITING_TIME_SECONDS_TO_GENERATE"           = var.waiting_time_seconds_to_generate
  }
}

data "archive_file" "functions_src" {
  type        = "zip"
  source_dir  = "../function"
  output_path = "./function.zip"
}

resource "google_storage_bucket_object" "functions_src" {
  name   = "functions/src_${data.archive_file.functions_src.output_md5}.zip"
  bucket = google_storage_bucket.deploy.name
  source = data.archive_file.functions_src.output_path

  depends_on = [
    google_firebase_project.default,
  ]
}

resource "google_cloudfunctions_function" "detect" {
  project               = google_project.default.project_id
  name                  = "detect"
  runtime               = local.runtime
  region                = var.google_project_location
  source_archive_bucket = google_storage_bucket.deploy.name
  source_archive_object = google_storage_bucket_object.functions_src.name
  trigger_http          = true
  available_memory_mb   = 2048
  timeout               = 60
  entry_point           = "detect"
  docker_registry       = local.docker_registry
  max_instances         = 1
  min_instances         = 0
  environment_variables = local.environment_variables

  timeouts {
    create = local.timeout
    update = local.timeout
  }
}

resource "google_cloudfunctions_function_iam_member" "detect_invoker" {
  project        = google_cloudfunctions_function.detect.project
  region         = google_cloudfunctions_function.detect.region
  cloud_function = google_cloudfunctions_function.detect.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_cloudfunctions_function" "submit" {
  project               = google_project.default.project_id
  name                  = "submit"
  runtime               = local.runtime
  region                = var.google_project_location
  source_archive_bucket = google_storage_bucket.deploy.name
  source_archive_object = google_storage_bucket_object.functions_src.name
  trigger_http          = true
  available_memory_mb   = 1024
  timeout               = 60
  entry_point           = "submit"
  docker_registry       = local.docker_registry
  max_instances         = 1
  min_instances         = 0
  environment_variables = local.environment_variables

  timeouts {
    create = local.timeout
    update = local.timeout
  }
}

resource "google_cloudfunctions_function_iam_member" "submit_invoker" {
  project        = google_cloudfunctions_function.submit.project
  region         = google_cloudfunctions_function.submit.region
  cloud_function = google_cloudfunctions_function.submit.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_cloudfunctions_function" "piece" {
  project               = google_project.default.project_id
  name                  = "piece"
  runtime               = local.runtime
  region                = var.google_project_location
  source_archive_bucket = google_storage_bucket.deploy.name
  source_archive_object = google_storage_bucket_object.functions_src.name
  trigger_http          = true
  available_memory_mb   = 1024
  timeout               = 60
  entry_point           = "piece"
  docker_registry       = local.docker_registry
  max_instances         = 1
  min_instances         = 0
  environment_variables = local.environment_variables

  timeouts {
    create = local.timeout
    update = local.timeout
  }
}

resource "google_cloudfunctions_function_iam_member" "piece_invoker" {
  project        = google_cloudfunctions_function.piece.project
  region         = google_cloudfunctions_function.piece.region
  cloud_function = google_cloudfunctions_function.piece.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
