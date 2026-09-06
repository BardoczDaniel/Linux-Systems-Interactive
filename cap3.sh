#!/usr/bin/env bash

# ============================================================
# MODUL 3: GESTIUNEA SISTEMULUI DE FISIERE
# ============================================================

verifica_fisiere() {
    if [ ! -f "$DEMO/elevi.list" ]; then
        echo -e "${L_RED}>> Fisierele de test nu exista! Te rog sa rulezi Optiunea 1 (Preparare Mediu) mai intai. <<${RESET}"
        pauza
        return 1 
    fi
    return 0
}

modul_pregatire_fisiere() {
    clear
    afiseaza_antet "LABORATOR: CREAREA FISIERELOR DE LUCRU"

    print_info "Curatam mediul si pregatim spatiul de lucru..."
    setup_fisiere > /dev/null

    echo -e "${ALB}1. Hai sa cream fisierul 'elevi.list'${RESET}"
    echo -e "${L_CYAN}Introdu pe rand cate un nume de elev. Scrie 'gata' sau '0' cand vrei sa te opresti.${RESET}"
    > "$DEMO/elevi.list"
    while true; do
        read -p "Nume elev: " nume_elev
        if [[ "${nume_elev,,}" == "gata" || "$nume_elev" == "0" || -z "$nume_elev" ]]; then break; fi
        echo "$nume_elev" >> "$DEMO/elevi.list"
    done
    print_out; echo "Fisierul elevi.list a fost populat!"

    pas_urmator
    echo -e "${ALB}2. Acum cream 'calificative.dat'${RESET}"
    echo -e "${L_CYAN}Introdu cate o nota (un numar). Scrie 'gata' sau '0' cand vrei sa te opresti.${RESET}"
    > "$DEMO/calificative.dat"
    while true; do
        read -p "Nota: " nota
        if [[ "${nota,,}" == "gata" || "$nota" == "0" || -z "$nota" ]]; then break; fi
        echo "$nota" >> "$DEMO/calificative.dat"
    done
    print_out; echo "Fisierul calificative.dat a fost populat!"

    pas_urmator
    echo -e "${ALB}3. Ultimul fisier: 'text_test.txt'${RESET}"
    echo -e "${L_CYAN}Scrie 2-3 randuri de text (apasa Enter dupa fiecare). Scrie 'gata' pe un rand nou la final.${RESET}"
    > "$DEMO/text_test.txt"
    while true; do
        read -p "Rand text: " rand_text
        if [[ "${rand_text,,}" == "gata" || "$rand_text" == "0" || -z "$rand_text" ]]; then break; fi
        echo "$rand_text" >> "$DEMO/text_test.txt"
    done
    print_out; echo "Fisierul text_test.txt a fost populat!"

    echo -e "\n${L_GREEN}>> Toate fisierele tale au fost create! Acum poti folosi celelalte optiuni din meniu. <<${RESET}"
    pauza
}

