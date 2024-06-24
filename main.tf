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

resource "docker_image" "api_image" {
  name = "lsmcba/api:1.0"
}

resource "docker_container" "api_container" {
  name  = "api"
  image = docker_image.api_image.image_id
  ports {
    internal = 5000
    external = 5000
  }

  env = [
    "FLASK_APP=app.py",
    "FLASK_ENV=development"
  ]
}

resource "docker_image" "web_image" {
  name = "lsmcba/web:1.0"
}

resource "docker_container" "web_container" {
  name  = "web"
  image = docker_image.web_image.image_id
  ports {
    internal = 5173
    external = 5173
  }

  env = [
    "VITE_HOST=0.0.0.0",
    "VITE_PORT=5173"
  ]

  depends_on = [docker_container.api_container]
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
    host_path      = "/${path.module}/proyecto-avatares/prometheus.yml"
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
