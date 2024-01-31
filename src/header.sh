header() {
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
    printf "\n%s\n" "${RED}${BOLD}${BLINK}This script will make changes to your system.${RESET}"
    printf "\n%s\n" "Some steps may take longer, depending on your Internet connection and CPU."
}