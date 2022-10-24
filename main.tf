data "google_project" "project" {
  project_id = var.project_id
  depends_on = [
    time_sleep.wait_project_init
  ]
}

module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "14.0.0"

  project_id                  = data.google_project.project.id
  activate_apis               = var.active_apis
  disable_services_on_destroy = false
  disable_dependent_services  = false
}

resource "null_resource" "enable_apis" {
  provisioner "local-exec" {
    command = "gcloud services enable compute.googleapis.com serviceusage.googleapis.com cloudresourcemanager.googleapis.com --project ${var.project_id}"
  }
}

resource "time_sleep" "wait_project_init" {
  create_duration = "60s"

  depends_on = [null_resource.enable_apis]
}