#!/usr/bin/env bash

# ============================================================
# MODUL 9: PROCESARE TEXT SI LEGATURI
# ============================================================

pregateste_fisiere_m9() {
    mkdir -p "$DEMO"
    echo -e "Mihai\nIoana\nAndrei\nMaria\nGabriel\nStefan\nMaria" > "$DEMO/elevi.list"
    echo -e "10\n5\n8\n9\n7\n10\n4\n9" > "$DEMO/calificative.dat"
}

modul_grep() {
    clear
    afiseaza_antet "CAUTAREA IN TEXT (grep)"
    pregateste_fisiere_m9

    echo -e "${ALB}1. Cautare simpla (grep):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: grep 'Maria' $DEMO/elevi.list${RESET}"
    print_out; grep "Maria" "$DEMO/elevi.list"

    pas_urmator
    echo -e "${ALB}2. Afisarea numarului randului (grep -n):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: grep -n 'i' $DEMO/elevi.list${RESET}"
    print_out; grep -n "i" "$DEMO/elevi.list"

    pas_urmator
    echo -e "${ALB}3. Excluderea unui cuvant - invert match (grep -v):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: grep -v 'Maria' $DEMO/elevi.list${RESET}"
    print_out; grep -v "Maria" "$DEMO/elevi.list"

    pas_urmator
    echo -e "${ALB}4. Ignorarea majusculelor/minusculelor (grep -i):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: grep -i 'stefan' $DEMO/elevi.list${RESET}"
    print_out; grep -i "stefan" "$DEMO/elevi.list"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Motorul Grep <<${RESET}"
    while true; do
        read -p "Tasteaza un sir de caractere pt a-l cauta in lista (sau '0' pt iesire): " termen_cautat
        if [[ "$termen_cautat" == "0" ]]; then break; fi

        print_out
        grep -in "$termen_cautat" "$DEMO/elevi.list" || echo -e "${L_RED}Niciun rezultat gasit pentru '$termen_cautat'!${RESET}"
        echo ""
    done
}

modul_sort_wc() {
    clear
    afiseaza_antet "ORDONARE SI CONTORIZARE (sort, wc)"
    pregateste_fisiere_m9

    echo -e "${ALB}1. Ordonare alfabetica standard (sort):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: sort $DEMO/elevi.list${RESET}"
    print_out; sort "$DEMO/elevi.list"

    pas_urmator
    echo -e "${ALB}2. Ordine alfabetica inversa (sort -r):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: sort -r $DEMO/elevi.list${RESET}"
    print_out; sort -r "$DEMO/elevi.list"

    pas_urmator
    echo -e "${ALB}3. Sortare pur numerica (sort -n):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: sort -n $DEMO/calificative.dat${RESET}"
    print_out; sort -n "$DEMO/calificative.dat"

    pas_urmator
    echo -e "${ALB}4. Eliminarea duplicatelor (sort -u):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: sort -u $DEMO/elevi.list${RESET}"
    print_out; sort -u "$DEMO/elevi.list"

    pas_urmator
    delim_mic
    echo -e "${ALB}5. Contorizarea elementelor (wc):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: wc $DEMO/elevi.list (Total linii, cuvinte, octeti)${RESET}"
    print_out; wc "$DEMO/elevi.list"
    echo "  >> Detaliat separat:"
    echo "  - Doar Linii (wc -l):   $(wc -l < $DEMO/elevi.list)"
    echo "  - Doar Cuvinte (wc -w): $(wc -w < $DEMO/elevi.list)"
    echo "  - Doar Bytes (wc -c):   $(wc -c < $DEMO/elevi.list)"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Contorizare Fisiere <<${RESET}"
    while true; do
        read -p "Introdu calea unui fisier pentru a-l numara (ex: /etc/passwd) sau '0' pt iesire: " fisier_wc
        if [[ "$fisier_wc" == "0" ]]; then break; fi

        if [ -f "$fisier_wc" ]; then
            print_out
            echo "Linii: $(wc -l < "$fisier_wc") | Cuvinte: $(wc -w < "$fisier_wc")"
        else
            echo -e "${L_RED}Eroare: Fisierul nu exista sau este director!${RESET}"
        fi
        echo ""
    done
}

