#!/bin/bash

# Chemins des fichiers et dossiers
toolpath=".sh-toolbox"
toolarchive=".sh-toolbox/archives"

# Verifier si le dossier existe deja
if [ -d "$toolpath" ]; then
    # Compter le nombre de fichiers dans le dossier
    nb_fichiers=$(ls -A "$toolpath" | wc -l)
    
    if [ "$nb_fichiers" -eq 0 ]; then
        # Dossier vide, creer le fichier archives
        echo "0" > "$toolarchive"
        if [ ! -f "$toolarchive" ]; then
            echo "ERREUR : Impossible de creer le fichier archives"
            exit 1
        fi
        echo "Le fichier archives a ete cree avec succes"
        exit 0
        
    elif [ "$nb_fichiers" -eq 1 ]; then
        # Un seul fichier, verifier que c'est bien archives
        if [ -f "$toolarchive" ]; then
            echo "Le dossier $toolpath existe deja et contient le fichier archives"
            exit 0
        else
            echo "ERREUR : Le dossier $toolpath contient un fichier different de archives"
            exit 2
        fi
        
    else
        # Plusieurs fichiers ou dossiers
        echo "ERREUR : Le dossier .sh-toolbox contient plusieurs fichiers et/ou dossiers"
        exit 2
    fi
    
else
    # Le dossier n'existe pas, le creer
    mkdir "$toolpath"
    if [ ! -d "$toolpath" ]; then
        echo "ERREUR : Impossible de creer le dossier $toolpath"
        exit 1
    fi
    echo "Le dossier $toolpath a ete cree avec succes"
    
    # Creer le fichier archives avec la valeur 0
    echo "0" > "$toolarchive"
    if [ ! -f "$toolarchive" ]; then
        echo "ERREUR : Impossible de creer le fichier archives"
        exit 1
    fi
    echo "Le fichier archives a ete cree avec succes"
    exit 0
    
fi
