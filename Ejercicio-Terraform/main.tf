provider "aws" {
  region                      = "us-east-1"
  access_key                  = "clave_secreta"
  secret_key                  = "clave_secreta"
  #s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    lambda   = "http://localhost:4566"
    ecs      = "http://localhost:4566"
  }
}

provider "docker" {}

resource "docker_image" "backend_image" {
  name = "lsmcba/backend-avatares:1.0"
}

resource "docker_container" "backend_container" {
  name  = "backend-avatares"
  image = lsmcba/backend-avatares
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
  name = "lsmcba/backend-avatares:1.0"
}

resource "docker_container" "frontend_container" {
  name  = "frontend-avatares"
  image = lsmcba/frontend-avatares
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