modul_fisiere_directoare() {
    verifica_fisiere || return
    clear
    afiseaza_antet "OPERATIUNI DE BAZA: FISIERE SI DIRECTOARE"

    echo -e "${ALB}1. Afisare locatie de lucru (pwd):${RESET}"
    print_out; pwd

    pas_urmator
    echo -e "${ALB}2. Creare structura de foldere (mkdir -p):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: mkdir -p $DEMO/zona_test/subfolder1 $DEMO/zona_test/subfolder2${RESET}"
    mkdir -p "$DEMO/zona_test/subfolder1" "$DEMO/zona_test/subfolder2"
    print_out; ls -la "$DEMO/zona_test/"

    pas_urmator
    echo -e "${ALB}3. Generare fisiere goale (touch):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: touch $DEMO/zona_test/fisier1.tmp $DEMO/zona_test/fisier2.tmp${RESET}"
    touch "$DEMO/zona_test/fisier1.tmp" "$DEMO/zona_test/fisier2.tmp"
    print_out; ls -lh "$DEMO/zona_test/"

    pas_urmator
    echo -e "${ALB}4. Multiplicare fisier (cp):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: cp $DEMO/elevi.list $DEMO/zona_test/copie_elevi.list${RESET}"
    cp "$DEMO/elevi.list" "$DEMO/zona_test/copie_elevi.list"
    print_out; ls -lh "$DEMO/zona_test/"

    pas_urmator
    echo -e "${ALB}5. Redenumire / Mutare (mv):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: mv $DEMO/zona_test/fisier1.tmp $DEMO/zona_test/fisier_mutat.txt${RESET}"
    mv "$DEMO/zona_test/fisier1.tmp" "$DEMO/zona_test/fisier_mutat.txt"
    print_out; ls -lh "$DEMO/zona_test/"

    pas_urmator
    echo -e "${ALB}6. Stergere fisier (rm):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: rm $DEMO/zona_test/fisier2.tmp${RESET}"
    rm "$DEMO/zona_test/fisier2.tmp"
    print_out; ls -lh "$DEMO/zona_test/"

    pas_urmator
    echo -e "${ALB}7. Eliminare folder gol (rmdir):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: rmdir $DEMO/zona_test/subfolder2${RESET}"
    rmdir "$DEMO/zona_test/subfolder2"
    print_out; ls "$DEMO/zona_test/"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Navigare (cd) <<${RESET}"
    while true; do
        read -p "Unde ai vrea sa navigam temporar? (ex: /etc, /var/log) sau '0' pt iesire: " nav_user
        if [[ "$nav_user" == "0" ]]; then break; fi

        if [ -d "$nav_user" ]; then
            cd "$nav_user"
            print_info "Suntem acum in: $(pwd)"
            print_out; ls -lh 2>/dev/null | head -8
            cd - > /dev/null
            print_info "Am revenit in: $(pwd)"
        else
            echo -e "${L_RED}Eroare: Calea '$nav_user' nu exista sau nu este director!${RESET}"
        fi
        echo ""
    done
}

modul_citire_texte() {
    verifica_fisiere || return
    clear
    afiseaza_antet "VIZUALIZAREA CONTINUTULUI (cat, head, tail)"

    print_info "Analizam fisierul creat de tine: $DEMO/elevi.list"

    echo -e "${ALB}1. Afisare completa a textului (cat):${RESET}"
    print_out; cat "$DEMO/elevi.list"

    pas_urmator
    echo -e "${ALB}2. Afisare in ordine inversa a liniilor (tac):${RESET}"
    print_out; tac "$DEMO/elevi.list"

    pas_urmator
    echo -e "${ALB}3. Afisare cu numerotarea randurilor (nl):${RESET}"
    print_out; nl "$DEMO/elevi.list"

    pas_urmator
    echo -e "${ALB}4. Doar primele 2 randuri (head -2):${RESET}"
    print_out; head -2 "$DEMO/elevi.list"

    pas_urmator
    echo -e "${ALB}5. Doar ultimele 3 randuri (tail -3):${RESET}"
    print_out; tail -3 "$DEMO/elevi.list"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Extragere text <<${RESET}"
    while true; do
        read -p "Cate linii doresti sa vizualizezi de la inceputul listei? (sau '0' pt iesire): " linii_alese
        if [[ "$linii_alese" == "0" ]]; then break; fi

        print_out
        head -"$linii_alese" "$DEMO/elevi.list" 2>/dev/null || echo -e "${L_RED}Valoare introdusa este invalida!${RESET}"
        echo ""
    done
}

