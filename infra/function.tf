data "archive_file" "functions_src" {
  type        = "zip"
  source_dir  = "../function"
  output_path = "./function.zip"
}

resource "google_storage_bucket_object" "functions_src" {
  name   = "functions/src_${data.archive_file.functions_src.output_md5}.zip"
  bucket = google_storage_bucket.default.name
  source = data.archive_file.functions_src.output_path

  depends_on = [
    google_firebase_project.default,
  ]
}

resource "google_cloudfunctions_function" "detect" {
  name                         = "detect"
  runtime                      = "python310"
  source_archive_bucket        = google_storage_bucket.default.name
  source_archive_object        = google_storage_bucket_object.functions_src.name
  trigger_http                 = true
  available_memory_mb          = 2048
  timeout                      = 60
  entry_point                  = "detect"
  docker_registry              = "CONTAINER_REGISTRY"
  https_trigger_security_level = "SECURE_OPTIONAL"
  max_instances                = 1
  min_instances                = 0
}

resource "google_cloudfunctions_function" "submit" {
  name                         = "piece"
  runtime                      = "python310"
  source_archive_bucket        = google_storage_bucket.default.name
  source_archive_object        = google_storage_bucket_object.functions_src.name
  trigger_http                 = true
  available_memory_mb          = 1024
  timeout                      = 60
  entry_point                  = "piece"
  docker_registry              = "CONTAINER_REGISTRY"
  https_trigger_security_level = "SECURE_OPTIONAL"
  max_instances                = 1
  min_instances                = 0
}

resource "google_cloudfunctions_function" "piece" {
  name                         = "piece"
  runtime                      = "python310"
  source_archive_bucket        = google_storage_bucket.default.name
  source_archive_object        = google_storage_bucket_object.functions_src.name
  trigger_http                 = true
  available_memory_mb          = 1024
  timeout                      = 60
  entry_point                  = "piece"
  docker_registry              = "CONTAINER_REGISTRY"
  https_trigger_security_level = "SECURE_OPTIONAL"
  max_instances                = 1
  min_instances                = 0
}
