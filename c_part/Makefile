CC = gcc

all: cipher decipher findkey

tools.o: tools.c tools.h
	$(CC) -c tools.c

# Bibliotheque statique contenant les fonctionnalites de dechiffrement et determination de cle
libtools.a: tools.o
	ar rcs libtools.a tools.o

cipher: cipher.c libtools.a
	$(CC) -o cipher cipher.c -L. -ltools

decipher: decipher.c libtools.a
	$(CC) -o decipher decipher.c -L. -ltools

findkey: findkey.c libtools.a
	$(CC) -o findkey findkey.c -L. -ltools

clean:
	rm -f findkey cipher decipher *.o libtools.a