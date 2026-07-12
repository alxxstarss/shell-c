#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"tools.h"

// Initialiser le tableau de Vigenere 64x64
char** init_table(){

    char** alpha=malloc(sizeof(char*)*64);

    // Table base64 : A-Z, a-z, 0-9, +, /
    char chars64[]={"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"};

    // Creer le tableau 2D
    for(int i=0;i<64;i++){

        alpha[i]=malloc(64*sizeof(char));

        // Remplir chaque ligne avec un decalage circulaire
        for (int j=0;j<64;j++){
            
            alpha[i][j]=*(chars64+((i+j)%64));

        }

    }

    printf("\n\t\t\t   =====< Le Tableau de Vigenere a ete initialise. >=====\n");

    return alpha;

}

// Convertir un caractere base64 en valeur (0-63)
int char_to_index(char letter){

    if ( letter >= 'A' && letter <= 'Z' ) return letter-'A';

    if ( letter >= 'a' && letter <= 'z' ) return 26+letter-'a';

    if ( letter >= '0' && letter <= '9' ) return 52+letter-'0';
    
    if ( letter == '+' ) return 62;

    if ( letter =='/' ) return 63;

    return -1;

}

// Convertir une valeur (0-63) en caractere base64
char index_to_char(int index){

    if((index>=0)&&(index<=25))return 'A'+index;

    if((index>=26)&&(index<=51))return 'a'+(index - 26);

    if((index>=52)&&(index<=61))return '0'+(index-52);
    
    if (index==62)return '+';

    if (index==63)return '/';

    return -1;

}

// Chiffrer un fichier
void cipher_inf(char* key,char *file,char **alpha64){

    int x,y;

    size_t key_pos=0,keyklenght=strlen(key);

    FILE* data;

    long length;

    char* buffer;

    // Ouvrir le fichier en lecture
    data = fopen(file,"r");

    if (data){

        // Obtenir la taille du fichier
        fseek(data,0,SEEK_END);

        length = ftell (data);

        fseek (data, 0, SEEK_SET);

        // Allouer la memoire pour le contenu
        buffer=malloc(length+1);

        if (buffer){

            fread(buffer,1,length,data);

        }

        fclose(data);

    }

    else{

        printf("echec d'ouverture du fichier\n");

        exit(1);
        
    }

    // Chiffrer caractere par caractere
    if(buffer){

        for (int i=0;i<length;i++){

            // Ignorer le padding
            if (buffer[i] == '='){

                continue;
            }

            // Sauter les caracteres '=' dans la cle
            while(key[key_pos%keyklenght] == '=' ){

                key_pos++;

            }

            // Obtenir les indices dans le tableau
            y=char_to_index(key[key_pos%keyklenght]);

            x=char_to_index(buffer[i]);
            
            // Chiffrer en utilisant le tableau de Vigenere
            if( y!=-1 && x!= -1 ) buffer[i]=alpha64[x][y];

            key_pos++;

        }
        
    }

    buffer[length]='\0';

    // Ecrire le fichier chiffre
    data=fopen(file,"w");

    if(data){

        fwrite(buffer, 1, length ,data);
    
        fclose(data);

        printf("le fichier donne a ete chiffre et decode avec succes !\n");
        
    }
    else{
        printf("impossible d'ouvrir le fichier\n");

        exit(1);
    }

    free(buffer);

}

