variable "firebase_apple_app_id" {
  type        = string
  description = "App ID for Firebase Apple app, such as 1:000000000000:ios:xxxxxxxxxxxxxxxxxxxxxx."
}

variable "firebase_android_app_id" {
  type        = string
  description = "App ID for Firebase Android app, such as 1:000000000000:android:xxxxxxxxxxxxxxxxxxxxxx."
}

import {
  id = "${var.google_project_id}${var.google_project_id_suffix}"
  to = google_project.default
}

import {
  id = "projects/${var.google_project_id}${var.google_project_id_suffix}"
  to = google_firebase_project.default
}

import {
  id = "projects/${var.google_project_id}${var.google_project_id_suffix}/iosApps/${var.firebase_apple_app_id}"
  to = google_firebase_apple_app.default
}

import {
  id = "projects/${var.google_project_id}${var.google_project_id_suffix}/androidApps/${var.firebase_android_app_id}"
  to = google_firebase_android_app.default
}