modul_arhivare_compresie() {
    verifica_fisiere || return
    clear
    afiseaza_antet "COMPRESIE SI PACHETARE (tar, gzip, zip)"

    echo -e "${ALB}1. Creare pachet simplu (tar -cvf):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: tar -cvf $DEMO/pachet.tar -C $DEMO elevi.list calificative.dat${RESET}"
    tar -cvf "$DEMO/pachet.tar" -C "$DEMO" elevi.list calificative.dat 2>/dev/null
    print_out; ls -lh "$DEMO/pachet.tar"

    pas_urmator
    echo -e "${ALB}2. Despachetare (tar -xvf):${RESET}"
    mkdir -p "$DEMO/despachetat"
    echo -e "   ${L_CYAN}[CMD]: tar -xvf $DEMO/pachet.tar -C $DEMO/despachetat/${RESET}"
    tar -xvf "$DEMO/pachet.tar" -C "$DEMO/despachetat/" 2>/dev/null
    print_out; ls -lh "$DEMO/despachetat/"

    pas_urmator
    echo -e "${ALB}3. Creare arhiva comprimata cu gzip (tar -czvf):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: tar -czvf $DEMO/pachet_comprimat.tar.gz -C $DEMO elevi.list calificative.dat${RESET}"
    tar -czvf "$DEMO/pachet_comprimat.tar.gz" -C "$DEMO" elevi.list calificative.dat 2>/dev/null
    print_out; ls -lh "$DEMO/pachet.tar" "$DEMO/pachet_comprimat.tar.gz"
    print_info "Compara marimile: fisierul .tar.gz ocupa mai putin spatiu!"

    pas_urmator
    echo -e "${ALB}4. Compresie directa fisier (gzip):${RESET}"
    cp "$DEMO/text_test.txt" "$DEMO/text_pentru_zip.txt"
    echo -e "   ${L_CYAN}[CMD]: gzip $DEMO/text_pentru_zip.txt${RESET}"
    gzip "$DEMO/text_pentru_zip.txt"
    print_out; ls -lh "$DEMO/text_pentru_zip.txt.gz"

    pas_urmator
    echo -e "${ALB}5. Decompresie fisier (gunzip):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: gunzip $DEMO/text_pentru_zip.txt.gz${RESET}"
    gunzip "$DEMO/text_pentru_zip.txt.gz"
    print_out; ls -lh "$DEMO/text_pentru_zip.txt"

    pauza
}

modul_drepturi_acces() {
    clear
    afiseaza_antet "CONTROLUL ACCESULUI (chmod, chown)"

    SCRIPT_TEST="$DEMO/script_test.sh"
    echo '#!/bin/bash
echo "Salut din script!"' > "$SCRIPT_TEST"

    echo -e "${L_YELLOW}Explicatie format permisiuni:${RESET}"
    echo -e "${ALB}  drwxr-xr-x${RESET}"
    echo -e "  |  |  |  |"
    echo -e "  |  |  |  +-- Restul utilizatorilor: r-x (Citire+Executie) = 5"
    echo -e "  |  |  +----- Grupul proprietar:     r-x (Citire+Executie) = 5"
    echo -e "  |  +-------- Proprietarul fizic:    rwx (Tot)             = 7"
    echo -e "  +----------- Tip entitate: d (director), - (fisier), l (link)"
    echo -e "  ${L_CYAN}Valori numerice: Read=4, Write=2, eXecute=1${RESET}\n"

    echo -e "${ALB}1. Permisiuni implicite actuale (ls -la):${RESET}"
    print_out; ls -la "$SCRIPT_TEST"

    pas_urmator
    echo -e "${ALB}2. Setare mod standard text (chmod 644):${RESET}"
    chmod 644 "$SCRIPT_TEST"
    print_out; ls -la "$SCRIPT_TEST"

    pas_urmator
    echo -e "${ALB}3. Transformare in executabil (+x):${RESET}"
    chmod +x "$SCRIPT_TEST"
    print_out; ls -la "$SCRIPT_TEST"
    print_info "Fisierul poate fi rulat acum: ./script_test.sh"

    pas_urmator
    echo -e "${ALB}4. Ridicare drepturi de scriere (chmod -w):${RESET}"
    chmod -w "$SCRIPT_TEST"
    print_out; ls -la "$SCRIPT_TEST"
    chmod +w "$SCRIPT_TEST" # Restore

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Permisiuni Octale <<${RESET}"
    while true; do
        read -p "Tasteaza un cod numeric octal (ex: 777, 600, 755) sau '0' pt iesire: " cod_permisiune
        if [[ "$cod_permisiune" == "0" ]]; then break; fi

        if chmod "$cod_permisiune" "$SCRIPT_TEST" 2>/dev/null; then
            print_out; ls -la "$SCRIPT_TEST"
        else
            echo -e "${L_RED}Cod incorect sau format invalid!${RESET}"
        fi
        echo ""
    done
}

