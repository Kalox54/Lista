#!/bin/bash

# A estrutura de repetição 'while true' é utilizada para manter o menu em loop contínuo.
while true; do
    clear # O comando 'clear' limpa a tela.
    echo "======= Menu do Sistema ======="
    echo "1) Adicionar novo usuário"
    echo "2) Remover usuário"
    echo "3) Listar os usuários do sistema"
    echo "4) Remover um arquivo"
    echo "5) Fazer backup de arquivos"
    echo "6) Monitorar informações do sistema"
    echo "7) Derrubar conexão de rede"
    echo "8) Levantar conexão de rede"
    echo "9) Sair"
    echo "================================"
    read -p "Escolha uma opção: " opcao # 'read' lê a entrada do teclado.

    # A estrutura 'case' é usada para tomar decisões com base na opção escolhida.
    case $opcao in
        1) # Adicionar novo usuário
            read -p "Digite o nome do novo usuário: " usuario
            # Este comando é uma funcionalidade padrão do Linux para adicionar usuários.
            # O '&&' encadeia comandos, executando o segundo se o primeiro for bem-sucedido.
            sudo useradd -m -s /bin/bash "$usuario" && echo "Usuário $usuario adicionado."
            echo "Agora, defina a senha para o usuário $usuario:"
            sudo passwd "$usuario"
            read -p "Pressione Enter para continuar..."
            ;;
        2) # Remover usuário
            read -p "Digite o nome do usuário a ser removido: " usuario
            sudo userdel -r "$usuario" && echo "Usuário $usuario removido."
            read -p "Pressione Enter para continuar..."
            ;;
        3) # Listar os usuários do sistema
            echo "Usuários do sistema:"
            # Usando 'cut -d: -f1 /etc/passwd' como no exemplo do curso.
            cut -d: -f1 /etc/passwd
            read -p "Pressione Enter para continuar..."
            ;;
        4) # Remover um arquivo
            read -p "Digite o caminho do arquivo a ser removido: " arquivo
            # O comando 'rm' é utilizado para remover arquivos. O '-i' pede confirmação.
            rm -i "$arquivo"
            read -p "Pressione Enter para continuar..."
            ;;
        5) # Fazer backup de arquivos (usando cp -r como substituição para tar/gzip do exercício original, dado o contexto de 'cp' no material)
            read -p "Digite o diretório/arquivo de ORIGEM para backup: " origem
            read -p "Digite o diretório de DESTINO para o backup: " destino

            # Verificação e criação do diretório de destino, conforme boas práticas.
            if [ ! -d "$destino" ]; then # '-d' verifica se é um diretório
                echo "Diretório de destino '$destino' não existe. Tentando criar..."
                mkdir -p "$destino"
                if [ $? -ne 0 ]; then # '$?' verifica o código de retorno do último comando
                    echo "Erro: Não foi possível criar o diretório de destino '$destino'."
                    read -p "Pressione Enter para continuar..."
                    continue # Volta ao menu principal
                fi
            fi

            # Constrói o nome do diretório de backup com a data e hora.
            nome_backup="backup_$(date +%F_%H-%M-%S)"
            caminho_completo_destino="$destino/$nome_backup"

            echo "Copiando '$origem' para '$caminho_completo_destino'..."
            # O comando 'cp -r' é utilizado para copiar diretórios e subdiretórios.
            cp -r "$origem" "$caminho_completo_destino"

            if [ $? -eq 0 ]; then
                echo "Backup de '$origem' para '$caminho_completo_destino' criado com sucesso."
            else
                echo "Erro: Falha ao criar o backup de '$origem'."
            fi
            read -p "Pressione Enter para continuar..."
            ;;
        6) # Monitorar informações do sistema
            echo "Informações do sistema:"
            echo "------------------------"
            echo "Tempo de atividade:"
            # O comando 'uptime' mostra o tempo que o computador está ligado.
            uptime
            echo
            echo "Uso de disco:"
            # O comando 'df -h' mostra o uso de disco.
            df -h
            echo
            echo "Memória:"
            # O comando 'free -m' mostra o estado da memória.
            free -m
            echo
            echo "Processos ativos (primeiras 10 linhas):"
            # O comando 'ps -e' lista todos os processos, e 'head -n 10' mostra as 10 primeiras linhas.
            ps -e | head -n 10
            echo
            read -p "Pressione Enter para continuar..."
            ;;
        7) # Derrubar conexão de rede (Assumindo que o usuário saberá qual interface quer derrubar)
            # Para simplificar e seguir a proposta de usar comandos do material, usaremos um placeholder ou uma detecção simples.
            # A detecção de interface foi mantida para funcionalidade, mesmo não sendo explicitamente coberta nos exemplos de comandos básicos.
            iface=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)
            if [ -n "$iface" ]; then # '-n' verifica se a string não está vazia.
                echo "Derrubando conexão da interface: $iface..."
                sudo ip link set "$iface" down
                if [ $? -eq 0 ]; then
                    echo "Conexão $iface derrubada."
                else
                    echo "Erro ao derrubar a conexão $iface. Verifique as permissões ou se a interface está ativa."
                fi
            else
                echo "Nenhuma interface de rede não-loopback encontrada para derrubar."
            fi
            sleep 2
            ;;
        8) # Levantar conexão de rede
            iface=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)
            if [ -n "$iface" ]; then
                echo "Levantando conexão da interface: $iface..."
                sudo ip link set "$iface" up
                if [ $? -eq 0 ]; then
                    echo "Conexão $iface levantada."
                else
                    echo "Erro ao levantar a conexão $iface. Verifique as permissões ou se a interface existe."
                fi
            else
                echo "Nenhuma interface de rede não-loopback encontrada para levantar."
            fi
            sleep 2
            ;;
        9) # Sair
            echo "Saindo..."
            break # 'break' sai do loop 'while'.
            ;;
        *) # Opção inválida
            echo "Opção inválida. Tente novamente."
            sleep 2 # 'sleep' pausa a execução por alguns segundos.
            ;;
    esac
done
