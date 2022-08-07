data "google_project" "project" {
  project_id = var.project_id
}

module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "13.0.0"

  project_id    = data.google_project.project.id
  activate_apis = var.active_apis
}

