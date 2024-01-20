function endscript() {
    local -r end_time="$(date +%s)"
    local -r duration="$((${end_time} - ${1}))"

    echo -e "Done in ${GREEN}${duration}${RESET} seconds."
    echo -e "Done in ${duration} seconds." >>"${LOG_FILE}"

    if ask_question "Do you want to upload the log file to a pastebin?"; then
        echo "Uploading log file to pastebin..."
        local -r url="$(curl -s -F 'file=@'"${LOG_FILE}" https://0x0.st)"
        echo "Log file uploaded to ${url}"
    fi

    if [[ "${NOREBOOT}" == "true" ]]; then
        ${GREEN}Script completed successfully.${RESET}; echo
        exit 0
    fi

    read -rp "${GREEN}Script completed successfully, the system must restart${RESET}: Press [${GREEN}Enter${RESET}] to restart or [${RED}Ctrl+C${RESET}] to cancel."
    for i in {10..1}; do
        echo -ne "${GREEN}Restarting in ${i} seconds...${RESET}\r"
        sleep 1
    done

    reboot
}