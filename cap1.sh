#!/usr/bin/env bash

# ============================================================
# MODUL 1: CONCEPTE FUNDAMENTALE
# ============================================================

modul_pwd() {
    clear
    afiseaza_antet "COMANDA 'pwd' (Print Working Directory)"

    echo -e "${ALB}1. Afisare standard - Locatia curenta:${RESET}"
    print_out; pwd

    pas_urmator
    echo -e "${ALB}2. Calea logica (cu rezolvare symlink-uri) [pwd -L]:${RESET}"
    print_out; pwd -L

    pas_urmator
    echo -e "${ALB}3. Calea fizica absoluta [pwd -P]:${RESET}"
    print_out; pwd -P

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Navigare si PWD <<${RESET}"
    print_info "Aici poti simula mutarea in alte directoare pentru a vedea cum se schimba calea."
    while true; do
        read -p "Introdu o cale valida (ex: /etc, /var/log) sau '0' pt iesire: " cale_user
        if [[ "$cale_user" == "0" ]]; then break; fi

        if [ -d "$cale_user" ]; then
            cd "$cale_user" || continue
            print_out
            echo -n "Terminalul s-a mutat in: "
            pwd
            cd - > /dev/null
        else
            echo -e "${L_RED}Eroare: Calea '$cale_user' nu exista sau nu este director!${RESET}"
        fi
    done
}

modul_ls() {
    clear
    afiseaza_antet "COMANDA 'ls' (Inspectare Directoare)"

    echo -e "${ALB}1. Listare simpla (ls):${RESET}"
    print_out; ls

    pas_urmator
    echo -e "${ALB}2. Format detaliat/lung (ls -l):${RESET}"
    print_out; ls -l

    pas_urmator
    echo -e "${ALB}3. Format cu dimensiuni usor de citit (ls -lh):${RESET}"
    print_out; ls -lh

    pas_urmator
    echo -e "${ALB}4. Inclusiv fisiere ascunse (ls -a):${RESET}"
    print_out; ls -a

    pas_urmator
    echo -e "${ALB}5. Afisare identificatori hardware/inode (ls -li):${RESET}"
    print_out; ls -li

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Joaca-te cu LS <<${RESET}"
    print_info "Incearca propriile tale combinatii de parametri!"
    while true; do
        read -p "Scrie argumentele dorite (ex: -la /etc, -lS /boot) sau '0' pt iesire: ls " args_ls
        if [[ "$args_ls" == "0" ]]; then break; fi

        print_out
        
	eval "ls $args_ls" 2>/dev/null || echo -e "${L_RED}Comanda gresita sau director invalid!${RESET}"
        echo ""
    done
}

modul_date() {
    clear
    afiseaza_antet "COMANDA 'date' (Gestionare Timp)"

    echo -e "${ALB}1. Afisare completa implicita (date):${RESET}"
    print_out; date

    pas_urmator
    echo -e "${ALB}2. Timpul Universal Coordonat (date -u):${RESET}"
    print_out; date -u

    pas_urmator
    echo -e "${ALB}3. Format ceas digital (Ora:Minut:Secunda):${RESET}"
    print_out; date +%H:%M:%S

    pas_urmator
    echo -e "${ALB}4. Predictie data (ex: lunea viitoare):${RESET}"
    print_out; date -d "next monday"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Formatare Timp <<${RESET}"
    print_info "Construieste propriul ceas! (Variabile: %Y=An, %m=Luna, %d=Zi, %H=Ora, %M=Min)"
    while true; do
        read -p "Introdu un sablon (ex: '%d/%m/%Y' sau '%H:%M') sau '0' pt iesire: " sablon_timp
        if [[ "$sablon_timp" == "0" ]]; then break; fi

        print_out
        date +"$sablon_timp" 2>/dev/null || echo -e "${L_RED}Sablon de formatare invalid!${RESET}"
        echo ""
    done
}

modul_cal() {
    clear
    afiseaza_antet "COMANDA 'cal' (Calendar Sistem)"

    echo -e "${ALB}1. Afisare luna curenta (cal):${RESET}"
    print_out; cal

    pas_urmator
    echo -e "${ALB}2. Context trimestrial (luna anterioara, prezenta, viitoare):${RESET}"
    print_out; cal -3

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Masina Timpului <<${RESET}"
    while true; do
        read -p "Ce luna/an vrei sa vezi? (ex: 5 2030) sau '0' pt iesire: " cerere_cal
        if [[ "$cerere_cal" == "0" ]]; then break; fi

        print_out
        cal $cerere_cal 2>/dev/null || echo -e "${L_RED}Sintaxa gresita. Incearca [LUNA] [AN].${RESET}"
        echo ""
    done
}

modul_uptime() {
    clear
    afiseaza_antet "COMANDA 'uptime' (Timp Sistem)"

    echo -e "${ALB}1. Sumar complet al sistemului (uptime):${RESET}"
    print_out; uptime

    echo -e "\n${ALB}2. Format vizual prietenos (uptime -p):${RESET}"
    print_out; uptime -p

    echo -e "\n${ALB}3. Momentul exact al ultimei porniri (uptime -s):${RESET}"
    print_out; uptime -s

    pauza
}

modul_man() {
    clear
    afiseaza_antet "DOCUMENTATIE (man, whatis, apropos)"

    echo -e "${ALB}1. 'whatis' - Explicatie scurta pentru o comanda:${RESET}"
    print_out; whatis ls 2>/dev/null || echo "E necesara actualizarea bazei mandb."

    pas_urmator
    echo -e "${ALB}2. 'apropos' - Cautare in manuale dupa un cuvant cheie:${RESET}"
    print_out; apropos network 2>/dev/null | head -5

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Cauta Informatii <<${RESET}"
    while true; do
        read -p "Despre ce comanda vrei detalii rapide? (ex: mkdir, chmod) sau '0' pt iesire: " cmd_info
        if [[ "$cmd_info" == "0" ]]; then break; fi

        print_out
        whatis "$cmd_info" 2>/dev/null || echo -e "${L_RED}Sistemul nu are manual pentru '$cmd_info'.${RESET}"
        echo ""
    done
}


# ============================================================
# SUB-MENIU CAPITOLUL 1 
# ============================================================
meniu_cap1() {
    while true; do
        clear
        afiseaza_antet "MODUL 1: LABORATOARE FUNDAMENTALE"
        echo -e "${ALB}Alege experimentul pe care doresti sa-l rulezi:${RESET}"
        echo -e "${L_GREEN}1.${RESET} Unde ma aflu? (pwd)"
        echo -e "${L_GREEN}2.${RESET} Explorare fisiere (ls)"
        echo -e "${L_GREEN}3.${RESET} Manipulare Timp (date)"
        echo -e "${L_GREEN}4.${RESET} Explorare Calendar (cal)"
        echo -e "${L_GREEN}5.${RESET} Stare Functionare (uptime)"
        echo -e "${L_GREEN}6.${RESET} Cere Ajutor Sistemului (whatis/apropos)"
        echo -e "${L_RED}0. REVENIRE LA MENIUL PRINCIPAL${RESET}"
        delim_mic

        read -p "Introdu numarul optiunii (0-6): " optiune_cap1

        case $optiune_cap1 in
            1) modul_pwd ;;
            2) modul_ls ;;
            3) modul_date ;;
            4) modul_cal ;;
            5) modul_uptime ;;
            6) modul_man ;;
            0) break ;;
            *) echo -e "${L_RED}Selectie invalida! Te rog sa alegi un numar din lista.${RESET}"; sleep 1.5 ;;
        esac
    done
}
