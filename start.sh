#!/usr/bin/env bash

# ============================================================
# FUNCTII UTILITARE SI CAPITOLE
# ============================================================
source ./utilitare.sh
source ./cap1.sh
source ./cap2.sh
source ./cap3.sh
source ./cap4.sh
source ./cap5.sh
source ./cap6.sh
source ./cap7.sh
source ./cap8.sh
source ./cap9.sh

# ============================================================
# MENIU PRINCIPAL
# ============================================================
meniu_principal() {
    while true; do
        clear
        delim_mare
        echo -e "${L_BLUE}              PROIECT SISTEME LINUX              ${RESET}"
        delim_mare
        echo ""
        echo -e "${ALB}  Academic Project${RESET}"
        echo -e "${ALB}  Linux Systems – University Assignment ${RESET}"
        echo ""
        delim_mic
        echo -e "${L_GREEN}1.${RESET} Concepte Fundamentale (Cai, istoric, help)"
        echo -e "${L_GREEN}2.${RESET} Administrare Conturi (Useri, grupuri, parole)"
        echo -e "${L_GREEN}3.${RESET} Gestiune Fisiere (Permisiuni, navigare, arhive)"
        echo -e "${L_GREEN}4.${RESET} Management Procese (Joburi, semnale, monitorizare)"
        echo -e "${L_GREEN}5.${RESET} Resurse Sistem (CPU, RAM, pachete software)"
        echo -e "${L_GREEN}6.${RESET} Networking (Adrese IP, porturi, ping, dns)"
        echo -e "${L_GREEN}7.${RESET} Programare C (Compilare GCC, linkare)"
        echo -e "${L_GREEN}8.${RESET} Scriptare Bash (Variabile, structuri de control)"
        echo -e "${L_GREEN}9.${RESET} Prelucrare Text (grep, awk, sort, cut, link-uri)"
        echo -e "${L_RED}0. IESIRE SI CURATARE MEDIU${RESET}"
        delim_mare
        
        read -p "Alege un modul (0-9): " optiune

        case $optiune in
            1) meniu_cap1 ;; 
            2) meniu_cap2 ;;
            3) meniu_cap3 ;;
            4) meniu_cap4 ;;
            5) meniu_cap5 ;;
            6) meniu_cap6 ;;
            7) meniu_cap7 ;;
            8) meniu_cap8 ;;
            9) meniu_cap9 ;;
            0)
                clear
                afiseaza_antet "INCHIDERE APLICATIE"
                
                rm -rf "$DEMO"
                
                print_info "Directorul de lucru temporar a fost sters cu succes."
                echo -e "${L_GREEN}La revedere!${RESET}"
                exit 0
                ;;
            *) 
                echo -e "${L_RED}Eroare: Te rog sa introduci un numar valid din meniu (0-9)!${RESET}"
                sleep 2 
                ;;
        esac
    done
}

# ============================================================
# EXECUTIE SCRIPT
# ============================================================

clear
setup_fisiere
sleep 1.5
meniu_principal
