#include<stdio.h>
#include<string.h>
#include<stddef.h>
#include"tools.h"

int main(int argc , char* argv[]){
    
    // Verifier le nombre de parametres
    if(argc==3){

        printf("veuillez indiquer le fichier en clair en 1er lieu ensuite le fichier chiffre. \n");
        
        // Initialiser le tableau de Vigenere
        char** table=init_table();

        // Trouver la cle
        findkey(argv[1],argv[2],table);

        // Liberer la memoire
        free_table(table);

    }
    else{

        printf("veuillez indiquez 2 parametres le fichier en clair et le fichier chiffre \n");

        exit(1);

    }
}