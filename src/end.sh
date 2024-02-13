endscript() {
    local -r end_time="$(date +%s)"
    local -r duration="$((${end_time} - ${1}))"

    log_msg "\nAll done in ${GREEN}${duration}${RESET} seconds."

    prompt_choice "${BLUE}:: ${RESET}Do you want to upload the log file to a pastebin?" false
    if [[ ${answer} == true ]]; then
        log_msg "${GREEN}[+]${RESET} Uploading log file to [${GREEN}pastebin${RESET}] ... ${GREEN}\u2713${RESET}"
        local -r url="$(curl -s -F'file=@'"${LOG_FILE}" -Fexpires=1 https://0x0.st)"
        log_msg "${GREEN}[OK]${RESET} Log file uploaded to [${GREEN}${url}${RESET}] ${GREEN}\u2713${RESET}"
    fi

    if [[ ${NOREBOOT} == "true" ]]; then
        printf "%s\n\n" "${GREEN}Script completed successfully.${RESET}"
        exit 0
    fi

    printf "\n%s\n\n" "${BLUE}:: ${RESET}${GREEN}Script completed successfully, ${BB}the system must restart !${RESET}"
    read -rp "Press [${GREEN}Enter${RESET}] to restart or [${RED}Ctrl+C${RESET}] to cancel."
    for i in {10..1}; do
        printf "%s\r" "${GREEN}Restarting in ${i} seconds...${RESET}"
        sleep 1
    done

    restore_xfce_terminal_display
    reboot
}