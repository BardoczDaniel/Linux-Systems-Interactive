#!/usr/bin/env bash

# ============================================================
# MODUL 2: ADMINISTRARE CONTURI
# ============================================================

modul_identitate() {
    clear
    afiseaza_antet "PROFIL UTILIZATOR (whoami, id, groups)"

    echo -e "${ALB}1. Numele contului curent (whoami):${RESET}"
    print_out; whoami

    pas_urmator
    echo -e "${ALB}2. Detalii complete de identificare (id):${RESET}"
    print_out; id

    pas_urmator
    echo -e "${ALB}3. Extragere tintita (Doar UID si GID):${RESET}"
    print_out; echo "User ID = $(id -u) | Group ID = $(id -g)"

    pas_urmator
    echo -e "${ALB}4. Lista grupurilor de apartenenta:${RESET}"
    print_out; groups

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Investigare Identitate <<${RESET}"
    print_info "Aici poti vedea ID-urile si grupurile altor utilizatori de pe sistem."
    while true; do
        read -p "Cauta detalii despre un cont (ex: root, daemon) sau '0' pt iesire: " user_cautat
        if [[ "$user_cautat" == "0" ]]; then break; fi

        print_out
        id "$user_cautat" 2>/dev/null || echo -e "${L_RED}Eroare: Contul '$user_cautat' nu a fost gasit in sistem!${RESET}"
        echo ""
    done
}


modul_creare_conturi() {
    clear
    afiseaza_antet "ADAUGARE CONTURI IN SISTEM"

    echo -e "${L_CYAN}Baza de date a utilizatorilor (/etc/passwd - primele 3 intrari):${RESET}"
    print_out; cut -d: -f1,3,7 /etc/passwd | head -3
    echo -e "${L_PURPLE}  (Structura: Username:UID:Interfata_Shell)${RESET}"

    pas_urmator
    delim_mic
    echo -e "${L_YELLOW}Comanda de adaugare (Necesita SUDO):${RESET}"
    echo -e "${ALB}  Adaugare cont:${RESET}  sudo useradd -m -s /bin/bash nume_nou"
    echo -e "${ALB}  Modificare:${RESET}     sudo usermod -aG sudo nume_user (Ofera privilegii de admin)"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Creare Cont Nou <<${RESET}"
    print_info "Iti va fi ceruta parola ta de sudo (administrator) pentru a face aceste operatiuni."

    while true; do
        read -p "Introdu un nume pentru un cont NOU (sau '0' pt iesire): " cont_nou
        if [[ "$cont_nou" == "0" ]]; then break; fi

        print_out
        echo -e "${L_CYAN}[CMD]: sudo useradd -m -s /bin/bash $cont_nou${RESET}"

        if sudo useradd -m -s /bin/bash "$cont_nou" 2>/dev/null; then
            echo -e "${L_GREEN}>> Contul '$cont_nou' a fost inregistrat cu succes pe sistem!${RESET}"

            print_info "Datele contului nou salvate in baza sistemului:"
            grep "^$cont_nou:" /etc/passwd | awk -F: '{print "   User: "$1" | UID: "$2" | Home: "$4" | Shell: "$5}'
        else
            echo -e "${L_RED}>> Eroare! Probabil contul '$cont_nou' exista deja sau numele introdus este invalid.${RESET}"
        fi
        echo ""
    done
}

