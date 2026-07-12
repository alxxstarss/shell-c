#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <stddef.h>
#include"tools.h"

int main(int argc ,char* argv[]){

    // Verifier le nombre de parametres
    if(argc==3){

    printf("la cle de chiffrement est la suivante  ==< %s >==\n",argv[1]);

    // Initialiser le tableau de Vigenere
    char **table=init_table();

    // Chiffrer le fichier
    cipher_inf(argv[1],argv[2],table);

    // Liberer la memoire
    free_table(table);

    }
    else{

        printf("le nombre de parametres insere est inferieur ou superieur a 2\n");
        
        exit(1);
    }    
    
}