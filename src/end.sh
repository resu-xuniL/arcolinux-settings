endscript() {
    local -r end_time="$(date +%s)"
    local -r duration="$((${end_time} - ${1}))"

    printf "\n%s\n" "All done in ${GREEN}${duration}${RESET} seconds."
    printf "%s\n" "All done in ${duration} seconds." >>"${LOG_FILE}"

    exec_log "sudo sed -i -E 's/\\\n|\x1B\[[0-9;]*[JKmsu]|\x1B\(B//g' ${LOG_FILE}" "${GREEN}[+]${RESET} Removing [${YELLOW}ANSI code${RESET}] on [${YELLOW}${LOG_FILE}${RESET}] file"

    prompt_choice "${BLUE}:: ${RESET}Do you want to upload the log file to a pastebin?" false
    if [[ ${answer} == true ]]; then
        log_msg "${GREEN}[+]${RESET} Uploading log file to [${GREEN}pastebin${RESET}] ... ${GREEN}\u2713${RESET}"
        local -r url="$(curl -s -F'file=@'"${LOG_FILE}" -Fexpires=1 https://0x0.st)"
        log_msg "${GREEN}[OK]${RESET} Log file uploaded to [${GREEN}${url}${RESET}] ${GREEN}\u2713${RESET}"
    fi

    if [[ ${NOREBOOT} == "true" ]]; then
        printf "%b\n\n" "${GREEN}Script completed successfully.${RESET}"
        exit 0
    fi

    printf "\n%s\n\n" "${BLUE}:: ${RESET}${GREEN}Script completed successfully, ${BOLD}${BLINK}the system must restart !${RESET}"
    read -rp "Press [${GREEN}Enter${RESET}] to restart or [${RED}Ctrl+C${RESET}] to cancel."
    for i in {10..1}; do
        printf "%s\r" "${GREEN}Restarting in ${i} seconds...${RESET}"
        sleep 1
    done

    exec_log "xfconf-query -c xfce4-terminal -p /background-darkness -s 0.85" "${GREEN}[+]${RESET} XFCE terminal : Restoring [${YELLOW}BACKGROUND DARKNESS${RESET}] to [${YELLOW}0.85${RESET}]"
    exec_log "xfconf-query -c xfce4-terminal -p /font-use-system -s true" "${GREEN}[+]${RESET} XFCE terminal : Restoring use of system [${YELLOW}FONT${RESET}] to [${YELLOW}TRUE${RESET}]"

    reboot
}