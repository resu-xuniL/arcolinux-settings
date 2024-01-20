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
    printf "%b" "\n${RED}This script will make changes to your system.${RESET}\n"
    printf "%b" "\nSome steps may take longer, depending on your Internet connection and CPU.\n"
}