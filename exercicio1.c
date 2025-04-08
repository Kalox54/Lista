/*
1) Você foi contratado para desenvolver um sistema de um Cartório. O sistema deve 
permitir que a pessoa a ser atendida escolha a área desejada (1-Declaração, 2-Certidão, 3-Outros). 
Para isso, você deve implementar a estrutura de dados Correta, garantindo que os atendimentos sejam 
processados na sua devida ordem (FIFO - First In, First Out) tento os seguintes parâmetros: número da senha e código da área. 
a) (0,80 ponto) Inserir o atendimento 
b) (0,80 ponto) Remover o atendimento 
c) (0,40 ponto) Estruturação do sistema(estruturas de dados, organização, menu) 
*/
#include <stdio.h>
#include <stdlib.h>

typedef struct Operacao{
    int op;
    struct Operacao *prox;

} OP;
OP *ini;

void Inserir(int ope){
    OP *novo = malloc(sizeof(OP));
    OP *aux;
    novo->prox = NULL;
    novo->op = ope;
    if (ini == NULL){
        ini = novo;
    }
    else{
        aux = ini;
        while (aux->prox != NULL)
            aux = aux->prox;
        aux->prox = novo;
    }

}
void Print(){
    OP *aux = ini;

    if (aux == NULL)
        printf("Nao ha operacoes!!");
    else {
        while (aux != NULL){
            switch (aux->op)
            {
            case 1:
                printf("Operacao 1 - Declaracao\n");
                break;
            case 2:
                printf("Operacao 2 - Certidao\n");
                break;
            
            default:
                printf("Operacao 3 - Outros\n");
                break;
            }
            
            aux = aux->prox;
        }
    }    
}

void Remover(){
    if (ini == NULL) {
        printf("A fila está vazia.\n");
        return;
    }

    OP *temp = ini;
    ini = ini->prox;

    printf("Removendo operação: ");
    switch (temp->op) {
        case 1:
            printf("Declaracao\n");
            break;
        case 2:
            printf("Certidao\n");
            break;
        default:
            printf("Outros\n");
            break;
    }

    free(temp);
}




int main(){
    int escolha = 0;
    int opera = 0;

    while (escolha != 5) {
        printf("\n==================================MENU====================================\n");
        printf("1 - Inserir Operacao\n");
        printf("2 - Mostrar Operacao\n");
        printf("3 - Remover Operacao\n");
        printf("5 - Sair\n");
        printf("==========================================================================\n");
        printf("Escolha: ");
        scanf("%d", &escolha);

        switch (escolha) {
        case 1:
        
        printf("=========================Inserir Operacao=================================\n");
            printf("Escolha a area desejada (1-Declaracao, 2-Certidao, 3-Outros): ");
            scanf("%d",&opera);
            Inserir(opera);
            break;
        case 2:
            printf("=========================Mostrar Operacao=================================\n");
            Print();   
            break;
        case 3:
            printf("=========================Remover Operacao=================================\n"); 
            Remover();
            break;    
        case 5:
            printf("Saindo...");
            break;

        default:
            printf("Opção inválida!\n");
            break;
        }
    }

    return 0;
}