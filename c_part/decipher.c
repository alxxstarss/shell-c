#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stddef.h>
#include"tools.h"

int main(int argc ,char* argv[]){

    // Verifier le nombre de parametres
    if(argc==3){

    printf("la cle de dechiffrement est la suivante  ==< %s >==\n",argv[1]);

    // Initialiser le tableau de Vigenere
    char **table=init_table();

    // Dechiffrer le fichier
    decipher_inf(argv[1],argv[2],table);

    // Liberer la memoire
    free_table(table);

    }
    else{

        printf("le nombre de parametres insere est inferieur a 2\n");
        
        exit(1);
    }
    
}