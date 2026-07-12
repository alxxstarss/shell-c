# Toolbox de Gestion d'Archives

## Description

Ce projet contient 5 scripts permettant de gerer un environnement de travail pour analyser des archives de sauvegardes potentiellement compromises par un ransomware.

## Liste des fichiers

- `init-toolbox.sh` : Initialise l'environnement de travail
- `import-archive.sh` : Importe des archives dans l'environnement
- `ls-toolbox.sh` : Liste les archives importees
- `check-archive.sh` : Analyse une archive et detecte les fichiers suspects
- `restore-toolbox.sh` : Restaure un environnement corrompu

### Etapes
```bash
# Rendre les scripts executables
chmod +x *.sh

# Initialiser l'environnement
./init-toolbox.sh
```

## Utilisation

### 1. Initialisation
```bash
./init-toolbox.sh
```

Cree le dossier `.sh-toolbox` et le fichier `archives`

### 2. Import d'archives
```bash
# Importer une archive
./import-archive.sh client1.tar.gz

# Importer plusieurs archives
./import-archive.sh client1.tar.gz client2.tar.gz

# Forcer l'ecrasement
./import-archive.sh -f client1.tar.gz
```

### 3. Lister les archives
```bash
./ls-toolbox.sh
```

Affiche toutes les archives importees avec leurs informations.

### 4. Analyser une archive
```bash
./check-archive.sh
```

- Selectionne une archive a analyser
- Decompresse l'archive temporairement
- Recherche la derniere connexion admin
- Identifie les fichiers modifies apres cette connexion
- Recherche des versions saines dans les autres archives

### 5. Restaurer l'environnement
```bash
./restore-toolbox.sh
```

Detecte et corrige automatiquement les problemes dans l'environnement.

## Structure de l'environnement
```
projet/
├── init-toolbox.sh
├── import-archive.sh
├── ls-toolbox.sh
├── check-archive.sh
├── restore-toolbox.sh
└── .sh-toolbox/
    ├── archives
    ├── client1.tar.gz
    └── client2.tar.gz
```

## Format du fichier archives
```
3
client1.tar.gz:20251127-120000:
client2.tar.gz:20251128-130000:AES256_KEY
client3.tar.gz:20251129-140000:
```

Format : `nom_archive:date_import:cle_dechiffrement`

## Workflow typique
```bash
# 1. Initialiser
./init-toolbox.sh

# 2. Importer des archives
./import-archive.sh client1.tar.gz client2.tar.gz

# 3. Verifier les imports
./ls-toolbox.sh

# 4. Analyser une archive
./check-archive.sh

# 5. Restaurer si probleme
./restore-toolbox.sh
```

## Fonctionnalites bonus

- **import-archive.sh** : Option -f pour forcer l'ecrasement, import de plusieurs fichiers
- **ls-toolbox.sh** : Detection des incoherences entre fichiers et archives
- **restore-toolbox.sh** : Restauration automatique de l'environnement
- **check-archive.sh** : Recherche de versions saines dans les autres archives
