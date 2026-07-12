 #ifndef TOOLS_H
#define TOOLS_H

    #include <stddef.h>  
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    // Initialiser le tableau de Vigenere 64x64
    char** init_table();    

    // Convertir un caractere base64 en valeur (0-63)
    int char_to_index(char letter);

    // Convertir une valeur (0-63) en caractere base64
    char index_to_char(int index);

    // Chiffrer un fichier
    void cipher_inf(char *key, char *file, char** alpha64);

    // Dechiffrer un fichier
    void decipher_inf(char* key, char* file, char** alpha64);

    // Lire deux fichiers (clair et chiffre)
    void readfile(char* file1, char* file2, char** reg_buffer, char** en_buffer, size_t *reg_len, size_t *en_len);

    // Detecter et simplifier une cle repetee
    char* decomp_key(char* reg_key);
    
    // Trouver la cle de chiffrement
    void findkey(char* file1, char* file2, char** alpha64);

    // Liberer la memoire du tableau
    void free_table(char** alpha64);
    
#endif