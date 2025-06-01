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
            ;;
        3)
            echo "Usuários do sistema:"
            cut -d: -f1 /etc/passwd
            read -p "Pressione Enter para continuar..."
            ;;
        4)
            read -p "Digite o caminho do arquivo a ser removido: " arquivo
            rm -i "$arquivo"
            ;;
        5)
            read -p "Digite o diretório/arquivo para backup: " origem
            read -p "Digite o diretório de destino: " destino
            tar -czvf "$destino/backup_$(date +%F_%H-%M-%S).tar.gz" "$origem"
            echo "Backup criado com sucesso."
            ;;
        6)
            echo "Informações do sistema:"
            echo "------------------------"
            uptime
            echo
            echo "Uso de disco:"
            df -h
            echo
            echo "Memória:"
            free -h
            echo
            echo "Processos ativos:"
            ps -e | head -n 10
            echo
            read -p "Pressione Enter para continuar..."
            ;;
        7)
            iface=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)
            sudo ip link set "$iface" down && echo "Conexão $iface derrubada."
            sleep 2
            ;;
        8)
            iface=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)
            sudo ip link set "$iface" up && echo "Conexão $iface levantada."
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



chmod +x menu.sh
