/**
 * @file textos.c
 *
 * @brief Programa que mira si un texto es igual que otro
 *
 * @author  Angel <angel.gonzalezla@almnos.unican.es>
 * @version 2023-11-21
 *
**/

#include <stdio.h>
#include <stdbool.h>
#include <string.h>

bool son_textos_iguales (char texto1[], char texto2[]);

int main (void) {

    char texto1[] = "MAPA";
    char texto2[] = "Mapa";

    if (son_textos_iguales (texto1, texto2)) {
        printf ("VERDADERO");
    } else {
        printf ("FALSE");
    }
    return 0;
}

bool son_textos_iguales (char texto1[], char texto2[]) {
    int tamanho1 = strlen(texto1);
    int tamanho2 = strlen(texto2);
    if (tamanho1 != tamanho2) {
        return false;
    }
    for (int i = 0; i < tamanho1; i++) {
        if (texto1[i] != texto2[i]) {
            return false;
        }
    }
    return true;
}
