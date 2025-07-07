//Añadimos las librerias
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "intro.h"

//Prototipos
/**
 * @brief Funcion que determina si los valores son iguales o no
 * @param texto1, de tipo char, con un array
 * @param texto2, de tipo char, con un array
**/
bool son_textos_iguales (char texto1[], char texto2[]);
int main() {
    // definimos las variables de tipo char
    char texto1[] = {"Hola"};
    char texto2[] = {"Hola"};
    //Llamamos a la funcion de tipo bool para determinar si son iguales o no
    bool iguales = son_textos_iguales (texto1, texto2);

    //Mostramos el resultado por pantalla
    if (iguales) {
        printf ("Los textos son iguales.\n");
    } else {
        printf ("Los textos no son iguales.\n");
    }

    return EXIT_SUCCESS;
}

bool son_textos_iguales(char texto1[], char texto2[]) {
    //Definimos las varibales de la funcion
    int len1, len2;
    len1 = strlen (texto1);
    len2 = strlen (texto2);
    if (len1 != len2) {
            return false;

    for (int i = 0; i < len1; i++) {

            if (texto1[i] != texto2[i]) {
                return false;
            }
        }

    }
    return true;
}
