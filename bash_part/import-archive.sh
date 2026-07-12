#!/bin/bash

# Gestion de l'option -f pour forcer l'ecrasement
force=false
if [ "$1" = "-f" ]; then
    force=true
    shift
fi

# Si plusieurs fichiers sont passes en parametre, les traiter un par un
if [ "$#" -gt 1 ]; then
    for file in "$@"; do
        if [ "$force" = true ]; then
            "$0" -f "$file"
        else
            "$0" "$file"
        fi
    done
    exit 0
fi

file="$1"
filename=$(basename "$file")

# Verifier qu'un seul fichier est passe en parametre
if [ "$#" -ne 1 ]; then
    echo "vous n'avez pas passe de fichier ou vous avez passe plus de un fichier"
    exit 1
fi

# Verifier que le dossier sh-toolbox existe
if [ ! -d ./.sh-toolbox ]; then
    echo "le dossier sh-toolbox n'existe pas veuillez le creer via init-toolbox"
    exit 1
else
    # Verifier que le fichier archives existe
    if [ -e ./.sh-toolbox/archives ]; then
        arch=./.sh-toolbox/archives
        valarch=$(head -n 1 "$arch")
        
        # Verifier que le fichier source existe
        if [ -f "$file" ]; then
            
            # Verifier si l'archive n'existe pas deja dans sh-toolbox
            if [ ! -e ./.sh-toolbox/"$filename" ]; then
                
                # Copier le fichier dans sh-toolbox
                cp "$file" ./.sh-toolbox/
                if [ ! -e ./.sh-toolbox/"$filename" ]; then
                    echo "copie du fichier impossible"
                    exit 3
                fi
                
                # Generer la date actuelle
                DAT=$(date +"%Y%m%d-%H%M%S")
                
                # Incrementer le compteur dans archives
                valarch=$((valarch+1))
                
                tail -n +2 "$arch" > "$arch.tmp"
                echo "$valarch" > "$arch"
                cat "$arch.tmp" >> "$arch"
                rm -f "$arch.tmp"
                ret=$?
                
                if [ "$ret" -ne 0 ]; then
                    echo "probleme dans la mise a jour du fichier archives de sh-toolbox"
                    exit 4
                fi
                
                # Ajouter la nouvelle archive au fichier archives
                echo "$filename:$DAT:" >> "$arch"
                ret=$?
                
                if [ "$ret" -ne 0 ]; then
                    echo "probleme dans la mise a jour du fichier archives de sh-toolbox"
                    exit 4
                else
                    echo "fichier copie avec succes dans sh-toolbox"
                    exit 0
                fi
            else
                # Le fichier existe deja, gerer l'ecrasement
                if [ "$force" = true ]; then
                    resp="O"
                else
                    echo "fichier deja existant voulez vous l'ecraser ? (O/N)"
                    read -r resp
                fi
                
                if [ "$resp" = "N" ]; then
                    echo "copie annulee"
                    exit 0
                elif [ "$resp" = "O" ]; then
                    # Ecraser le fichier
                    cp "$file" ./.sh-toolbox/
                    if [ ! -e ./.sh-toolbox/"$filename" ]; then
                        echo "copie du fichier impossible"
                        exit 3
                    fi
                    
                    # Generer la nouvelle date
                    DAT=$(date +"%Y%m%d-%H%M%S")
                    
                    # Supprimer l'ancienne entree du fichier archives
                    grep -v "^$filename:" "$arch" > "$arch.tmp"
                    mv "$arch.tmp" "$arch"
                    ret=$?
                    
                    if [ "$ret" -ne 0 ]; then
                        echo "probleme dans la mise a jour du fichier archives de sh-toolbox"
                        exit 4
                    fi
                    
                    # Ajouter la nouvelle entree
                    echo "$filename:$DAT:" >> "$arch"
                    ret=$?
                    
                    if [ "$ret" -ne 0 ]; then
                        echo "probleme dans la mise a jour du fichier archives de sh-toolbox"
                        exit 4
                    else
                        echo "fichier copie avec succes dans sh-toolbox"
                        exit 0
                    fi
                else
                    echo "copie annulee"
                    exit 0
                fi
            fi
        else
            echo "le fichier que vous avez passe en parametre n'existe pas"
            exit 2
        fi
    else
        echo "le fichier archives n'est pas present dans toolbox"
        exit 1
    fi
fi
