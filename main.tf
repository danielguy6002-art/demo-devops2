terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Définition d'une variable (Bonne pratique à montrer)
variable "container_name" {
  description = "Nom du conteneur pour le site web"
  type        = string
  default     = "site_web_etudiant_devops"
}

# Image Docker
resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

# Conteneur
resource "docker_container" "site_web" {
  image = docker_image.nginx.image_id
  name  = var.container_name

  ports {
    internal = 80
    external = 8080
  }
}