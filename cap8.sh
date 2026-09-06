#!/usr/bin/env bash

# ============================================================
# MODUL 8: PROGRAMARE IN BASH (SHELL SCRIPTING)
# ============================================================

modul_programare_bash() {
    clear
    afiseaza_antet "CONCEPTE DE BAZA IN BASH SCRIPTING"

    echo -e "${ALB}1. Declararea si manipularea Variabilelor:${RESET}"
    utilizator_demo="Alexandru"
    nivel_acces=5
    print_out
    echo "  Nume inregistrat: $utilizator_demo"
    echo "  Nivel securitate: $nivel_acces"
    echo "  Numarul de caractere din nume: ${#utilizator_demo}"
    echo "  Formatare majuscule: ${utilizator_demo^^}"
    echo "  Formatare minuscule: ${utilizator_demo,,}"

    pas_urmator
    echo -e "${ALB}2. Variabile predefinite ale sistemului:${RESET}"
    print_out
    echo "  Numele acestui script: $0"
    echo "  Identificatorul procesului (PID): $$"
    echo "  Codul de retur (status) al ultimei comenzi: $? (0 = succes)"
    echo "  Contul curent: $USER"
    echo "  Folderul personal: $HOME"
    echo "  Locatii executabile (PATH): $(echo $PATH | cut -c1-55)..."

    pas_urmator
    echo -e "${ALB}3. Structuri decizionale (if / elif / else):${RESET}"
    print_info "Evaluam permisiunile pentru nivelul de acces '$nivel_acces'..."
    print_out
    if [ $nivel_acces -ge 5 ]; then
        echo "  Acces de tip Administrator aprobat."
    elif [ $nivel_acces -ge 3 ]; then
        echo "  Acces de tip Utilizator Standard aprobat."
    else
        echo "  Acces Restrictionat. Nivel insuficient."
    fi

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Structura IF <<${RESET}"
    while true; do
        read -p "Te rog sa introduci varsta ta (sau '0' pt iesire): " varsta_input
        if [[ "$varsta_input" == "0" ]]; then break; fi

        if [ "$varsta_input" -ge 18 ] 2>/dev/null; then
            echo -e "${L_GREEN}  >> Verificare reusita. Esti major (${varsta_input} ani).${RESET}"
        else
            echo -e "${L_RED}  >> Sistem blocat. Esti minor (${varsta_input} ani) sau format gresit.${RESET}"
        fi
        echo ""
    done

    pas_urmator
    clear
    afiseaza_antet "BUCLE SI FUNCTII IN BASH"

    echo -e "${ALB}4. Iterarea peste o colectie de elemente (Bucla FOR):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: for elev in Mihai Ioana Andrei; do ...${RESET}"
    print_out
    for elev in Mihai Ioana Andrei Maria; do
        echo "  Generare fisa pentru studentul: $elev"
    done

    pas_urmator
    echo -e "${ALB}5. Iteratii folosind un interval numeric (FOR Range):${RESET}"
    print_out
    for numar in {1..7}; do
        echo -n " [$numar] "
    done
    echo -e "\n"

    pas_urmator
    echo -e "${ALB}6. Structura repetitiva conditionata (Bucla WHILE):${RESET}"
    print_out
    secunde=5
    while [ $secunde -gt 0 ]; do
        echo -n " $secunde... "
        secunde=$((secunde - 1))
    done
    echo "Sistem Activat!"

    pas_urmator
    echo -e "${ALB}7. Modularizarea codului (Functii):${RESET}"
    print_out
    
    trimite_notificare() {
        local user_tinta=$1
        local mesaj_text=$2
        echo "  [Notificare catre $user_tinta]: $mesaj_text"
    }
    
    trimite_notificare "Admin" "Procesul de backup a fost finalizat."
    trimite_notificare "Guest" "Bine ai venit pe serverul demonstrativ."

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Generator Matematic <<${RESET}"
    read -p "Pentru a incepe, care este numele tau? " nume_vizitator
    while true; do
        read -p "Pana la ce numar calculam patratele perfecte? (ex: 5, 10) sau '0' pt iesire: " prag_max
        if [[ "$prag_max" == "0" ]]; then break; fi

        echo -e "\n${L_CYAN}Perfect, $nume_vizitator! Iata rezultatele:${RESET}"
        print_out
        for (( i=1; i<=prag_max; i++ )); do
            echo "  $i^2 = $((i*i))"
        done 2>/dev/null
        echo ""
    done
}

# ============================================================
# SUB-MENIU CAPITOLUL 8
# ============================================================
meniu_cap8() {
    while true; do
        clear
        afiseaza_antet "MODUL 8: SHELL SCRIPTING"
        echo -e "${ALB}Alege experimentul pe care doresti sa-l rulezi:${RESET}"
        echo -e "${L_GREEN}1.${RESET} Concepte Bash (Variabile, Bucle, Conditii, Functii)"
        echo -e "${L_RED}0. REVENIRE LA MENIUL PRINCIPAL${RESET}"
        delim_mic

        read -p "Selecteaza o sectiune (0-1): " optiune_cap8

        case $optiune_cap8 in
            1) modul_programare_bash ;;
            0) break ;;
            *) echo -e "${L_RED}Selectie invalida! Incearca din nou.${RESET}"; sleep 1.5 ;;
        esac
    done
}
