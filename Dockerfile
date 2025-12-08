# Utiliser une image de base légère pour servir les fichiers statiques (par exemple Nginx)
FROM nginx:alpine

# Copier les fichiers HTML dans le répertoire par défaut de Nginx
COPY . /usr/share/nginx/html