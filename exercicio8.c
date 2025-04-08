#include <stdio.h>
#include <stdlib.h>

typedef struct Lista {
    int posicao;
    int coda;
    int x;
    int y;
    struct Lista *prox;
} aviao;

aviao *topo = NULL;
int quant = 1;

void InsereF (int x, int y){
    aviao *novo = malloc(sizeof(aviao));
    aviao *aux;

    novo->prox = NULL;
    novo->coda = quant;
    novo->x = x;
    novo->y = y;

    if (topo == NULL) {
        topo = novo;
    } else {
        aux = topo;
        while (aux->prox != NULL)
            aux = aux->prox;
        aux->prox = novo;
    }

    quant++;
}

void Print(aviao *topo){
    aviao *aux = topo;

    if (aux == NULL) {
        printf("A lista está vazia\n");
    } else {
        while (aux != NULL) {
            printf("Código do avião: %d \n", aux->coda);
            printf("Longitude: %d \n", aux->x);
            printf("Latitude: %d \n", aux->y);
            printf("==============================================\n");
            aux = aux->prox;
        }
    }
}

void Remover() {
    if (topo == NULL) {
        printf("A lista está vazia.\n");
        return;
    }

    int p;
    printf("Insira a posição que deseja remover: ");
    scanf("%d", &p);

    aviao *atual = topo;
    aviao *anterior = NULL;

    // Procurar o nó com a posição p
    while (atual != NULL && atual->coda != p) {
        anterior = atual;
        atual = atual->prox;
    }

    if (atual == NULL) {
        printf("O codigo %d não foi encontrada.\n", p);
        return;
    }

    // Remover do topo
    if (anterior == NULL) {
        topo = atual->prox;
    } else {
        anterior->prox = atual->prox;
    }

    printf("Avião do codigo %d removido com sucesso.\n", atual->coda);
    free(atual);
}


int main(){
    int escolha = 0;
    int x = 0, y = 0;

    while (escolha != 5) {
        printf("======================MENU====================\n");
        printf("1 - Inserir Avião\n");
        printf("2 - Mostrar Aviões\n");
        printf("3 - Remover Aviões\n");
        printf("5 - Sair\n");
        printf("==============================================\n");
        printf("Escolha: ");
        scanf("%d", &escolha);

        switch (escolha) {
        case 1:
            printf("================Inserir=======================\n");
            printf("O código do avião: %d \n", quant);
            printf("Insira Longitude do avião: ");
            scanf("%d", &x);
            printf("Insira Latitude do avião: ");
            scanf("%d", &y);
            InsereF(x, y);
            break;

        case 2:
            Print(topo);
            break;
        case 3:
           printf("================Remover=======================\n");
           Remover();
           printf("==============================================\n");
            break;    
        case 5:
            printf("Saindo...\n");
            break;

        default:
            printf("Opção inválida!\n");
            break;
        }
    }

    return 0;
}