modul_cautare_sistem() {
    clear
    afiseaza_antet "INVESTIGATII IN SISTEM (find, whereis, which)"

    echo -e "${ALB}1. Cautare dupa extensie (find /etc -name '*.conf'):${RESET}"
    print_out; find /etc -name "*.conf" 2>/dev/null | head -4

    pas_urmator
    echo -e "${ALB}2. Cautare stricta a directoarelor (find /var/log -type d):${RESET}"
    print_out; find /var/log -type d 2>/dev/null | head -4

    pas_urmator
    echo -e "${ALB}3. Fisiere modificate in ultimele 5 minute (find /tmp -mmin -5):${RESET}"
    print_out; find /tmp -mmin -5 2>/dev/null | head -4

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Motorul Find <<${RESET}"
    while true; do
        read -p "Ce director analizam? (ex: /etc, /home) sau '0' pt iesire: " dir_cauta
        if [[ "$dir_cauta" == "0" ]]; then break; fi

        read -p "Ce tipar cautam? (ex: *.txt, *.sh): " pattern_cauta
        print_out
        find "$dir_cauta" -name "$pattern_cauta" 2>/dev/null | head -6
        echo -e "${L_PURPLE}  (Lista este scurtata la max 6 rezultate)${RESET}\n"
    done

    pas_urmator
    delim_mic
    echo -e "${ALB}Localizare Binare / Executabile (whereis, which, type):${RESET}"

    echo -e "\n${L_CYAN}>> whereis (Binare, surse, manuale)${RESET}"
    for cmd_test in cat grep bash; do
        echo "   whereis $cmd_test -> $(whereis "$cmd_test" 2>/dev/null)"
    done

    echo -e "\n${L_CYAN}>> which (Calea stricta a executabilului)${RESET}"
    for cmd_test in cat grep python3; do
        echo "   which $cmd_test -> $(which "$cmd_test" 2>/dev/null)"
    done

    pauza
}

modul_stocare_spatiu() {
    clear
    afiseaza_antet "MANAGEMENT STOCARE (df, du, mount)"

    echo -e "${ALB}1. Spatiul disponibil pe partitii (df -h):${RESET}"
    print_out; df -h | head -8

    pas_urmator
    echo -e "${ALB}2. Dimensiunea totala ocupata de un folder (du -sh /etc):${RESET}"
    print_out; du -sh /etc 2>/dev/null

    pas_urmator
    echo -e "${ALB}3. Top 6 fisiere ca marime din folderul curent:${RESET}"
    print_out; du -sh * 2>/dev/null | sort -hr | head -6

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Masurare Spatiu <<${RESET}"
    while true; do
        read -p "Ce director vrei sa cantaresti? (ex: /usr, /var) sau '0' pt iesire: " dir_marime
        if [[ "$dir_marime" == "0" ]]; then break; fi

        print_out
        du -sh "$dir_marime" 2>/dev/null || echo -e "${L_RED}Nu ai drepturi suficiente sau calea e gresita!${RESET}"
        echo ""
    done

    pas_urmator
    delim_mic
    echo -e "${L_YELLOW}Structura Discurilor (lsblk):${RESET}"
    print_out; lsblk 2>/dev/null | head -10

    pauza
}

