#include<stdio.h>
#include<windows.h>

int Laberinto(char* matriz, int nueva_fila, int nueva_columna, int fila_anterior, int columna_anterior);
void instrucciones();
void reiniciar(char lab[15][15], char aux[15][15], int imp);

int main(){
    //variables a utilizar en el codigo como posiciones de la matriz y banderas de control
    int res = 0, r = 1, c = 1, auxR = 1, auxC = 1, sigR, sigC, ban, op, ban2;  //variables a utilizar 
    char mov;  //variable donde se va a guardar el movimiento a realizar del usuario
    //Tablero del laberinto
    char labe[15][15] = {{'#','#','#','#','#','#','#','#','#','#','#','#','#','#','#'}, 
                        {'#','F','.','#','.','.','.','#','#','#','.','.','#','.','#'},
                        {'#','#','.','#','#','#','.','.','.','#','#','.','#','.','#'}, 
                        {'#','#','.','.','.','.','.','#','.','.','.','.','.','.','#'},
                        {'#','#','.','#','#','.','#','#','.','#','.','#','#','.','#'}, 
                        {'#','.','.','.','#','#','.','.','.','#','.','#','#','.','#'},
                        {'#','.','#','#','.','.','.','#','#','#','.','#','.','.','#'}, 
                        {'#','.','.','.','.','#','.','.','.','.','.','#','.','#','#'},
                        {'#','#','#','.','.','#','.','#','#','#','#','#','.','#','#'}, 
                        {'#','#','#','.','#','#','#','.','.','#','.','.','.','#','#'},
                        {'#','.','.','.','#','#','.','#','.','#','#','#','.','#','#'}, 
                        {'#','.','.','#','.','.','.','#','.','.','.','#','.','.','#'},
                        {'#','.','#','#','.','#','.','.','.','#','.','#','#','.','#'}, 
                        {'#','.','.','.','.','#','#','#','#','.','.','.','.','X','#'}, 
                        {'#','#','#','#','#','#','#','#','#','#','#','#','#','#','#'}
                    };
    //Auxiliar que tiene el laberinto inicial en caso de reinicio del juego
    char aux[15][15] = {{'#','#','#','#','#','#','#','#','#','#','#','#','#','#','#'}, 
                        {'#','F','.','#','.','.','.','#','#','#','.','.','#','.','#'},
                        {'#','#','.','#','#','#','.','.','.','#','#','.','#','.','#'}, 
                        {'#','#','.','.','.','.','.','#','.','.','.','.','.','.','#'},
                        {'#','#','.','#','#','.','#','#','.','#','.','#','#','.','#'}, 
                        {'#','.','.','.','#','#','.','.','.','#','.','#','#','.','#'},
                        {'#','.','#','#','.','.','.','#','#','#','.','#','.','.','#'}, 
                        {'#','.','.','.','.','#','.','.','.','.','.','#','.','#','#'},
                        {'#','#','#','.','.','#','.','#','#','#','#','#','.','#','#'}, 
                        {'#','#','#','.','#','#','#','.','.','#','.','.','.','#','#'},
                        {'#','.','.','.','#','#','.','#','.','#','#','#','.','#','#'}, 
                        {'#','.','.','#','.','.','.','#','.','.','.','#','.','.','#'},
                        {'#','.','#','#','.','#','.','.','.','#','.','#','#','.','#'}, 
                        {'#','.','.','.','.','#','#','#','#','.','.','.','.','X','#'}, 
                        {'#','#','#','#','#','#','#','#','#','#','#','#','#','#','#'}
                    };
    
    //primer ciclo que se repetira mietras el usuario desee volver a jugar
    do{
        //reestablecimiento de variables de control
        op = 0;
        ban2 = 0;

        //se llama a la funcion instrucciones, la cual expresa de lo que va el juego
        instrucciones();

        //ciclo que imprime la matriz en su estado incial
        for(int i = 0; i < 15; i++){
            printf("\n");
            for(int j = 0; j < 15; j++){
                printf("%c ", labe[i][j]);
            }
        }
        printf("\n\n");

        /*en este ciclo se pide al usuario que ingrese un movmiento y se va a estar
          repitiendo mientras el usuario no gane, reinicie o quite el juego*/
        do{
            //definicion o reseteo de variables de control
            ban = 0;
            res = 0;
            auxR = r;
            auxC = c;
            sigR = r;
            sigC = c;

            //se lee el movimiento que quiere hacer el usuario
            printf("\nSiguiente movimiento --> ");
            fflush(stdin);
            mov = getchar();
            printf("\n");
            
            //switch que controla la entrada dada por el usuario
            switch(mov){
                //en caso de w minuscula o mayuscula se ajusta el renglon para que vaya hacia arriba
                case 'W':
                case 'w':
                    sigR = r - 1;
                    break;
                //en caso de a minuscula o mayuscula se ajusta la columna para que vaya hacia la izquierda
                case 'A':
                case 'a':
                    sigC = c - 1;
                    break;
                //en caso de s minuscula o mayuscula se ajusta el renglon para que vaya hacia abajo
                case 'S':
                case 's':
                    sigR = r + 1;
                    break;
                //en caso de d minuscula o mayuscula se ajusta la columna para que vaya hacia la derecha
                case 'D':
                case 'd':
                    sigC = c + 1;
                    break;
                //en caso de que entre una r mayuscula o minuscula se coloca un 1 en res para controlar el caso de reinicio
                case 'R':
                case 'r':
                    res = 1;
                    break;
                /*en caso de que entre una q mayuscula o minuscula se coloca un 10 en res y a la 
                  bandera 2 se enciende con un 1 para controlar el caso de que el usuario quiera salir del juego*/
                case 'Q':
                case 'q':
                    printf("\n\nSaliendo del juego...\n\n"); //mensaje de salida
                    res = 10;
                    ban2 = 1;
                    break;
                /*en caso de que el caracter ingresado no sea ninguno de los revisados en el switch se muestra un mensaje de error
                  y se enciende la bandera 1 con un 1*/
                default:
                    printf("Error en la opcion ingrsada, vuelve a intentar.\n");
                    ban = 1;
            }
            
            //en este if se revisa si el caracter ingresado es un caracter valido
            if(ban == 0){
                //if en el que se revisa que el caracter ingresado no sea de reinicio o de salida
                if((res != 1) && (res != 10)){
                    //if en el que se revisa que el movimiento deseado del usuario este dentro de los limites de la matriz
                    if(sigR >= 0 && sigR < 15 && sigC >= 0 && sigC < 15){
                        //se guarda en res lo que retorna el programa en nasm para saber si el usuario ya gano o no 
                        res = Laberinto(&labe[0][0], sigR, sigC, auxR, auxC);
                        if(res == 0){   /*si res retorna un 0 quire decir que se logro hacer el movimiento y las nuevas coordenadas son
                                            las que se guardaron como siguiente*/
                            r = sigR;
                            c = sigC;
                        }
                    }
                }
            } else{     //si la bandera tiene un 1 simplemente se imprime la matriz tal cual como esta
                for(int i = 0; i < 15; i++){
                    printf("\n");
                    for(int j = 0; j < 15; j++){
                        printf("%c ", labe[i][j]);
                    }
                }
                printf("\n");
            }

            //si el resultado es 1 despues de leer el movimiento, quiere decir que se va a reiniciar el juego
            if(res == 1){
                /*se limpia pantalla, se imprimen las instrucciones y se llama a la funcion reiniciar donde se reestablece el laberinto
                  tambien se resetean las variables de control*/
                system("cls");
                instrucciones();
                reiniciar(labe, aux, 1); /*se envia la matriz actual, la matriz auxiliar y un 1 para indicar que se tiene que 
                                           volver a imprimir la matriz*/
                res = 0;
                r = 1;
                c = 1;
                auxR = r;
                auxC = c;
            }
        } while(res != 10);

        /*si la bandera 2 es diferente de 1, es decir, el usuario no quiere salir, solo gano el juego,
          se pregunta si el jugador quiere jugar de nuevo y se limpia la pantalla*/
        if(ban2 != 1){
            //se pregunta si el usuario quiere jugar de nuevo y se cicla en caso de que la opcion no sea nunguna de las propuestas
            do{
                printf("\n\n  Desea volver a jugar: 0=NO, 1=SI\n    --> ");
                scanf("%d", &op);
                if(op < 0 || op > 1){
                    printf("\n\nError en la opcion indicada, vuelve a intentar.\n\n");
                }
            } while(op < 0 || op > 1);
            //si la opcion es 1 se limpia la pantalla y se llama a la funcion reiniciar y se resetan las variables de control
            if(op == 1){
                system("cls");
                reiniciar(labe, aux, 0); /*se envia la matriz actual, la matriz auxiliar y un 0 para indicar que no se tiene que 
                                           volver a imprimir la matriz, ya que al inicio de este ciclo ya se imprimira*/
                res = 0;
                r = 1;
                c = 1;
                auxR = r;
                auxC = c;
            } else{  //si la opcion elegida es 0, se muestra un mensaje de salida y se termina el programa
                printf("\n\nGracias por jugar.\n\n");
                break;
            }
        }
    } while(op == 1 || ban2 != 1);
    
    return 0;
}

