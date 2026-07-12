#!/bin/bash

toolbox=".sh-toolbox"
arch="$toolbox/archives"

echo "Restauration de l'environnement de travail"
echo ""

# Verifier l'existence de .sh-toolbox
if [ ! -d "$toolbox" ]; then
    echo "Probleme detecte: Dossier .sh-toolbox manquant"
    read -p "Voulez-vous creer le dossier .sh-toolbox ? (O/N) " rep
    if [ "$rep" = "O" ]; then
        mkdir "$toolbox"
        if [ -d "$toolbox" ]; then
            echo "Dossier cree avec succes"
        else
            echo "ERREUR: Impossible de creer le dossier"
        fi
    else
        echo "Action annulee"
    fi
    echo ""
fi

# Verifier le fichier archives
if [ -d "$toolbox" ] && [ ! -e "$arch" ]; then
    echo "Probleme detecte: Fichier archives manquant"
    read -p "Voulez-vous creer le fichier archives ? (O/N) " rep
    if [ "$rep" = "O" ]; then
        echo "0" > "$arch"
        if [ -e "$arch" ]; then
            echo "Fichier cree avec succes"
        else
            echo "ERREUR: Impossible de creer le fichier"
        fi
    else
        echo "Action annulee"
    fi
    echo ""
fi

# Verifier les archives mentionnees mais absentes
if [ -e "$arch" ]; then
    tail -n +2 "$arch" > "$arch.tmp"
    
    # Utiliser le descripteur de fichier 3 pour la lecture
    while read -r line <&3; do
        if [ -z "$line" ]; then
            continue
        fi
        
        filename=$(echo "$line" | cut -d ':' -f 1)
        
        if [ ! -e "$toolbox/$filename" ]; then
            echo "Probleme detecte: Archive '$filename' mentionnee dans archives mais absente du dossier"
            echo "Options:"
            echo "  1) Supprimer l'entree du fichier archives"
            echo "  2) Indiquer le chemin du fichier pour l'ajouter au dossier"
            echo "  3) Ne rien faire"
            read -p "Votre choix (1/2/3) : " choix
            
            case "$choix" in
                1)
                    # Supprimer l'entree du fichier archives
                    grep -v "^$filename:" "$arch" > "$arch.tmp2"
                    mv "$arch.tmp2" "$arch"
                    
                    # Decrementer le compteur
                    compteur=$(head -n 1 "$arch")
                    if [ "$compteur" -gt 0 ]; then
                        compteur=$((compteur - 1))
                        tail -n +2 "$arch" > "$arch.tmp3"
                        echo "$compteur" > "$arch"
                        cat "$arch.tmp3" >> "$arch"
                        rm -f "$arch.tmp3"
                    fi
                    
                    echo "Entree supprimee du fichier archives"
                    ;;
                2)
                    # Demander le chemin du fichier
                    read -p "Entrez le chemin vers $filename : " chemin_fichier
                    
                    if [ -f "$chemin_fichier" ]; then
                        nom_fichier=$(basename "$chemin_fichier")
                        if [ "$nom_fichier" = "$filename" ]; then
                            cp "$chemin_fichier" "$toolbox/"
                            if [ -e "$toolbox/$filename" ]; then
                                echo "Archive copiee dans .sh-toolbox avec succes"
                            else
                                echo "ERREUR: Impossible de copier l'archive"
                            fi
                        else
                            echo "ERREUR: Le nom du fichier ne correspond pas"
                        fi
                    else
                        echo "ERREUR: Fichier non trouve ou inaccessible"
                    fi
                    ;;
                3)
                    echo "Aucune action effectuee"
                    ;;
                *)
                    echo "Choix invalide, aucune action effectuee"
                    ;;
            esac
            echo ""
        fi
    done 3< "$arch.tmp"
    
    rm -f "$arch.tmp"
fi

# Verifier les archives presentes mais non mentionnees
if [ -d "$toolbox" ] && [ -e "$arch" ]; then
    for fichier in "$toolbox"/*; do
        if [ ! -e "$fichier" ]; then
            continue
        fi
        
        nom=$(basename "$fichier")
        
        # Ignorer le fichier archives
        if [ "$nom" = "archives" ]; then
            continue
        fi
        
        # Verifier si mentionne dans archives
        if ! grep -q "^$nom:" "$arch"; then
            echo "Probleme detecte: Archive '$nom' presente dans .sh-toolbox mais non mentionnee dans archives"
            echo "Options:"
            echo "  1) Ajouter au fichier archives"
            echo "  2) Supprimer du dossier .sh-toolbox"
            echo "  3) Ne rien faire"
            read -p "Votre choix (1/2/3) : " choix
            
            case "$choix" in
                1)
                    # Ajouter au fichier archives
                    DAT=$(date +"%Y%m%d-%H%M%S")
                    compteur=$(head -n 1 "$arch")
                    compteur=$((compteur + 1))
                    
                    # Mettre a jour le compteur
                    tail -n +2 "$arch" > "$arch.tmp"
                    echo "$compteur" > "$arch"
                    cat "$arch.tmp" >> "$arch"
                    rm -f "$arch.tmp"
                    
                    # Ajouter la nouvelle entree
                    echo "$nom:$DAT:" >> "$arch"
                    echo "Archive ajoutee au fichier archives"
                    ;;
                2)
                    # Supprimer du dossier
                    rm -f "$fichier"
                    if [ ! -e "$fichier" ]; then
                        echo "Archive supprimee du dossier .sh-toolbox"
                    else
                        echo "ERREUR: Impossible de supprimer l'archive"
                    fi
                    ;;
                3)
                    echo "Aucune action effectuee"
                    ;;
                *)
                    echo "Choix invalide, aucune action effectuee"
                    ;;
            esac
            echo ""
        fi
    done
fi

echo ""
echo "Restauration terminee"
exit 0
