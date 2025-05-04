#include<stdio.h>

extern int Laberinto(char mat[][]);
void instrucciones();

int main(){
    char labe[15][15] = {   {'#','#','#','#','#','#','#','#','#','#','#','#','#','#','#',},
                            {'#','P','.','#','.','.','.','#','#','#','.','.','#','.','#',},
                            {'#','#','.','#','#','#','.','.','.','#','#','.','#','.','#',},
                            {'#','#','.','.','.','.','.','#','.','.','.','.','.','.','#',},
                            {'#','#','.','#','#','.','#','#','.','#','.','#','#','.','#',},
                            {'#','.','.','.','#','#','.','.','.','#','.','#','#','.','#',},
                            {'#','.','#','#','.','.','.','#','#','#','.','#','.','.','#',},
                            {'#','.','.','.','.','#','.','.','.','.','.','#','.','#','#',},
                            {'#','#','#','.','.','#','.','#','#','#','#','#','.','#','#',},
                            {'#','#','#','.','#','#','#','.','.','#','.','.','.','#','#',},
                            {'#','.','.','.','#','#','.','#','.','#','#','#','.','#','#',},
                            {'#','.','.','#','.','.','.','#','.','.','.','#','.','.','#',},
                            {'#','.','#','#','.','#','.','.','.','#','.','#','#','.','#',},
                            {'#','.','.','.','.','#','#','#','#','.','.','.','.','X','#',},
                            {'#','#','#','#','#','#','#','#','#','#','#','#','#','#','#',} };

    instrucciones();

    int reiniciar;

    do{
        reiniciar = Laberinto(&labe[0][0]);
        //printf("\nreiniciar =  %d \n\n", reiniciar);
    } while(reiniciar == 1);

    return 0;
}

void instrucciones(){
    printf("\nInstrucciones del juego:\n");
    printf("\n1.El juego se basa en un laberinto de 15x15.");
    printf("\n2.La ficha del jugador es la letra P.");
    printf("\n3.La meta es llegar al punto X.");
    printf("\n4.Te puedes mover usando las teclas W,A,S,D.");
    printf("\n5.Puedes reiniciar el juego con la tecla r.");
    printf("\n6.Puedes salir del juego con la letra q.");
    printf("\n7.Los simbolos # son paredes que no se pueden atravesar.");
    printf("\n8.Los puntos son los espacios por donde puedes moverte.\n");
}