# Configure GCP Provider
provider "google" {
  project = "taskflow-multicloud"
  region  = "us-central1"
}

# Create Cloud Run Service
resource "google_cloud_run_service" "taskflow_gcp" {
  name     = "taskflow-gcp"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "ammaralikhan00/taskflow-api:52"
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  # Allow unauthenticated access
  ingress = "INGRESS_TRAFFIC_ALL"
}

# Output URL
output "service_url" {
  value = google_cloud_run_service.taskflow_gcp.status[0].url
}
