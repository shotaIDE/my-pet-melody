resource "google_iam_workload_identity_pool" "github" {
  provider                  = google-beta
  project                   = google_project.default.project_id
  workload_identity_pool_id = "github"
  display_name              = "GitHub"

  depends_on = [
    google_project_service.default,
  ]
}

resource "google_iam_workload_identity_pool_provider" "myprovider" {
  provider                           = google-beta
  project                            = google_project.default.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "my-pet-melody"
  display_name                       = "My Pet Melody"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "as_deploy_service_account" {
  service_account_id = "projects/${google_project.default.project_id}/serviceAccounts/deploy-functions-from-github@${google_project.default.project_id}.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/shotaIDE/my-pet-melody"
}
