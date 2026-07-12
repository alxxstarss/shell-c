# Projet de Chiffrement/Déchiffrement - Chiffre de Vigenère

Projet de programmes C pour chiffrer, déchiffrer et retrouver des clés de chiffrement dans le cadre d'une investigation de sécurité après une attaque ransomware.

## Description

Ce projet contient 3 programmes permettant de manipuler des fichiers chiffrés avec le chiffre de Vigenère sur des données encodées en base64. Ces outils sont conçus pour analyser et récupérer des fichiers compromis lors d'une attaque ransomware.

## Contexte technique

### Processus de chiffrement

Un fichier chiffré subit les transformations suivantes :

1. Encodage en base64 (avec la commande `base64`)
2. Chiffrement par le chiffre de Vigenère avec une clé en base64
3. Décodage depuis base64 (optionnel, selon utilisation)

## Structure du projet
```
projet-partieC/
 cipher.c          # Programme de chiffrement
 decipher.c        # Programme de déchiffrement
 findkey.c         # Programme de recherche de clé
 tools.c           # Bibliothèque commune
 tools.h           # En-têtes des fonctions
 Makefile          # Automatisation de la compilation
 README.md         # Ce fichier
```

## Installation

### Prérequis

- Compilateur GCC
- Make (optionnel mais recommandé)
- Système Linux ou macOS

### Compilation

#### Avec Makefile (recommandé)
```bash
# Compiler tous les programmes
make

# Compiler un seul programme
make cipher
make decipher
make findkey

# Nettoyer les fichiers compilés
make clean
```

## Utilisation

### 1. Programme cipher - Chiffrer un fichier

**Rôle :** Chiffre un fichier encodé en base64 avec une clé fournie.

**Syntaxe :**
```bash
./cipher  clé_base64 fichier 
```

### 2. Programme decipher - Déchiffrer un fichier

**Rôle :** Déchiffre un fichier chiffré avec une clé connue.

**Syntaxe :**
```bash
./decipher clé_base64 fichier_chiffré
```

### 3. Programme findkey - Retrouver la clé

**Rôle :** Compare un fichier en clair et sa version chiffrée pour retrouver la clé utilisée.

**Syntaxe :**
```bash
./findkey  fichier_clair fichier_chiffré
```

## Workflow de récupération après attaque

### Scénario

Vous disposez de :
- Une archive avec des fichiers sains (avant l'attaque)
- Une archive avec des fichiers chiffrés (après l'attaque)
- La clé de chiffrement est inconnue

### Étapes de récupération

#### Étape 1 : Extraire les fichiers
```bash
# Extraire un fichier sain d'une archive
tar -xzf client1-sauvegarde.tar.gz data/rapport.txt
mv data/rapport.txt rapport_sain.txt

# Extraire le même fichier chiffré
tar -xzf client2-compromis.tar.gz data/rapport.txt
mv data/rapport.txt rapport_chiffre.txt
```

#### Étape 2 : Encoder les fichiers en base64
```bash
# Encoder le fichier sain
base64 rapport_sain.txt > rapport_sain_b64.txt

# Encoder le fichier chiffré
base64 rapport_chiffre.txt > rapport_chiffre_b64.txt
```

#### Étape 3 : Retrouver la clé
```bash
./findkey rapport_sain_b64.txt rapport_chiffre_b64.txt
```

**Résultat :**
```
 la cle obtenue est Q2xlU0FFMjAyNQ== 
```

#### Étape 4 : Déchiffrer tous les fichiers

Maintenant qu'on a la clé, on déchiffre tous les fichiers compromis 
```bash
# Pour chaque fichier chiffré
base64 fichier_chiffre.txt > fichier_chiffre_b64.txt
./decipher Q2xlU0FFMjAyNQ== fichier_chiffre_b64.txt
base64 -d fichier_chiffre_b64.txt > fichier_restaure.txt
```

Tous les fichiers sont maintenant restaurés.


## Notes importantes

### Encodage base64 obligatoire

Les fichiers doivent être encodés en base64 avant d'utiliser ces programmes.
```bash
# Incorrect
./cipher CLE fichier.txt

# Correct
base64 fichier.txt > fichier_b64.txt
./cipher CLE fichier_b64.txt
```

### Clé en base64

La clé fournie doit également être en base64.
```bash
# Pour obtenir une clé en base64
echo -n "SAE2025" | base64
# Résultat : U0FFMjAyNQ==
```
