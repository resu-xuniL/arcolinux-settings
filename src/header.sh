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
    printf "\n${RED}${BOLD}${BLINK}%s${RESET} ${RED}%s ${BOLD}%s${RESET} ${RED}%s ${BOLD}%s ${BLINK}%s${RESET}\n" "/!\\" "THIS SCRIPT WILL MAKE" "CHANGES" "TO" "SYSTEM !" "/!\\"
    printf "\n%s\n" "Some steps may take longer, depending on your Internet connection and CPU."
}