#!/usr/bin/env bash

# ============================================================
# MODUL 5: RESURSE HARDWARE SI PACHETE SOFTWARE
# ============================================================

modul_info_componente() {
    clear
    afiseaza_antet "DIAGNOSTICARE HARDWARE SI KERNEL"

    echo -e "${ALB}1. Analiza Memoriei RAM (free):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: free -h (Format usor de citit)${RESET}"
    print_out; free -h

    pas_urmator
    echo -e "${ALB}2. Detalii despre Procesor (lscpu):${RESET}"
    print_out
    lscpu | grep -E "Model name|CPU\(s\)|Thread|Core|Socket|MHz|Architecture" | head -10

    pas_urmator
    echo -e "${ALB}3. Informatii Sistem si Kernel (uname):${RESET}"
    print_out
    echo -e ">> Amprenta totala (uname -a): $(uname -a)"
    echo -e ">> Versiune nucleu (uname -r): $(uname -r)"
    echo -e ">> Arhitectura hardware (uname -m): $(uname -m)"

    pas_urmator
    echo -e "${ALB}4. Fisiere virtuale din sistemul /proc:${RESET}"
    echo -e "   ${L_CYAN}[CMD]: cat /proc/cpuinfo (extrase primele rânduri)${RESET}"
    cat /proc/cpuinfo | grep -E "model name|cpu MHz|cache size" | head -4
    echo -e "   ${L_CYAN}[CMD]: cat /proc/meminfo (extrase primele rânduri)${RESET}"
    cat /proc/meminfo | head -5

    pas_urmator
    echo -e "${ALB}5. Inspectarea porturilor si magistralelor (PCI / USB):${RESET}"
    print_out
    echo -e "${L_YELLOW}>> Dispozitive PCI (lspci):${RESET}"
    lspci 2>/dev/null | head -4 || echo -e "${L_RED}(Utilitarul pciutils nu este instalat)${RESET}"
    echo -e "${L_YELLOW}>> Dispozitive USB (lsusb):${RESET}"
    lsusb 2>/dev/null | head -4 || echo -e "${L_RED}(Utilitarul usbutils nu este instalat)${RESET}"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Investigare Componente <<${RESET}"
    while true; do
        read -p "Ce componenta cauti in sistem? (ex: VGA, Audio, Network) sau '0' pt iesire: " hw_cautat
        if [[ "$hw_cautat" == "0" ]]; then break; fi

        print_out
        echo -e "${L_CYAN}[Rezultate PCI]:${RESET}"
        lspci 2>/dev/null | grep -i "$hw_cautat" || echo "Nu s-au gasit intrari in PCI."
        echo -e "${L_CYAN}[Rezultate USB]:${RESET}"
        lsusb 2>/dev/null | grep -i "$hw_cautat" || echo "Nu s-au gasit intrari in USB."
        echo ""
    done
}

modul_gestiune_software() {
    clear
    afiseaza_antet "MANAGEMENTUL APLICATIILOR (APT & DPKG)"

    echo -e "${ALB}1. Lista pachetelor instalate in sistem (dpkg):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: dpkg --list | grep '^ii'${RESET}"
    print_out
    dpkg --list | grep "^ii" | head -8
    echo "  ..."
    print_info "Numarul total de aplicatii instalate: $(dpkg --list | grep '^ii' | wc -l)"

    pas_urmator
    echo -e "${ALB}2. Cautare utilitare instalate (apt list):${RESET}"
    echo -e "   ${L_CYAN}[CMD]: apt list --installed | grep python${RESET}"
    print_out
    apt list --installed 2>/dev/null | grep python | head -5

    pas_urmator
    delim_mic
    echo -e "${L_YELLOW}Sintaxe esentiale pentru Administratori (Necesita Sudo):${RESET}"
    echo -e "${ALB}  sudo apt update${RESET}          -> Descarca lista noua cu versiunile programelor"
    echo -e "${ALB}  sudo apt upgrade${RESET}         -> Instaleaza actualizarile disponibile"
    echo -e "${ALB}  sudo apt install [nume]${RESET}  -> Instaleaza un program nou"
    echo -e "${ALB}  sudo apt remove [nume]${RESET}   -> Dezinstaleaza un program"
    echo -e "${ALB}  sudo apt autoremove${RESET}      -> Curata dependentele ramase in urma"

    echo ""; delim_mic
    echo -e "${L_YELLOW}>> LABORATOR INTERACTIV: Gestiune Pachete APT <<${RESET}"
    print_info "Poti cauta pachete in baza de date si poti cere detalii complete despre ele."

    while true; do
        read -p "Introdu numele unui pachet (ex: nginx, htop, curl) sau '0' pt iesire: " pachet_cautat
        if [[ "$pachet_cautat" == "0" ]]; then break; fi

        print_out
        echo -e "${L_CYAN}>> Rezultate cautare (apt search $pachet_cautat):${RESET}"
        apt search "$pachet_cautat" 2>/dev/null | head -8
        echo -e "${L_PURPLE}  (Lista a fost scurtata pentru vizibilitate)${RESET}"

        echo ""
        read -p "-> Doresti sa vezi fisa tehnica completa pentru '$pachet_cautat'? (y/n): " rasp_show
        if [[ "${rasp_show,,}" == "y" ]]; then
            print_out
            echo -e "${L_CYAN}[CMD]: apt show $pachet_cautat${RESET}"
            apt show "$pachet_cautat" 2>/dev/null | head -15
        fi
        echo ""
    done
}

# ============================================================
# SUB-MENIU CAPITOLUL 5
# ============================================================
meniu_cap5() {
    while true; do
        clear
        afiseaza_antet "MODUL 5: HARDWARE SI SOFTWARE"
        echo -e "${ALB}Alege experimentul pe care doresti sa-l rulezi:${RESET}"
        echo -e "${L_GREEN}1.${RESET} Resurse Fizice (Procesor, RAM, Dispozitive conectate)"
        echo -e "${L_GREEN}2.${RESET} Baza de Pachete (Instalare, actualizare, cautare cu apt)"
        echo -e "${L_RED}0. REVENIRE LA MENIUL PRINCIPAL${RESET}"
        delim_mic

        read -p "Selecteaza o sectiune (0-2): " optiune_cap5

        case $optiune_cap5 in
            1) modul_info_componente ;;
            2) modul_gestiune_software ;;
            0) break ;;
            *) echo -e "${L_RED}Selectie invalida! Incearca din nou.${RESET}"; sleep 1.5 ;;
        esac
    done
}
