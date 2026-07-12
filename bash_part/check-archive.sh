#!/bin/bash

# Verifier que le dossier sh-toolbox existe
if [ ! -d ./.sh-toolbox ]; then
    echo "ERREUR: le dossier sh-toolbox n'existe pas, veuillez le creer via init-toolbox.sh"
    exit 1
else
    arch=./.sh-toolbox/archives
    toolbox=./.sh-toolbox
    
    # Verifier que le fichier archives existe
    if [ ! -e "$arch" ]; then
        echo "ERREUR: le fichier archives n'existe pas"
        exit 2
    else
        echo "Liste des archives disponibles a decompresser"
        echo ""
        
        # Lister toutes les archives disponibles
        disp=1
        for i in "$toolbox"/*.tar.gz; do
            if [ ! -e "$i" ]; then
                continue
            fi
            name=$(basename "$i")
            echo "[$disp] $name"
            echo "$i" >> "$toolbox/list$$"
            disp=$((disp + 1))
        done
        
        total=$((disp - 1))
        
        if [ "$total" -eq 0 ]; then
            echo "ERREUR: aucune archive disponible"
            exit 2
        fi
        
        # Demander a l'utilisateur de choisir une archive
        echo ""
        read -p "Selectionnez le fichier que vous souhaitez decompresser (1-$total): " selected
        
        if [[ "$selected" =~ ^[0-9]+$ && "$selected" -le "$total" && "$selected" -gt 0 ]]; then
            fileselect=$(head -n "$selected" "$toolbox/list$$" | tail -n 1)
            rm -f "$toolbox/list$$"
        else
            echo "ERREUR: veuillez selectionner un numero valide (1-$total)"
            rm -f "$toolbox/list$$"
            exit 3
        fi
        
        # Creer un dossier temporaire et decompresser l'archive
        filepath="./.sh-toolbox/temp$$"
        mkdir -p "$filepath"
        
        echo "Decompression en cours..."
        tar -xzf "$fileselect" -C "$filepath"
        
        if [ "$?" -ne 0 ]; then
            echo "ERREUR: decompression echouee"
            rm -rf "$filepath"
            exit 3
        fi
        
        echo "Archive decompresse avec succes"
        echo ""
        
        # Verifier que le fichier de logs existe
        logsearch="$filepath/var/log"
        logfile="$logsearch/auth.log"
        
        if [ ! -f "$logfile" ]; then
            echo "ERREUR: fichier auth.log manquant"
            rm -rf "$filepath"
            exit 4
        fi
        
        # Chercher la derniere connexion de l'utilisateur admin
        DAT=$(grep "Accepted.*admin" "$logfile" | tail -1 | awk '{printf $1 " " $2 " " $3}')
        
        if [ -z "$DAT" ]; then
            echo "ERREUR: aucune connexion admin trouvee dans les logs"
            rm -rf "$filepath"
            exit 4
        fi
        
        echo "Derniere connexion de l'admin: $DAT"
        echo ""
        
        # Verifier que le dossier data existe
        if [ ! -d "$filepath/data" ]; then
            echo "ERREUR: dossier de donnees de l'archive est vide"
            rm -rf "$filepath"
            exit 5
        fi
        
        
        DATS=$(date -d "$DAT" +%s)
        
        echo "Fichiers modifies apres la connexion admin"
        echo ""
        
        # Creer un fichier temporaire pour stocker les fichiers suspects
        suspects="$toolbox/suspects$$"
        > "$suspects"
        
        # Parcourir les fichiers de data/
        for i in $filepath/data/*; do
            if [ -f "$i" ]; then
                # Recuperer la date de modification du fichier
                DIRDAT=$(date -r "$i" +%s)
                
                # Comparer avec la date de connexion admin
                if [ "$DIRDAT" -gt "$DATS" ]; then
                    impacted=$(basename "$i")
                    
                    # Recuperer la taille du fichier
                    taille=$(wc -c < "$i")
                    echo "  - $impacted (taille: $taille octets)"
                    
                    # Sauvegarder le nom et la taille dans le fichier suspects
                    echo "$impacted:$taille" >> "$suspects"
                fi
            fi
        done
        
        echo ""
        
        # Verifier si des fichiers suspects ont ete trouves
        if [ -s "$suspects" ]; then
            echo "Recherche de versions saines"
            echo ""
            
            # Parcourir chaque fichier suspect
            while IFS=':' read -r nom taille; do
                echo "Fichier suspect: $nom ($taille octets)"
                
                # Parcourir toutes les archives disponibles
                for archive in "$toolbox"/*.tar.gz; do
                    if [ ! -e "$archive" ]; then
                        continue
                    fi
                    
                    # Ne pas chercher dans l'archive actuellement analysee
                    if [ "$archive" = "$fileselect" ]; then
                        continue
                    fi
                    
                    archive_nom=$(basename "$archive")
                    
                    # Lister le contenu de l'archive et chercher le fichier
                    tar -tzf "$archive" 2>/dev/null | grep "data/$nom$" > /dev/null
                    
                    # Si le fichier est trouve dans l'archive
                    if [ "$?" -eq 0 ]; then
                        echo "  Version potentiellement saine dans: $archive_nom"
                    fi
                done
                
                echo ""
            done < "$suspects"
        fi
        
        # Nettoyer les fichiers temporaires
        rm -f "$suspects"
        rm -rf "$filepath"
        
        exit 0
    fi
fi
