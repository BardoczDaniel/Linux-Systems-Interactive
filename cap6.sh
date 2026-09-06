#!/usr/bin/env bash

# ============================================================
# MODUL 6: NETWORKING SI COMUNICATII
# ============================================================

modul_conectivitate_retea() {
    clear
    afiseaza_antet "DIAGNOSTICARE RETEA SI INTERNET"

    echo -e "${ALB}1. Identificarea adreselor IP si interfetelor (ip addr):${RESET}"
    print_out
    ip addr show 2>/dev/null | grep -E "^[0-9]+:|inet " | head -10
    echo ""
	
    pas_urmator
    echo -e "${ALB}2. Tabela de rutare a sistemului (ip route):${RESET}"
    print_out
    ip route 2>/dev/null
    echo ""
    
    pas_urmator    
    echo -e "${ALB}3. Verificare porturi active / in asteptare (ss -tuln):${RESET}"
    echo -e "${L_PURPLE}  (Explicatie flag-uri: t=TCP, u=UDP, l=Listening, n=Numeric)${RESET}"
    print_out
    ss -tuln 2>/dev/null | head -12
    echo ""
	
    pas_urmator
    delim_mic
    echo -e "${L_YELLOW}Test Interactiv - Pachet ICMP (Ping)${RESET}"
    while true; do
    read -p "Unde trimitem pachetele de test? (ex: 8.8.8.8, yahoo.com) sau '0' pentru iesire: " adresa_ping
    if [[ "$adresa_ping" == "0" ]]; then break; fi
    echo -e "   ${L_CYAN}[CMD]: ping -c 4 $adresa_ping${RESET}"
    print_out
    ping -c 4 "$adresa_ping" 2>/dev/null || echo -e "${L_RED}Destinatia '$adresa_ping' este inaccesibila sau respinge ping-ul.${RESET}"
    echo ""
    done
	
    pas_urmator
    delim_mic
    echo -e "${L_YELLOW}Test Interactiv - Interogare servere DNS (nslookup)${RESET}"
    while true; do
	read -p "Tasteaza un domeniu web (ex: github.com, ubuntu.com) sau '0' pentru iesire: " adresa_dns
    	if [[ "$adresa_dns" == "0" ]]; then break; fi
	print_out
    nslookup "$adresa_dns" 2>/dev/null | head -8 || echo -e "${L_RED}(Eroare: Utilitarul 'dnsutils' nu este instalat)${RESET}"
    echo ""
    done

    pas_urmator
    delim_mic
    echo -e "${ALB}4. Test HTTP - Citirea antetelor web (curl):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: curl -I https://google.com${RESET}"
    print_out
    curl -sI --max-time 5 https://google.com 2>/dev/null | head -8 || \
        echo -e "${L_RED}(Pachetul 'curl' nu este prezent pe sistem sau nu exista acces la internet)${RESET}"

    pauza
}

# ============================================================
# SUB-MENIU CAPITOLUL 6
# ============================================================
meniu_cap6() {
    while true; do
        clear
        afiseaza_antet "MODUL 6: RETELISTICA"
        echo -e "${ALB}1.${RESET} Analiza si Conectivitate (IP, ping, porturi, DNS, curl)"
        echo -e "${L_RED}0. REVENIRE LA MENIUL PRINCIPAL${RESET}"
        delim_mic

        read -p "Selecteaza o sectiune (0-1): " optiune_cap6

        case $optiune_cap6 in
            1) modul_conectivitate_retea ;;
            0) break ;;
            *) echo -e "${L_RED}Selectie invalida! Incearca din nou.${RESET}"; sleep 1.5 ;;
        esac
    done
}
