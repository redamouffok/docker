#!/bin/bash
set -e

# ==============================
# Script installation Docker CE
# ==============================

echo ">>> Mise à jour du système"
sudo apt-get update -y
sudo apt-get upgrade -y

echo ">>> Suppression d'anciennes versions (si existantes)"
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

echo ">>> Installation des dépendances nécessaires"
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

echo ">>> Ajout de la clé GPG officielle de Docker"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo ">>> Ajout du dépôt Docker officiel"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo ">>> Mise à jour des dépôts"
sudo apt-get update -y

echo ">>> Installation de Docker et ses composants"
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo ">>> Activation et démarrage du service Docker"
sudo systemctl enable docker
sudo systemctl start docker

echo ">>> Ajout de l'utilisateur actuel dans le groupe docker"
sudo usermod -aG docker $USER

echo ">>> Vérification de l'installation"
docker --version
docker compose version
docker buildx version

echo ">>> Installation terminée avec succès ✅"
echo "⚠️ Déconnecte-toi/reconnecte-toi ou exécute 'newgrp docker' pour appliquer le changement de groupe."

newgrp docker 
