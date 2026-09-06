#!/usr/bin/env bash

# ============================================================
# MODUL 4: MANAGEMENTUL PROCESELOR SI SERVICIILOR
# ============================================================

modul_monitorizare_procese() {
    clear
    afiseaza_antet "INSPECTIA PROCESELOR (ps, pstree, pgrep)"

    echo -e "${ALB}1. Procesele asociate sesiunii curente (ps):${RESET}"
    print_out; ps

    pas_urmator
    echo -e "${ALB}2. Vedere de ansamblu a sistemului (ps aux - primele 10):${RESET}"
    echo -e "${L_PURPLE}  (Structura: UTILIZATOR | PID | %CPU | %RAM | COMANDA)${RESET}"
    print_out; ps aux | head -10
    echo "  ..."
    print_info "Numarul total de procese active acum: $(ps aux | wc -l)"

    pas_urmator
    echo -e "${ALB}3. Top 5 procese care solicita procesorul (CPU):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: ps aux --sort=-%cpu | head -6${RESET}"
    print_out; ps aux --sort=-%cpu | head -6

    pas_urmator
    echo -e "${ALB}4. Top 5 procese care consuma memoria RAM:${RESET}"
    echo -e "   ${L_CYAN}[CMD]: ps aux --sort=-%mem | head -6${RESET}"
    print_out; ps aux --sort=-%mem | head -6

    pas_urmator
    echo -e "${ALB}5. Cautarea rapida a identificatorului (pgrep):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: pgrep -la bash${RESET}"
    print_out; pgrep -la bash 2>/dev/null || pgrep -l bash

    pas_urmator
    echo -e "${ALB}6. Structura ierarhica a proceselor (pstree):${RESET}"
    print_out; pstree 2>/dev/null | head -10 || echo -e "${L_RED}(Pachetul psmisc nu este instalat pe acest sistem)${RESET}"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Cautare Proces <<${RESET}"
    while true; do
        read -p "Ce aplicatie cautam in memorie? (ex: sshd, bash, systemd) sau '0' pt iesire: " cauta_proc
        if [[ "$cauta_proc" == "0" ]]; then break; fi

        print_out
        pgrep -la "$cauta_proc" 2>/dev/null || echo -e "${L_RED}Nu a fost gasit niciun proces activ cu numele '$cauta_proc'.${RESET}"
        echo ""
    done
}

modul_joburi_servicii() {
    clear
    afiseaza_antet "SARCINI DE FUNDAL SI DAEMONI (jobs, systemctl)"

    echo -e "${ALB}1. Lansarea unei sarcini de test in fundal (Background):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: sleep 45 &${RESET}"
    sleep 45 &
    PID_FUNDAL=$!
    print_out
    echo "Sarcina a fost trimisa in fundal. PID alocat: $PID_FUNDAL"

    pas_urmator
    echo -e "${ALB}2. Lista sarcinilor active in terminal (jobs):${RESET}"
    print_out; jobs

    pas_urmator
    echo -e "${ALB}3. Oprirea sarcinii demonstrative:${RESET}"
    echo -e "   ${L_CYAN}[CMD]: kill $PID_FUNDAL${RESET}"
    kill $PID_FUNDAL 2>/dev/null
    sleep 0.5
    print_out; jobs
    print_info "Sarcina a fost incheiata."

    pas_urmator
    echo -e "${ALB}4. Lista serviciilor de sistem care ruleaza (systemctl):${RESET}"
    print_out
    systemctl list-units --type=service --state=running 2>/dev/null | head -10 || \
        echo -e "${L_RED}(Aceasta distributie nu foloseste systemd sau nu ai acces)${RESET}"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Stare Serviciu <<${RESET}"
    while true; do
        read -p "Verifica starea unui serviciu (ex: ssh, cron, ufw) sau '0' pt iesire: " nume_serviciu
        if [[ "$nume_serviciu" == "0" ]]; then break; fi

        print_out
        systemctl status "$nume_serviciu" 2>/dev/null | head -12 || \
            echo -e "${L_RED}Serviciul '$nume_serviciu' nu exista sau necesita privilegii de administrator.${RESET}"
        echo ""
    done
}