modul_cut_pipeline() {
    clear
    afiseaza_antet "DECUPARE SI PIPELINE-URI (cut, |)"

    echo -e "${ALB}1. Decuparea pe coloane (cut - prima coloana):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: cut -d: -f1 /etc/passwd | head -4${RESET}"
    print_info "Extragem doar numele conturilor de sistem."
    print_out; cut -d: -f1 /etc/passwd | head -4

    pas_urmator
    echo -e "${ALB}2. Extragerea mai multor coloane (cut - coloanele 1 si 6):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: cut -d: -f1,6 /etc/passwd | head -4${RESET}"
    print_info "Extragem contul + directorul sau home."
    print_out; cut -d: -f1,6 /etc/passwd | head -4

    pas_urmator
    delim_mic
    echo -e "${L_YELLOW}EXEMPLU COMPLEX: Combinarea Filtrelor (Pipeline)${RESET}"
    echo -e "${ALB}Scenariu:${RESET} Gasim cele mai mari 4 fisiere din /etc"
    echo -e "   ${L_CYAN}[CMD]: find /etc -type f 2>/dev/null | xargs du -s 2>/dev/null | sort -rn | head -4${RESET}"
    print_out
    find /etc -type f 2>/dev/null | xargs du -s 2>/dev/null | sort -rn | head -4

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Extragere Coloane <<${RESET}"
    while true; do
        read -p "Ce coloana vrei sa extragi din /etc/passwd? (ex: 1 pt User, 7 pt Shell) sau '0' pt iesire: " col_cut
        if [[ "$col_cut" == "0" ]]; then break; fi

        print_out
        cut -d: -f"$col_cut" /etc/passwd 2>/dev/null | head -5 || echo -e "${L_RED}Numar coloana invalid!${RESET}"
        echo -e "${L_PURPLE}  (Lista taiata la 5 rezultate)${RESET}"
        echo ""
    done
}

modul_legaturi_ln() {
    clear
    afiseaza_antet "LEGATURI DE FISIERE (Scurtaturi - ln)"
    pregateste_fisiere_m9

    echo -e "${L_YELLOW}1. Legatura Simbolica (Soft Link) - Actioneaza ca un 'Shortcut'${RESET}"
    echo -e "Daca fisierul original este sters, scurtatura devine invalida (broken link)."
    echo -e "   ${L_CYAN}[CMD]: ln -sf $DEMO/elevi.list $DEMO/scurtatura_elevi${RESET}"
    ln -sf "$DEMO/elevi.list" "$DEMO/scurtatura_elevi"
    print_out; ls -la "$DEMO/scurtatura_elevi"

    pas_urmator
    echo -e "${L_YELLOW}2. Legatura Fizica (Hard Link) - Clona la nivel de Inode${RESET}"
    echo -e "Indica exact catre datele brute de pe disc. Daca stergi originalul, datele raman prin Hard Link!"
    echo -e "   ${L_CYAN}[CMD]: ln $DEMO/elevi.list $DEMO/clona_fizica_elevi${RESET}"
    ln "$DEMO/elevi.list" "$DEMO/clona_fizica_elevi" 2>/dev/null
    print_out; ls -li "$DEMO/elevi.list" "$DEMO/clona_fizica_elevi"
    print_info "Observa primul numar din stanga (inode-ul). Ambele fisiere au fix acelasi Inode!"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Creeaza o Scurtatura <<${RESET}"
    while true; do
        read -p "Da un nume pentru un Soft Link nou catre /etc/passwd (sau '0' pt iesire): " nume_link
        if [[ "$nume_link" == "0" ]]; then break; fi

        rm -f "$DEMO/$nume_link"

        ln -s "/etc/passwd" "$DEMO/$nume_link"
        print_out
        echo -e "${L_GREEN}>> Scurtatura creata cu succes! Inspectie:${RESET}"
        ls -la "$DEMO/$nume_link"
        echo ""
    done
}

# ============================================================
# SUB-MENIU CAPITOLUL 9
# ============================================================
meniu_cap9() {
    while true; do
        clear
        afiseaza_antet "MODUL 9: FILTRE SI LEGATURI"
        echo -e "${ALB}Alege experimentul pe care doresti sa-l rulezi:${RESET}"
        echo -e "${L_GREEN}1.${RESET} Cautarea in Text (grep)"
        echo -e "${L_GREEN}2.${RESET} Ordonare si Contorizare (sort, wc)"
        echo -e "${L_GREEN}3.${RESET} Decupare si Pipeline-uri complexe (cut, |)"
        echo -e "${L_GREEN}4.${RESET} Gestiune Inode-uri si Legaturi (ln)"
        echo -e "${L_RED}0. REVENIRE LA MENIUL PRINCIPAL${RESET}"
        delim_mic

        read -p "Selecteaza o sectiune (0-4): " optiune_cap9

        case $optiune_cap9 in
            1) modul_grep ;;
            2) modul_sort_wc ;;
            3) modul_cut_pipeline ;;
            4) modul_legaturi_ln ;;
            0) break ;;
            *) echo -e "${L_RED}Selectie invalida! Incearca din nou.${RESET}"; sleep 1.5 ;;
        esac
    done
}
