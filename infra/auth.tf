# Creates an Identity Platform config.
# Also enables Firebase Authentication with Identity Platform in the project if not.
resource "google_identity_platform_config" "auth" {
  provider = google-beta
  project  = google_project.default.project_id

  # For example, you can configure to auto-delete Anonymous users.
  autodelete_anonymous_users = true

  # Wait for identitytoolkit.googleapis.com to be enabled before initializing Authentication.
  depends_on = [
    google_project_service.default,
  ]
}

# Adds more configurations, like for the email/password sign-in provider.
resource "google_identity_platform_project_default_config" "auth" {
  provider = google-beta
  project  = google_project.default.project_id
  sign_in {
    allow_duplicate_emails = false

    anonymous {
      enabled = true
    }
  }

  # Wait for Authentication to be initialized before enabling email/password.
  depends_on = [
    google_identity_platform_config.auth
  ]
}
