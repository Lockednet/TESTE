#!/bin/bash

SWAPPINESS=$(sysctl -n vm.swappiness)

activate_swap() {
    read -p "Digite a quantidade de gigabytes para a swap: " swap_size
    sudo fallocate -l "${swap_size}G" /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
    echo "Swap ativada com sucesso!"
}

deactivate_swap() {
    sudo swapoff -v /swapfile
    sudo rm /swapfile
    sed -i '/swapfile/d' /etc/fstab
    echo "Swap desativada com sucesso!"
}

monitor_usage() {
    echo "Monitoramento de Uso de Memória:"
    free -h
}

adjust_swappiness() {
    read -p "Digite o novo valor para vm.swappiness (50-90): " new_swappiness

    if [[ $new_swappiness -ge 50 && $new_swappiness -le 90 ]]; then
        sudo sysctl -w vm.swappiness=$new_swappiness
        echo "vm.swappiness ajustado para $new_swappiness."
    else
        echo "Valor inválido. O valor deve estar entre 50 e 90."
    fi
}

menu() {
    while true; do
        echo "1. Ativar Swap"
        echo "2. Desativar Swap"
        echo "3. Monitorar Uso de Memória"
        echo "4. Ajustar vm.swappiness"
        echo "5. Sair"

        read -p "Escolha uma opção: " choice

        case $choice in
            1) activate_swap ;;
            2) deactivate_swap ;;
            3) monitor_usage ;;
            4) adjust_swappiness ;;
            5) echo "Saindo..."; break ;;
            *) echo "Opção inválida. Tente novamente." ;;
        esac
    done
}

menu