// Dechiffrer un fichier
void decipher_inf(char* key,char* file,char** alpha64){

    size_t length,keylen=strlen(key),key_pos=0;

    int x,y;

    FILE* data; 

    char* buffer;

    // Ouvrir le fichier en lecture
    data=fopen(file,"r");

    if (data != NULL){

        // Obtenir la taille du fichier
        fseek(data,0,SEEK_END);

        length = ftell (data);

        fseek (data, 0, SEEK_SET); 
        
        // Allouer la memoire pour le contenu
        buffer=malloc(length+1);

        if (buffer){

            fread(buffer,1,length,data);

        }

        fclose(data);

    }

    else{

        printf("ouverture du fichier impossible \n");

        exit (1);
    }

    // Dechiffrer caractere par caractere
    if(buffer){

        for ( int i=0;i<length;i++){

            // Sauter les caracteres '=' dans la cle
            while(key[key_pos%keylen]=='='){

                key_pos++;

            }

            // Obtenir l'indice de la cle
            y=char_to_index(key[key_pos%keylen]);

            // Ignorer le padding
            if (buffer[i]!='='){

                // Chercher dans le tableau quelle ligne donne le caractere chiffre
                for (int x=0;x<64;x++){
                    
                    if(alpha64[x][y]==buffer[i]){

                        buffer[i]=index_to_char(x);

                        break;

                    }
                }

                key_pos++;

            }
        }
    }

    buffer[length] = '\0';

    // Ecrire le fichier dechiffre
    data=fopen(file,"w");

    if(data){

        fwrite(buffer, 1, length ,data);
    
        fclose(data);

        printf("le fichier donne a ete encode et dechiffre avec succes !\n");
        
    }
    else{

        printf("impossible d'ouvrir le fichier\n");

        exit(1);
    }

    free(buffer);

}

// Lire deux fichiers (clair et chiffre)
void readfile(char* file1,char* file2,char** reg_buffer,char** en_buffer,size_t *reg_len,size_t *en_len){

    FILE* data;

    // Lire le fichier en clair
    data=fopen(file1,"r");

        if (data != NULL){

        fseek(data,0,SEEK_END);

        *reg_len = ftell (data);

        fseek (data, 0, SEEK_SET);

        *reg_buffer=malloc((*reg_len)+1);

        if (*reg_buffer){

            fread(*reg_buffer,1,*reg_len,data);

        }

        fclose(data);

    }
    
    // Lire le fichier chiffre
    data=fopen(file2,"r");

        if (data != NULL){

            fseek(data,0,SEEK_END);

            *en_len = ftell (data);

            fseek (data, 0, SEEK_SET); 
        
            *en_buffer=malloc(*en_len+1);

        if (*en_buffer){

            fread(*en_buffer,1,*en_len,data);

        }

        fclose(data);

    }
}

// Detecter et simplifier une cle repetee
char* decomp_key(char* reg_key){

    size_t len=strlen(reg_key);

    char* final=malloc(1024);

    // Chercher le motif qui se repete
    for (int i=1;i<len/2;i++){

        strncpy(final,reg_key,i);

        final[i]='\0';

        // Verifier si ce motif se repete dans toute la cle
        if(strncmp(final,reg_key+i,i)==0){

            return final;
        }

    }
    
    // Pas de repetition trouvee
    strcpy(final, reg_key);
    
    return final;
}

// Trouver la cle de chiffrement

void findkey(char* file1 ,char* file2,char** alpha64){

    char* reg_buffer;

    char* en_buffer;

    char result[1024];

    char* final;

    size_t reg_len,en_len;

    readfile(file1,file2,&reg_buffer,&en_buffer,&reg_len,&en_len);

    int k=0;
    
    // Calculer la cle caractere par caractere
    for(int i=0;i<reg_len && i<en_len;i++){  

        // Ignorer les positions avec padding
        if (reg_buffer[i]!='=' && en_buffer[i]!='='){

            // Obtenir l'indice du caractere clair
            int X=char_to_index(reg_buffer[i]);
            
            //  VERIFICATION : Si X est invalide, sauter
            if(X == -1) continue;

            // Chercher dans quelle colonne se trouve le caractere chiffre
            for(int j=0;j<64;j++){

                    if(alpha64[X][j]==en_buffer[i]){

                        result[k]=index_to_char(j);

                        k++;

                        break;

                    }

                }
            }  

        }

    result[k]='\0';

    // Simplifier la cle si elle se repete
    final=decomp_key(result);

    // Afficher la cle sur stdout
    printf("<=== la cle obtenue est %s ===>\n",final);

    // Afficher la taille sur stderr
    fprintf(stderr, "Taille de la cle : %zu\n", strlen(final));

    free(reg_buffer);

    free(en_buffer);

    free(final);
}

// Liberer la memoire du tableau
void free_table(char** alpha64){


    for (int i=0;i<64;i++){

        free(alpha64[i]);

    }

    free(alpha64);

}