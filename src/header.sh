function header() {
    clear
    cat <<-EOF
----------------------------------------------------------------------------------------------------

        ${PURPLE}##${RESET}                         ${GREEN}##${RESET} 
        ${PURPLE}##     ##${RESET}    ${GREEN}###    ###   ###${RESET} 
        ${PURPLE}##  #  ##${RESET}  ${GREEN}##   ##  #### ####${RESET}          Script configuration for ArcoLinux
        ${PURPLE}## ### ##${RESET} ${GREEN}##     ## ## ### ##${RESET} 
        ${PURPLE}#### ####${RESET} ${GREEN}######### ##  #  ##${RESET} 
        ${PURPLE}###   ###${RESET} ${GREEN}##     ## ##     ##${RESET}          https://github.com/resu-xuniL/arcolinux-settings
        ${PURPLE}##     ##${RESET} ${GREEN}##     ## ##     ##${RESET} 

----------------------------------------------------------------------------------------------------
EOF

    sleep 1
    printf "%b" "${RED}This script will make changes to your system.${RESET}\n"
    printf "%b" "Some steps may take longer, depending on your Internet connection and CPU.\nPress [${GREEN}Enter${RESET}] to continue, or [${RED}Ctrl+C${RESET}] to cancel."

    read -rp "" choice
    [[ -n $choice ]] && exit 0
}