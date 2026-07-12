#!/bin/bash

# Verifier que le dossier sh-toolbox existe
if [ ! -d ./.sh-toolbox ]; then
    echo "ERREUR: le dossier sh-toolbox n'existe pas, veuillez le creer via init-toolbox.sh"
    exit 1
else
    arch=./.sh-toolbox/archives
    toolbox=./.sh-toolbox
    trace=false
    
    # Verifier que le fichier archives existe
    if [ ! -e "$arch" ]; then
        echo "ERREUR: le fichier archives n'est pas present dans sh-toolbox"
        exit 2
    else
        # Creer un fichier temporaire sans la premiere ligne
        tail -n +2 "$arch" > "$arch.tmp"
        
        # Parcourir chaque ligne du fichier archives
        while read -r line; do
            filename=$(echo "$line" | cut -d ':' -f 1)
            DAT=$(echo "$line" | cut -d ':' -f 2)
            key=$(echo "$line" | cut -d ':' -f 3)
            
            # Verifier que l'archive existe physiquement
            if [ -e "$toolbox/$filename" ]; then
                echo "Archive: $filename"
                echo "Date: $DAT"
                if [ -z "$key" ]; then
                    echo "Cle: inconnue"
                else
                    echo "Cle: $key"
                fi
            else
                echo "ERREUR: $filename mentionne dans archives mais absent du dossier"
                rm -f "$arch.tmp"
                exit 3
            fi
            echo "________________"
        done < "$arch.tmp"
        
        rm -f "$arch.tmp"
        
        # Verifier les archives presentes mais non mentionnees
        for i in "$toolbox"/*; do
            nom=$(basename "$i")
            
            # Ignorer le fichier archives lui-meme
            if [ "$nom" = "archives" ]; then
                continue
            fi
            
            # Verifier si l'archive est mentionnee dans le fichier archives
            if ! grep -q "^$nom:" "$arch"; then
                echo "AVERTISSEMENT: $nom est present dans sh-toolbox mais n'est pas mentionne dans archives"
                trace=true
            fi
        done
        
        # Retourner le code approprie
        if [ "$trace" = true ]; then
            exit 3
        else 
            exit 0
        fi 
    fi
fi