modul_securitate_parole() {
    clear
    afiseaza_antet "SECURITATE SI PAROLE (passwd)"

    echo -e "${L_YELLOW}Sintaxe de baza pentru securizarea conturilor:${RESET}"
    echo -e "${ALB}  passwd${RESET}                  -> Iti schimba propria parola"
    echo -e "${ALB}  sudo passwd nume_user${RESET}   -> Schimba parola unui alt utilizator"
    echo -e "${ALB}  sudo passwd -l nume_user${RESET}-> LOCK (Suspenda temporar accesul contului)"
    echo -e "${ALB}  sudo passwd -u nume_user${RESET}-> UNLOCK (Reactiveaza accesul contului)"

    pas_urmator
    echo -e "${L_CYAN}Informatii despre identitatea ta curenta:${RESET}"
    print_out
    echo "Identitate operatoare: $(whoami) (UID: $(id -u))"
    print_info "Fisierul /etc/shadow memoreaza hash-urile parolelor. Doar root il poate citi!"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Gestiune Parole <<${RESET}"
    print_info "Foloseste contul pe care tocmai l-ai creat anterior!"

    while true; do
        read -p "Ce cont vrei sa administrezi? (ex: student_test) sau '0' pt iesire: " user_pass
        if [[ "$user_pass" == "0" ]]; then break; fi

        if ! id "$user_pass" &>/dev/null; then
            echo -e "${L_RED}Eroare: Contul '$user_pass' nu exista! Creeaza-l mai intai la optiunea 3.${RESET}\n"
            continue
        fi

        echo -e "${L_PURPLE}--- Optiuni pentru contul: $user_pass ---${RESET}"
        echo -e " 1. Seteaza o parola noua ${ALB}(passwd)${RESET}"
        echo -e " 2. Blocheaza contul      ${ALB}(passwd -l)${RESET}"
        echo -e " 3. Deblocheaza contul    ${ALB}(passwd -u)${RESET}"
        echo -e " 4. Verifica statusul     ${ALB}(passwd -S)${RESET}"
        read -p "Alege o actiune (1-4): " actiune_pass

        print_out
        case $actiune_pass in
            1)
                echo -e "${L_CYAN}[CMD]: sudo passwd $user_pass${RESET}"
                sudo passwd "$user_pass"
                ;;
            2)
                echo -e "${L_CYAN}[CMD]: sudo passwd -l $user_pass${RESET}"
                sudo passwd -l "$user_pass" 2>/dev/null && echo -e "${L_GREEN}>> Cont blocat cu succes!${RESET}" || echo -e "${L_RED}Eroare la blocare.${RESET}"
                ;;
            3)
                echo -e "${L_CYAN}[CMD]: sudo passwd -u $user_pass${RESET}"
                sudo passwd -u "$user_pass" 2>/dev/null && echo -e "${L_GREEN}>> Cont deblocat cu succes!${RESET}" || echo -e "${L_RED}Eroare la deblocare.${RESET}"
                ;;
            4)
                echo -e "${L_CYAN}[CMD]: sudo passwd -S $user_pass${RESET}"
                sudo passwd -S "$user_pass" 2>/dev/null || echo -e "${L_RED}Sistemul nu poate citi starea parolei fara permisiuni adecvate.${RESET}"
                ;;
            *)
                echo -e "${L_RED}Actiune invalida!${RESET}"
                ;;
        esac
        echo ""
    done
}

modul_stergere_conturi() {
    clear
    afiseaza_antet "ELIMINARE CONTURI DIN SISTEM"

    echo -e "${L_YELLOW}Comanda de stergere (Necesita SUDO):${RESET}"
    echo -e "${ALB}  Stergere cont:${RESET}  sudo userdel -r nume_user (-r elimina si directorul home)"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Curatare Sistem <<${RESET}"
    print_info "Aici iti poti sterge conturile de test pe care le-ai creat astazi pentru a curata sistemul."

    while true; do
        read -p "Introdu numele contului pe care doresti sa-l stergi (sau '0' pt iesire): " cont_sters
        if [[ "$cont_sters" == "0" ]]; then break; fi

        # Verificam mai intai daca exista
        if ! id "$cont_sters" &>/dev/null; then
            echo -e "${L_RED}>> Contul '$cont_sters' nu a fost gasit pe sistem.${RESET}\n"
            continue
        fi

        read -p "-> ESTI SIGUR ca vrei sa stergi definitiv contul '$cont_sters'? (y/n): " confirmare_del
        if [[ "$confirmare_del" == "y" || "$confirmare_del" == "Y" ]]; then
            print_out
            echo -e "${L_CYAN}[CMD]: sudo userdel -r $cont_sters${RESET}"

            if sudo userdel -r "$cont_sters" 2>/dev/null; then
                if ! id "$cont_sters" &>/dev/null; then
                    echo -e "${L_GREEN}>> Contul '$cont_sters' a fost sters complet (inclusiv folderul lui de home)!${RESET}"
                fi
            else
                echo -e "${L_RED}>> A aparut o eroare. Probabil contul ruleaza procese sau nu ai permisiuni de sudo.${RESET}"
            fi
        else
            echo -e "${L_YELLOW}>> Stergerea a fost anulata.${RESET}"
        fi
        echo ""
    done
}

# ============================================================
# SUB-MENIU CAPITOLUL 2
# ============================================================
meniu_cap2() {
    while true; do
        clear
        afiseaza_antet "MODUL 2: LABORATOARE ADMINISTRARE CONTURI"
        echo -e "${ALB}Alege experimentul pe care doresti sa-l rulezi:${RESET}"
        echo -e "${L_GREEN}1.${RESET} Profil si Identitate (whoami, id, groups)"
        echo -e "${L_GREEN}2.${RESET} Creare Utilizatori (useradd)"
        echo -e "${L_GREEN}3.${RESET} Securitate si Parole (passwd, Lock/Unlock)"
        echo -e "${L_GREEN}4.${RESET} Stergere Utilizatori (Curatare / userdel)"
        echo -e "${L_RED}0. REVENIRE LA MENIUL PRINCIPAL${RESET}"
        delim_mic

        read -p "Introdu numarul optiunii (0-4): " optiune_cap2

        case $optiune_cap2 in
            1) modul_identitate ;;
            2) modul_creare_conturi ;;
            3) modul_securitate_parole ;;
            4) modul_stergere_conturi ;;
            0) break ;;
            *) echo -e "${L_RED}Selectie invalida! Te rog sa alegi un numar din lista.${RESET}"; sleep 1.5 ;;
        esac
    done
}
