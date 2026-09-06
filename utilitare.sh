#!/usr/bin/env bash

# ==========================================
# DEFINIRE CULORI
# ==========================================
L_RED='\033[1;31m'
L_GREEN='\033[1;32m'
L_YELLOW='\033[1;33m'
L_BLUE='\033[1;34m'
L_PURPLE='\033[1;35m'
L_CYAN='\033[1;36m'
ALB='\033[1;37m'
RESET='\033[0m'

# ==========================================
# CĂI ȘI DIRECTOARE
# ==========================================
TEMA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO="$TEMA_DIR/resurse_tema"

# ==========================================
# FUNCȚII DE DESIGN ȘI AFIȘAJ
# ==========================================
delim_mare() { echo -e "${L_PURPLE}======================================================${RESET}"; }
delim_mic()  { echo -e "${L_CYAN}------------------------------------------------------${RESET}"; }

afiseaza_antet() {
    echo ""
    echo -e "${L_BLUE}=== $1 ===${RESET}"
    delim_mic
}

print_out() {
    echo -e "${L_GREEN}>> OUTPUT EXECUTIE:${RESET}"
}

print_info() {
    echo -e "${L_YELLOW}[SISTEM]: $1${RESET}"
}

pauza() {
    echo ""
    delim_mare
    read -p "Apasa [Enter] pentru a continua..."
}

pas_urmator() {
    echo ""
    echo -e "${L_PURPLE}--- Apasa [Enter] pentru urmatorul exemplu ---${RESET}"
    read -s -n 1
    echo -e "\033[1A\033[K"
}

# ==========================================
# INIȚIALIZARE MEDIU DE LUCRU
# ==========================================
setup_fisiere() {
    print_info "Curatam mediul vechi si cream folderul de lucru..."
    
    rm -rf "$DEMO"
    
    mkdir -p "$DEMO"

    print_info "Directorul a fost creat cu succes in: $DEMO"
}
