#!/usr/bin/env bash

# ============================================================
# MODUL 7: PROGRAMARE SI COMPILARE C (GCC)
# ============================================================

modul_compilator_gcc() {
    clear
    afiseaza_antet "PROCESUL DE COMPILARE C (GNU Compiler Collection)"

    ZONA_GCC="$DEMO/compilare_c"
    mkdir -p "$ZONA_GCC"
    SURSA_C="$ZONA_GCC/aplicatie.c"

    echo -e "${ALB}Generam fisierul sursa 'aplicatie.c'...${RESET}"
    cat > "$SURSA_C" << 'EOF'
#include <stdio.h>

int main(void) {
    printf("========================================\n");
    printf("  Salut din aplicatia compilata in C!\n");
    printf("  Mediul de executie: Terminal Linux\n");
    printf("========================================\n");
    return 0;
}
EOF
    echo -e "   ${L_CYAN}[CMD]: cat $SURSA_C${RESET}"
    print_out
    cat "$SURSA_C"

    pas_urmator
    delim_mic
    echo -e "${L_YELLOW}Etapele transformarii codului sursa in executabil:${RESET}"

    echo -e "\n${ALB}Pasul 1: Preprocesarea (gcc -E)${RESET}"
    print_info "Se rezolva directivele #include si macrourile."
    echo -e "   ${L_CYAN}[CMD]: gcc -E aplicatie.c -o aplicatie.i${RESET}"
    print_out
    if gcc -E "$SURSA_C" -o "$ZONA_GCC/aplicatie.i" 2>/dev/null; then
        echo "A fost generat fisierul preprocesat 'aplicatie.i'. Acesta are $(wc -l < "$ZONA_GCC/aplicatie.i") linii de cod (incluzand stdio.h)!"
    else
        echo -e "${L_RED}(Eroare: Compilatorul GCC nu este instalat. Ruleaza: sudo apt install gcc)${RESET}"
        pauza
        return
    fi

    pas_urmator
    echo -e "${ALB}Pasul 2: Traducerea in limbaj de Asamblare (gcc -S)${RESET}"
    print_info "Codul C este transformat in instructiuni specifice procesorului."
    echo -e "   ${L_CYAN}[CMD]: gcc -S aplicatie.c -o aplicatie.s${RESET}"
    print_out
    gcc -S "$SURSA_C" -o "$ZONA_GCC/aplicatie.s" 2>/dev/null
    echo "Fisierul assembly 'aplicatie.s' a fost creat. Primele 10 linii:"
    head -10 "$ZONA_GCC/aplicatie.s"
    echo "  ..."

    pas_urmator
    echo -e "${ALB}Pasul 3: Asamblarea in Cod Obiect (gcc -c)${RESET}"
    print_info "Se genereaza cod binar inteles de masina, dar fara legaturile externe."
    echo -e "   ${L_CYAN}[CMD]: gcc -c aplicatie.c -o aplicatie.o${RESET}"
    print_out
    gcc -c "$SURSA_C" -o "$ZONA_GCC/aplicatie.o" 2>/dev/null
    ls -lh "$ZONA_GCC/aplicatie.o"

    pas_urmator
    echo -e "${ALB}Pasul 4: Link-editarea si generarea Executabilului${RESET}"
    print_info "Se leaga fisierele obiect cu bibliotecile sistemului."
    echo -e "   ${L_CYAN}[CMD]: gcc aplicatie.c -o aplicatie_bin${RESET}"
    print_out
    gcc "$SURSA_C" -o "$ZONA_GCC/aplicatie_bin" 2>/dev/null
    echo -e "${L_GREEN}>> Executabilul 'aplicatie_bin' a fost creat cu succes!${RESET}"

    pas_urmator
    echo -e "${L_YELLOW}Test Executie Program:${RESET}"
    echo -e "   ${L_CYAN}[CMD]: ./aplicatie_bin${RESET}"
    print_out
    "$ZONA_GCC/aplicatie_bin"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Mini-IDE C <<${RESET}"
    while true; do
        read -p "Doresti sa scrii propriul cod C si sa-l compili acum? (y/n) sau '0' pt iesire: " optiune_cod
        if [[ "$optiune_cod" == "0" || "${optiune_cod,,}" == "n" ]]; then break; fi
        
        if [[ "${optiune_cod,,}" == "y" ]]; then
            echo -e "${L_CYAN}>> Tasteaza codul C. Cand ai terminat, scrie pe o linie noua cuvantul GATA.${RESET}"
            > "$ZONA_GCC/cod_utilizator.c"
            
            while read -r linie_cod; do
                if [ "$linie_cod" == "GATA" ]; then
                    break
                fi
                echo "$linie_cod" >> "$ZONA_GCC/cod_utilizator.c"
            done
            
            print_info "Compilam codul introdus..."
            if gcc "$ZONA_GCC/cod_utilizator.c" -o "$ZONA_GCC/executabil_utilizator" 2>/dev/null; then
                echo -e "${L_GREEN}>> Compilare finalizata fara erori fatale! Rulam executabilul:${RESET}"
                print_out
                "$ZONA_GCC/executabil_utilizator"
            else
                echo -e "${L_RED}>> EROARE DE COMPILARE! Verifica sintaxa codului scris.${RESET}"
            fi
        else
            echo -e "${L_RED}Optiune invalida.${RESET}"
        fi
        echo ""
    done
}

# ============================================================
# SUB-MENIU CAPITOLUL 7
# ============================================================
meniu_cap7() {
    while true; do
        clear
        afiseaza_antet "MODUL 7: PROGRAMARE C"
        echo -e "${ALB}Alege experimentul pe care doresti sa-l rulezi:${RESET}"
        echo -e "${L_GREEN}1.${RESET} Compilatorul GCC (Etape complete, Executie & Mini-IDE)"
        echo -e "${L_RED}0. REVENIRE LA MENIUL PRINCIPAL${RESET}"
        delim_mic
        
        read -p "Selecteaza o sectiune (0-1): " optiune_cap7
        
        case $optiune_cap7 in
            1) modul_compilator_gcc ;;
            0) break ;;
            *) echo -e "${L_RED}Selectie invalida! Incearca din nou.${RESET}"; sleep 1.5 ;;
        esac
    done
}