modul_fluxuri_date() {
    verifica_fisiere || return
    clear
    afiseaza_antet "PIPES SI REDIRECTARI (>, >>, <, 2>, |)"

    echo -e "${ALB}1. Salvare rezultat in fisier, cu suprascriere (>):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: ls -lh $DEMO > $DEMO/rezultat_ls.txt${RESET}"
    ls -lh "$DEMO" > "$DEMO/rezultat_ls.txt"
    print_out; cat "$DEMO/rezultat_ls.txt" | head -4

    pas_urmator
    echo -e "${ALB}2. Adaugare text la finalul fisierului (>>):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: echo 'Jurnal actualizat' >> $DEMO/rezultat_ls.txt${RESET}"
    echo "Jurnal actualizat - $(date)" >> "$DEMO/rezultat_ls.txt"
    print_out; tail -3 "$DEMO/rezultat_ls.txt"

    pas_urmator
    echo -e "${ALB}3. Citire date din fisier (<):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: sort < $DEMO/elevi.list${RESET}"
    print_out; sort < "$DEMO/elevi.list"

    pas_urmator
    echo -e "${ALB}4. Izolarea mesajelor de eroare (2>):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: ls /folder_fals 2> $DEMO/log_erori.txt${RESET}"
    ls /folder_fals 2> "$DEMO/log_erori.txt"
    print_out; cat "$DEMO/log_erori.txt"

    pas_urmator
    delim_mic
    echo -e "${L_YELLOW}Inlantuirea comenzilor (PIPE: | )${RESET}"
    echo -e "${ALB}Exemplu: Combina cat + sort + head${RESET}"
    echo -e "   ${L_CYAN}[CMD]: cat $DEMO/elevi.list | sort | head -3${RESET}"
    print_out; cat "$DEMO/elevi.list" | sort | head -3

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Top Procese <<${RESET}"
    while true; do
        read -p "Cate dintre cele mai active procese afisam? (sau '0' pt iesire): " nr_proc
        if [[ "$nr_proc" == "0" ]]; then break; fi

        echo -e "   ${L_CYAN}[CMD]: ps aux | sort -k3 -rn | head -$nr_proc${RESET}"
        print_out
        ps aux | sort -k3 -rn | head -"$nr_proc" 2>/dev/null
        echo ""
    done
}

# ============================================================
# SUB-MENIU CAPITOLUL 3
# ============================================================
meniu_cap3() {
    while true; do
        clear
        afiseaza_antet "MODUL 3: GESTIUNE FISIERE"
        echo -e "${ALB}Alege experimentul pe care doresti sa-l rulezi:${RESET}"
        echo -e "${L_GREEN}1.${RESET} Preparare Mediu (Creare Fisiere Interactiv)"
        echo -e "${L_GREEN}2.${RESET} Operatiuni foldere/fisiere (mkdir, cp, mv, rm)"
        echo -e "${L_GREEN}3.${RESET} Vizualizare texte (cat, head, tail, nl)"
        echo -e "${L_GREEN}4.${RESET} Arhive si Compresii (tar, gzip, zip)"
        echo -e "${L_GREEN}5.${RESET} Drepturi de acces (chmod, chown)"
        echo -e "${L_GREEN}6.${RESET} Investigatii sistem (find, whereis, which)"
        echo -e "${L_GREEN}7.${RESET} Spatiu si Discuri (df, du, mount)"
        echo -e "${L_GREEN}8.${RESET} Conducte de date si Redirectari (|, >, >>)"
        echo -e "${L_RED}0. REVENIRE LA MENIUL PRINCIPAL${RESET}"
        delim_mic

        read -p "Selecteaza o sectiune (0-8): " optiune_cap3

        case $optiune_cap3 in
            1) modul_pregatire_fisiere ;;
            2) modul_fisiere_directoare ;;
            3) modul_citire_texte ;;
            4) modul_arhivare_compresie ;;
            5) modul_drepturi_acces ;;
            6) modul_cautare_sistem ;;
            7) modul_stocare_spatiu ;;
            8) modul_fluxuri_date ;;
            0) break ;;
            *) echo -e "${L_RED}Selectie invalida! Incearca din nou.${RESET}"; sleep 1.5 ;;
        esac
    done
}
