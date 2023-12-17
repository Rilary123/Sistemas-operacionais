#!/bin/bash

while true; do

    # Função para mostrar o menu de login usando dialog
    show_menu() {
        dialog --clear --title "Bem-vindo à Netflix" --menu "Escolha uma opção:" 10 40 2 \
        1 "Fazer login" \
        2 "Sair" 2> /tmp/option.txt
        option=$(cat /tmp/option.txt)
    }

    # Função para autenticar usuário
    login() {
        attempts_left=3
        until [ $attempts_left -le 0 ]; do
            username=$(dialog --clear --title "Login" --inputbox "Digite seu nome de usuário:" 10 40 2>&1 >/dev/tty)
            password=$(dialog --clear --title "Login" --insecure --passwordbox "Digite sua senha:" 10 40 2>&1 >/dev/tty)

            # Lógica de verificação (usuário e senha hardcoded para fins de exemplo)
            if [ "$username" == "usuario" ] && [ "$password" == "senha" ]; then
                dialog --clear --title "Login bem-sucedido!" --msgbox "Login bem-sucedido! Pressione OK para continuar." 10 40
                show_content
                return
            else
                ((attempts_left--))
                dialog --clear --title "Credenciais inválidas!" --yesno "Credenciais inválidas! Tentar novamente? Tentativas restantes: $attempts_left" 10 40
                response=$?
                if [ $response -ne 0 ]; then
                    break
                fi
            fi
        done

        if [ $attempts_left -eq 0 ]; then
            dialog --clear --title "Limite de tentativas excedido" --msgbox "Limite de tentativas excedido. Saindo..." 10 40
        fi
    }

    # Função para mostrar conteúdo após login
    show_content() {
        selected_content=()
        for ((i = 0; i < 3; i++)); do
            dialog --clear --title "Conteúdo disponível" --menu "Selecione um conteúdo para assistir:" 12 40 4 \
                1 "Stranger Things" \
                2 "The Crown" \
                3 "Black Mirror" \
                4 "Money Heist" 2> /tmp/content.txt

            choice=$(cat /tmp/content.txt)
            selected_content+=("$choice")

            dialog --clear --title "Continuar assistindo?" --yesno "Deseja continuar assistindo? (Selecionados: ${selected_content[*]})" 10 40
            response=$?
            if [ $response -ne 0 ]; then
                break
            fi
        done
        show_menu
    }

    attempts=3
    until [ $attempts -le 0 ]; do
        show_menu
        case $option in
            1) login; ((attempts--));;
            2) dialog --clear --title "Saindo..." --msgbox "Saindo..." 10 40; exit ;;
        esac
    done

    if [ $attempts -eq 0 ]; then
        dialog --clear --title "Limite de tentativas excedido" --msgbox "Limite de tentativas excedido. Saindo..." 10 40
        exit
    fi

done
