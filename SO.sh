#!/bin/bash

while true; do
    clear
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
    read -p "Escolha uma opção: " opcao

    case $opcao in
        1)
            read -p "Digite o nome do novo usuário: " usuario
            sudo useradd -m -s /bin/bash "$usuario" && echo "Usuário $usuario adicionado."
            echo "Agora, defina a senha para o usuário $usuario:"
            sudo passwd "$usuario"
            read -p "Pressione Enter para continuar..."
            ;;
        2)
            read -p "Digite o nome do usuário a ser removido: " usuario
            sudo userdel -r "$usuario" && echo "Usuário $usuario removido."
            read -p "Pressione Enter para continuar..."
            ;;
        3)
            echo "Usuários do sistema:"
            cut -d: -f1 /etc/passwd
            read -p "Pressione Enter para continuar..."
            ;;
        4)
            read -p "Digite o caminho do arquivo a ser removido: " arquivo
            rm -i "$arquivo"
            read -p "Pressione Enter para continuar..."
            ;;
        5)
            read -p "Digite o diretório/arquivo de ORIGEM para backup: " origem
            read -p "Digite o diretório de DESTINO para o backup: " destino

            if [ ! -d "$destino" ]; then
                echo "Diretório de destino '$destino' não existe. Tentando criar..."
                mkdir -p "$destino"
                if [ $? -ne 0 ]; then
                    echo "Erro: Não foi possível criar o diretório de destino '$destino'."
                    read -p "Pressione Enter para continuar..."
                    continue
                fi
            fi

            nome_backup="backup_$(date +%F_%H-%M-%S)"
            caminho_completo_destino="$destino/$nome_backup"

            echo "Copiando '$origem' para '$caminho_completo_destino'..."
            cp -r "$origem" "$caminho_completo_destino"

            if [ $? -eq 0 ]; then
                echo "Backup de '$origem' para '$caminho_completo_destino' criado com sucesso."
            else
                echo "Erro: Falha ao criar o backup de '$origem'."
            fi
            read -p "Pressione Enter para continuar..."
            ;;
        6)
            echo "Informações do sistema:"
            echo "------------------------"
            echo "Tempo de atividade:"
            uptime
            echo
            echo "Uso de disco:"
            df -h
            echo
            echo "Memória:"
            free -m
            echo
            echo "Processos ativos (primeiras 10 linhas):"
            ps -e | head -n 10
            echo
            read -p "Pressione Enter para continuar..."
            ;;
        7)
            iface=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)
            if [ -n "$iface" ]; then
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
        8)
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
        9)
            echo "Saindo..."
            break
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            sleep 2
            ;;
    esac
done
