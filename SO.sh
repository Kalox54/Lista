#!/bin/bash [cite: 4, 75]

# A estrutura de repetição 'while true' é utilizada para manter o menu em loop contínuo. [cite: 30]
while true; do [cite: 30]
    clear [cite: 8, 30, 75] # O comando 'clear' limpa a tela. [cite: 8, 30, 75]
    echo "======= Menu do Sistema =======" [cite: 25]
    echo "1) Adicionar novo usuário" [cite: 33]
    echo "2) Remover usuário" [cite: 33]
    echo "3) Listar os usuários do sistema" [cite: 33]
    echo "4) Remover um arquivo" [cite: 33]
    echo "5) Fazer backup de arquivos" [cite: 33]
    echo "6) Monitorar informações do sistema" [cite: 33]
    echo "7) Derrubar conexão de rede" [cite: 33]
    echo "8) Levantar conexão de rede" [cite: 33]
    echo "9) Sair" [cite: 33]
    echo "================================"
    read -p "Escolha uma opção: " opcao [cite: 26, 71] # 'read' lê a entrada do teclado. [cite: 26, 71]

    # A estrutura 'case' é usada para tomar decisões com base na opção escolhida. [cite: 24, 27, 28]
    case $opcao in [cite: 24, 27]
        1) # Adicionar novo usuário
            read -p "Digite o nome do novo usuário: " usuario [cite: 26, 71]
            # O material não aborda useradd/passwd diretamente, mas sim a criação de variáveis e comandos básicos.
            # Este comando é uma funcionalidade padrão do Linux para adicionar usuários.
            # O '&&' encadeia comandos, executando o segundo se o primeiro for bem-sucedido.
            sudo useradd -m -s /bin/bash "$usuario" && echo "Usuário $usuario adicionado."
            echo "Agora, defina a senha para o usuário $usuario:"
            sudo passwd "$usuario"
            read -p "Pressione Enter para continuar..."
            ;;
        2) # Remover usuário
            read -p "Digite o nome do usuário a ser removido: " usuario [cite: 26, 71]
            # O material não aborda userdel diretamente.
            sudo userdel -r "$usuario" && echo "Usuário $usuario removido."
            read -p "Pressione Enter para continuar..."
            ;;
        3) # Listar os usuários do sistema
            echo "Usuários do sistema:"
            # O material mostra 'cut -d: -f1 /etc/passwd' para listar usuários. [cite: 66]
            # Usando 'cut -d: -f1 /etc/passwd' como no exemplo do curso.
            cut -d: -f1 /etc/passwd
            read -p "Pressione Enter para continuar..."
            ;;
        4) # Remover um arquivo
            read -p "Digite o caminho do arquivo a ser removido: " arquivo [cite: 26, 71]
            # O comando 'rm' é utilizado para remover arquivos. O '-i' pede confirmação. [cite: 65]
            rm -i "$arquivo" [cite: 65]
            read -p "Pressione Enter para continuar..."
            ;;
        5) # Fazer backup de arquivos (usando cp -r como substituição para tar/gzip do exercício original, dado o contexto de 'cp' no material [cite: 65])
            read -p "Digite o diretório/arquivo de ORIGEM para backup: " origem [cite: 26, 71]
            read -p "Digite o diretório de DESTINO para o backup: " destino [cite: 26, 71]

            # Verificação e criação do diretório de destino, conforme boas práticas.
            # O material mostra 'mkdir' para criar diretórios. [cite: 5, 60]
            if [ ! -d "$destino" ]; then [cite: 12, 13] # '-d' verifica se é um diretório [cite: 12]
                echo "Diretório de destino '$destino' não existe. Tentando criar..."
                mkdir -p "$destino" [cite: 60]
                if [ $? -ne 0 ]; then [cite: 10, 69] # '$?' verifica o código de retorno do último comando [cite: 69]
                    echo "Erro: Não foi possível criar o diretório de destino '$destino'."
                    read -p "Pressione Enter para continuar..."
                    continue # Volta ao menu principal
                fi
            fi

            # Constrói o nome do diretório de backup com a data e hora.
            # O comando 'date' é usado para obter a data e hora. [cite: 7, 66, 75]
            nome_backup="backup_$(date +%F_%H-%M-%S)"
            caminho_completo_destino="$destino/$nome_backup"

            echo "Copiando '$origem' para '$caminho_completo_destino'..."
            # O comando 'cp -r' é utilizado para copiar diretórios e subdiretórios. [cite: 65]
            cp -r "$origem" "$caminho_completo_destino" [cite: 65]

            if [ $? -eq 0 ]; then [cite: 10, 69]
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
            # O comando 'uptime' mostra o tempo que o computador está ligado. [cite: 3]
            uptime [cite: 3]
            echo
            echo "Uso de disco:"
            # O comando 'df -h' mostra o uso de disco. [cite: 3]
            df -h [cite: 3]
            echo
            echo "Memória:"
            # O comando 'free -m' mostra o estado da memória. [cite: 3]
            free -m [cite: 3]
            echo
            echo "Processos ativos (primeiras 10 linhas):"
            # O comando 'ps -e' lista todos os processos, e 'head -n 10' mostra as 10 primeiras linhas.
            # O material menciona 'ps -e' para listar processos, embora não com 'head'.
            ps -e | head -n 10
            echo
            read -p "Pressione Enter para continuar..."
            ;;
        7) # Derrubar conexão de rede (Assumindo que o usuário saberá qual interface quer derrubar)
            # O material não aborda 'ip link' diretamente, mas menciona 'iface' em exercícios.
            # Para simplificar e seguir a proposta de usar comandos do material, usaremos um placeholder ou uma detecção simples.
            # A detecção de interface foi mantida para funcionalidade, mesmo não sendo explicitamente coberta nos exemplos de comandos básicos.
            iface=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)
            if [ -n "$iface" ]; then # '-n' verifica se a string não está vazia. [cite: 11]
                echo "Derrubando conexão da interface: $iface..."
                sudo ip link set "$iface" down
                if [ $? -eq 0 ]; then [cite: 10, 69]
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
            if [ -n "$iface" ]; then [cite: 11]
                echo "Levantando conexão da interface: $iface..."
                sudo ip link set "$iface" up
                if [ $? -eq 0 ]; then [cite: 10, 69]
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
            echo "Saindo..." [cite: 32]
            break # 'break' sai do loop 'while'. [cite: 32]
            ;;
        *) # Opção inválida
            echo "Opção inválida. Tente novamente." [cite: 28]
            sleep 2 # 'sleep' pausa a execução por alguns segundos. [cite: 30]
            ;;
    esac
done
