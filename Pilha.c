#include <stdio.h>
#include <stdlib.h>

typedef struct Lista {
    int coda;
    int x;
    int y;
    struct Lista *prox;
} aviao;

aviao *topo = NULL;

// Inserção no topo (LIFO)
void InsereH(int cod, int x, int y) {
    aviao *novo = malloc(sizeof(aviao));
    if (novo == NULL) {
        printf("Erro ao alocar memória!\n");
        return;
    }
    novo->coda = cod;
    novo->x = x;
    novo->y = y;
    novo->prox = topo;
    topo = novo;
}

// Impressão da lista
void Print(aviao *topo) {
    aviao *aux = topo;
    if (aux == NULL) {
        printf("A lista está vazia.\n");
    } else {
        while (aux != NULL) {
            printf("========================================\n");
            printf("Código do avião: %d\n", aux->coda);
            printf("Longitude: %d\n", aux->x);
            printf("Latitude: %d\n", aux->y);
            aux = aux->prox;
        }
        printf("========================================\n");
    }
}

// Remover o primeiro avião (topo da pilha)
void Remover() {
    if (topo == NULL) {
        printf("Lista vazia! Nada para remover.\n");
        return;
    }

    aviao *remover = topo;
    topo = topo->prox;

    printf("Removendo avião com código: %d\n", remover->coda);
    free(remover);
}

int main() {
    int escolha = 0;
    int cod = 0, x = 0, y = 0;

    while (escolha != 5) {
        printf("========================================\n");
        printf("1 - Inserir Avião\n");
        printf("2 - Listar Aviões\n");
        printf("3 - Remover Avião (do topo)\n");
        printf("5 - Sair\n");
        printf("========================================\n");
        printf("Escolha: ");
        scanf("%d", &escolha);

        switch (escolha) {
            case 1:
                printf("Insira o código do avião: ");
                scanf("%d", &cod);
                printf("Insira Longitude do avião: ");
                scanf("%d", &x);
                printf("Insira Latitude do avião: ");
                scanf("%d", &y);
                InsereH(cod, x, y);
                break;

            case 2:
                Print(topo);
                break;

            case 3:
                Remover();
                break;

            case 5:
                printf("Saindo...\n");
                break;

            default:
                printf("Opção inválida.\n");
                break;
        }
    }

    return 0;
}