void instrucciones(){
    //se imprimen las instrucciones y especificaciones del juego en pantalla

    printf("\n---> Instrucciones del juego <---\n");
    printf("1.El juego se basa en un laberinto de 15x15.\n");
    printf("2.La ficha del jugador es la letra F.\n");
    printf("3.Para ganar debes de llegar a la letra X.\n");
    printf("4.Te puedes mover usando las teclas W, A, S, D\n");
    printf("5.Puedes reiniciar el juego con la tecla R o r.\n");
    printf("6.Puedes salir del juego con la letra Q o q.\n");
    printf("7.Los simbolos # son paredes que no se pueden atravesar.\n");
    printf("8.Un punto es un camino por donde puedes pasar.\n\n");
}

void reiniciar(char lab[15][15], char aux[15][15], int imp){
    //se reinicia el laberinto y la posicion del jugador
    printf("\nReiniciando...\n");
    Sleep(1000);
    for(int i = 0; i < 15; i++){
        for(int j = 0; j < 15; j++){
            lab[i][j] = aux[i][j];
        }
    }

    //si lo que llega en imp es un 1, se imprime la matriz, de lo contrario la funcion se termina
    if(imp == 1){
        printf("\n");
        for(int i = 0; i < 15; i++){
            printf("\n");
            for(int j = 0; j < 15; j++){
                printf("%c ", lab[i][j]);
            }
        }
        printf("\n\n");
    }
}