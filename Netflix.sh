#!/bin/bash

# Função para mostrar o menu de login usando dialog
show_menu() {
    dialog --clear --title "Bem-vindo à Netflix" --menu "Escolha uma opção:" 10 40 2 \
    1 "Fazer login" \
    2 "Sair" 2> /tmp/option.txt
    option=$(cat /tmp/option.txt)
}

# Função para autenticar usuário
login() {
    username=$(dialog --clear --title "Login" --inputbox "Digite seu nome de usuário:" 10 40 2>&1 >/dev/tty)

    password=$(dialog --clear --title "Login" --insecure --passwordbox "Digite sua senha:" 10 40 2>&1 >/dev/tty)

    # Lógica de verificação (usuário e senha hardcoded para fins de exemplo)
    if [ "$username" == "usuario" ] && [ "$password" == "senha" ]; then
        dialog --clear --title "Login bem-sucedido!" --msgbox "Login bem-sucedido! Pressione OK para continuar." 10 40
        show_content
    else
        dialog --clear --title "Credenciais inválidas!" --msgbox "Credenciais inválidas! Pressione OK para continuar." 10 40
        show_menu
    fi
}

# Função para mostrar conteúdo após login
show_content() {
    dialog --clear --title "Conteúdo disponível" --menu "Selecione um conteúdo para assistir:" 12 40 4 \
    1 "Stranger Things" \
    2 "The Crown" \
    3 "Black Mirror" \
    4 "Money Heist" 2> /tmp/content.txt
    show_menu
}

attempts=3
until [ $attempts -le 0 ]
do
    show_menu
    case $option in
        1) login; ((attempts--));;
        2) dialog --clear --title "Saindo..." --msgbox "Saindo..." 10 40; break ;;
    esac
done

if [ $attempts -eq 0 ]; then
    dialog --clear --title "Limite de tentativas excedido" --msgbox "Limite de tentativas excedido. Saindo..." 10 40
fi