modul_control_semnale() {
    clear
    afiseaza_antet "TRIMITEREA SEMNALELOR (kill, pkill)"

    echo -e "${ALB}1. Tabelul semnalelor de sistem (kill -l):${RESET}"
    print_out; kill -l

    pas_urmator
    echo -e "${L_YELLOW}Explicatia semnalelor esentiale:${RESET}"
    echo -e "${ALB}  SIGTERM (15)${RESET} -> Solicita oprirea normala (soft kill). Da timp procesului sa se inchida."
    echo -e "${ALB}  SIGKILL  (9)${RESET} -> Opreste INSTANT procesul (hard kill). Poate duce la pierderi de date."
    echo -e "${ALB}  SIGHUP   (1)${RESET} -> Cere procesului sa isi reincarce fisierele de configurare."
    echo -e "${ALB}  SIGSTOP (19)${RESET} -> Pune procesul in pauza (suspendare)."
    echo -e "${ALB}  SIGCONT (18)${RESET} -> Trezeste un proces suspendat anterior."

    pas_urmator
    echo -e "${ALB}2. Demonstratie oprire gratioasa (SIGTERM):${RESET}"
    sleep 50 &
    TEST_PID_1=$!
    echo -e "   Proces pornit (sleep 50) cu PID: $TEST_PID_1"
    echo -e "   ${L_CYAN}[CMD]: kill -15 $TEST_PID_1${RESET}"
    kill -15 $TEST_PID_1 2>/dev/null
    sleep 0.5
    if kill -0 $TEST_PID_1 2>/dev/null; then
        echo -e "${L_RED}   >> Procesul a supravietuit semnalului!${RESET}"
    else
        echo -e "${L_GREEN}   >> Procesul $TEST_PID_1 a fost oprit elegant!${RESET}"
    fi

    pas_urmator
    echo -e "${ALB}3. Demonstratie oprire fortata (SIGKILL):${RESET}"
    sleep 50 &
    TEST_PID_2=$!
    echo -e "   Proces pornit (sleep 50) cu PID: $TEST_PID_2"
    echo -e "   ${L_CYAN}[CMD]: kill -9 $TEST_PID_2${RESET}"
    kill -9 $TEST_PID_2 2>/dev/null
    sleep 0.5
    if kill -0 $TEST_PID_2 2>/dev/null; then
        echo -e "${L_RED}   >> Eroare: Procesul inca ruleaza!${RESET}"
    else
        echo -e "${L_GREEN}   >> Procesul $TEST_PID_2 a fost 'ucis' instantaneu!${RESET}"
    fi

    pas_urmator
    echo -e "${ALB}4. Oprirea in masa (pkill):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: pkill -9 sleep${RESET}"
    pkill -9 sleep 2>/dev/null
    print_info "Toate instantele ramase de 'sleep' au fost curatate din memorie."

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Trimitere Semnal <<${RESET}"
    while true; do
        read -p "Introdu un PID pentru a-i trimite SIGTERM (sau '0' pt iesire): " pid_tinta
        if [[ "$pid_tinta" == "0" ]]; then break; fi

        if kill -0 "$pid_tinta" 2>/dev/null; then
            kill -15 "$pid_tinta" 2>/dev/null
            echo -e "${L_GREEN}>> Semnalul SIGTERM (15) a fost trimis catre procesul $pid_tinta.${RESET}"
        else
            echo -e "${L_RED}>> Eroare: Procesul cu PID-ul $pid_tinta nu exista sau nu ai drepturi asupra lui!${RESET}"
        fi
        echo ""
    done
}

modul_performanta_executie() {
    clear
    afiseaza_antet "EVALUAREA PERFORMANTEI (time)"

    echo -e "${ALB}1. Masurarea timpului de executie pentru listarea unui folder:${RESET}"
    echo -e "   ${L_CYAN}[CMD]: time ls -la > /dev/null${RESET}"
    print_out; time ls -la > /dev/null

    echo -e "\n${L_PURPLE}Explicatie parametri:${RESET}"
    echo -e "  real = Timpul total cronometrat pe ceas."
    echo -e "  user = Timpul efectiv petrecut de CPU procesand aplicatia."
    echo -e "  sys  = Timpul petrecut in functiile nucleului (kernel) de operare."

    pas_urmator
    echo -e "${ALB}2. Masurarea unei intarzieri intentionate (sleep):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: time sleep 1${RESET}"
    print_out; time sleep 1

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Cronometreaza propria comanda <<${RESET}"
    while true; do
        read -p "Ce comanda doriti sa cronometram? (ex: 'find /etc', 'du -sh /var') sau '0' pt iesire: " cmd_evaluare
        if [[ "$cmd_evaluare" == "0" ]]; then break; fi

        print_out
        time eval "$cmd_evaluare" 2>/dev/null | head -10
        echo -e "${L_PURPLE}  (Output-ul a fost taiat la 10 randuri pentru vizibilitate)${RESET}"
        echo ""
    done
}

# ============================================================
# SUB-MENIU CAPITOLUL 4
# ============================================================
meniu_cap4() {
    while true; do
        clear
        afiseaza_antet "MODUL 4: MANAGEMENT PROCESE"
        echo -e "${ALB}Alege experimentul pe care doresti sa-l rulezi:${RESET}"
        echo -e "${L_GREEN}1.${RESET} Inspectie si Cautare (ps, pstree, pgrep)"
        echo -e "${L_GREEN}2.${RESET} Sarcini de Fundal si Daemoni (jobs, systemctl)"
        echo -e "${L_GREEN}3.${RESET} Gestiunea prin Semnale (kill, pkill)"
        echo -e "${L_GREEN}4.${RESET} Evaluarea Timpului de Executie (time)"
        echo -e "${L_RED}0. REVENIRE LA MENIUL PRINCIPAL${RESET}"
        delim_mic

        read -p "Selecteaza o sectiune (0-4): " optiune_cap4

        case $optiune_cap4 in
            1) modul_monitorizare_procese ;;
            2) modul_joburi_servicii ;;
            3) modul_control_semnale ;;
            4) modul_performanta_executie ;;
            0) break ;;
            *) echo -e "${L_RED}Selectie invalida! Incearca din nou.${RESET}"; sleep 1.5 ;;
        esac
    done
}
