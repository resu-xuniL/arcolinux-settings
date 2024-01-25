function endscript() {
    local -r end_time="$(date +%s)"
    local -r duration="$((${end_time} - ${1}))"

    echo -e "\nAll done in ${GREEN}${duration}${RESET} seconds."
    echo -e "All done in ${duration} seconds." >>"${LOG_FILE}"

    if prompt_default_no "${BLUE}:: ${RESET}Do you want to upload the log file to a pastebin?"; then
        echo "${GREEN}[+]${RESET} Uploading log file to [${GREEN}pastebin${RESET}] ..."
        local -r url="$(curl -s -F 'file=@'"${LOG_FILE}" https://0x0.st)"
        echo "${GREEN}[OK]${RESET} Log file uploaded to [${GREEN}${url}${RESET}]"
    fi

    if [[ "${NOREBOOT}" == "true" ]]; then
        ${GREEN}Script completed successfully.${RESET}; echo
        exit 0
    fi

    echo -e "\n${BLUE}:: ${RESET}${GREEN}Script completed successfully, the system must restart !${RESET}"
    read -rp "Press [${GREEN}Enter${RESET}] to restart or [${RED}Ctrl+C${RESET}] to cancel."
    for i in {10..1}; do
        echo -ne "${GREEN}Restarting in ${i} seconds...${RESET}\r"
        sleep 1
    done

    execute "xfconf-query -c xfce4-terminal -p /background-darkness -s 0.85" #"${GREEN}[+]${RESET} Restoring XFCE terminal : set [${YELLOW}BACKGROUND DARKNESS${RESET}] to [${YELLOW}0.85${RESET}]"
    execute "xfconf-query -c xfce4-terminal -p /font-use-system -s true" #"${GREEN}[+]${RESET} Restoring XFCE terminal : Use system [${YELLOW}FONT${RESET}] set to [${YELLOW}TRUE${RESET}]"

    reboot
}