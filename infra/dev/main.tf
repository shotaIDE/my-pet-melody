variable "google_billing_account_id" {
  type        = string
  description = "Billing account ID to be associated with GCP project."
}

variable "application_id_suffix" {
  type        = string
  description = "Application ID suffix for iOS and Android."
}

variable "ios_app_team_id" {
  type        = string
  description = "Team ID for iOS app."
}

variable "firebase_android_app_sha1_hashes" {
  type        = list(string)
  description = "Allowed SHA-1 hashes for Firebase Android app."
}
variable "import_firebase_apple_app_id" {
  type        = string
  description = "App ID for Firebase Apple app, such as 1:000000000000:ios:xxxxxxxxxxxxxxxxxxxxxx."
}

variable "import_firebase_android_app_id" {
  type        = string
  description = "App ID for Firebase Android app, such as 1:000000000000:android:xxxxxxxxxxxxxxxxxxxxxx."
}

variable "import_firestore_ruleset_name" {
  type        = string
  description = "Firestore rule set name."
}

variable "import_firebase_storage_ruleset_name" {
  type        = string
  description = "Firebase Storage rule set name."
}

module "shared" {
  source                                     = "../shared"
  google_project_id_suffix                   = "-dev"
  google_project_display_name_suffix         = "-Dev"
  google_billing_account_id                  = var.google_billing_account_id
  application_id_suffix                      = "dev"
  ios_app_team_id                            = var.ios_app_team_id
  firebase_android_app_sha1_hashes           = var.firebase_android_app_sha1_hashes
  firebase_admin_key_file_name               = "firebase-serviceAccountKey_dev.json"
  google_application_credentials             = "cloud-tasks-serviceAccountKey_dev.json"
  revenue_cat_public_apple_api_key           = ""
  revenue_cat_public_google_api_key          = ""
  feature_eliminate_waiting_time_to_generate = "false"
  waiting_time_seconds_to_generate           = "60"
  import_firebase_apple_app_id               = var.import_firebase_apple_app_id
  import_firebase_android_app_id             = var.import_firebase_android_app_id
  import_firestore_ruleset_name              = var.import_firestore_ruleset_name
  import_firebase_storage_ruleset_name       = var.import_firebase_storage_ruleset_name
}
