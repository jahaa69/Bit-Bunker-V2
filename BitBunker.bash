#!/bin/bash

# Identifiant distant + emplacement dossier de sauvegarde 
ip_to="your ip"
user_to="YOUR NAME SERVER"
password_to="YOUR PASSWORD"
path_to="/home/${user_to}/Bit-Bunker/"

# Check si l'argument a été renseigné
if [ -z "$1" ]; then
    echo "Veuillez fournir le chemin de la sauvegarde à faire en argument !"
    exit 1
fi

# Check si le chemin renseigné est valide
if [ ! -d "$1" ]; then
    echo "Le chemin que vous avez fourni n'existe pas ou n'est pas un dossier."
    exit 1
fi

# Nom du fichier de backup
backup_filename="$(basename "$1").tar.gz"
# Création du fichier
tar -zcf "$backup_filename" "$1"

# Upload du fichier sur le NAS distant
sshpass -p "${password_to}" scp "$backup_filename" "${user_to}@${ip_to}:${path_to}"

# Supprime le fichier de backup local
rm "$backup_filename"