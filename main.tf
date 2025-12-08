## main.tf

# --- 1. Configuration du Fournisseur (Provider) ---
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Utilise la connexion Docker par défaut (via socket).
# Assurez-vous que Docker Desktop est en cours d'exécution.
provider "docker" {}



# --- 2. Construction de l'Image Docker ---
resource "docker_image" "web_app_image" {
  # Remplacez 'votre_utilisateur' par votre nom d'utilisateur Docker Hub ou un nom local.
  name         = "danielguy/demo-devops2:latest"
  keep_locally = true 
  
  # Ce bloc déclenche le build à partir de votre Dockerfile.
  build {
    context    = "."
    dockerfile = "Dockerfile"
    tag      = ["danielguy/demo-devops2:latest"]
  }
}



# --- 3. Lancement du Conteneur Web ---
resource "docker_container" "web_app_container" {
  name  = "site-web-container"
  # Le conteneur redémarre toujours
  restart = "always" 
  
  # Utilise l'image que nous venons de construire.
  image = docker_image.web_app_image.name 
  
  # Configuration des ports :
  # Le port interne 80 (votre serveur web) est exposé sur le port hôte 8080.
  ports {
    internal = 80      # Le port écouté par Nginx/Apache dans le conteneur
    external = 8080    # Le port que vous utilisez sur votre machine (http://localhost:8080)
  }
}



# --- 4. Export des Sorties ---
output "site_url" {
  description = "URL locale du site web"
  # Affiche l'URL du site une fois le déploiement réussi.
  value       = "http://localhost:${docker_container.web_app_container.ports[0].external}"
}

output "container_id" {
  description = "ID du conteneur lancé"
  value       = docker_container.web_app_container.id
}