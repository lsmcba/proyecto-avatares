provider "aws" {
  region                      = "us-east-1"
  access_key                  = "clave_secreta"
  secret_key                  = "clave_secreta"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    ecs      = "http://localhost:4566"
  }
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "backend_image" {
  name = "lsmcba/backend-avatares:1.0"
}

resource "docker_container" "backend_container" {
  name  = "backend-avatares"
  image = docker_image.backend_image.image_id
  ports {
    internal = 5000
    external = 5000
  }

  env = [
    "FLASK_APP=app.py",
    "FLASK_ENV=development"
  ]
}

resource "docker_image" "frontend_image" {
  name = "lsmcba/frontend-avatares:1.0"
}

resource "docker_container" "frontend_container" {
  name  = "frontend-avatares"
  image = docker_image.frontend_image.image_id
  ports {
    internal = 5173
    external = 5173
  }

  env = [
    "VITE_HOST=0.0.0.0",
    "VITE_PORT=5173"
  ]

  depends_on = [docker_container.backend_container]
}

resource "docker_image" "prometheus_image" {
  name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus_container" {
  name  = "prometheus"
  image = docker_image.prometheus_image.image_id
  ports {
    internal = 9090
    external = 9090
  }

  volumes {
    host_path      = "${path.module}/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }
}

resource "docker_image" "grafana_image" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana_container" {
  name  = "grafana"
  image = docker_image.grafana_image.image_id
  ports {
    internal = 3000
    external = 3000
  }
}

