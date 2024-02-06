endscript() {
    local -r end_time="$(date +%s)"
    local -r duration="$((${end_time} - ${1}))"

    printf "\n%s\n" "All done in ${GREEN}${duration}${RESET} seconds."
    printf "%s\n" "All done in ${duration} seconds." >>"${LOG_FILE}"

    prompt_choice "${BLUE}:: ${RESET}Do you want to upload the log file to a pastebin?" false
    if [[ ${answer} == true ]]; then
        printf "%s\n" "${GREEN}[+]${RESET} Uploading log file to [${GREEN}pastebin${RESET}] ..."
        local -r url="$(curl -s -F 'file=@'"${LOG_FILE}" https://0x0.st)"
        printf "%s\n" "${GREEN}[OK]${RESET} Log file uploaded to [${GREEN}${url}${RESET}]"
    fi

    if [[ ${NOREBOOT} == "true" ]]; then
        ${GREEN}Script completed successfully.${RESET}; printf "\n"
        exit 0
    fi

    printf "\n%s\n" "${BLUE}:: ${RESET}${GREEN}Script completed successfully, ${BOLD}${BLINK}the system must restart !${RESET}"
    read -rp "Press [${GREEN}Enter${RESET}] to restart or [${RED}Ctrl+C${RESET}] to cancel."
    for i in {10..1}; do
        printf "%s\r" "${GREEN}Restarting in ${i} seconds...${RESET}"
        sleep 1
    done

    execute "xfconf-query -c xfce4-terminal -p /background-darkness -s 0.85" #"\n${GREEN}[+]${RESET} XFCE terminal : Restoring [${YELLOW}BACKGROUND DARKNESS${RESET}] to [${YELLOW}0.85${RESET}]"
    execute "xfconf-query -c xfce4-terminal -p /font-use-system -s true" #"${GREEN}[+]${RESET} XFCE terminal : Restoring use of system [${YELLOW}FONT${RESET}] to [${YELLOW}TRUE${RESET}]"

    reboot
}