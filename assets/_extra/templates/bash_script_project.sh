#!/bin/bash

source ../src/init.sh
source ../src/cmd.sh
source ../src/cmd_main.sh

start_time="$(date +%s)"
LOG_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/logfile_$(date "+%Y%m%d-%H%M%S").log"

init_log
exec_log "find $INSTALL_DIRECTORY -type f -exec chmod 644 -- {} +" "${GREEN}[+]${RESET} Changing permissions on [${YELLOW}configuration${RESET}] files"
 
prompt_to_continue

##################################################################################################################








##################################################################################################################
# clean_up() {
#     rm *.log
#     exit 0
# }
rm ${LOG_FILE}; printf "%s %b\n" "${RED}[-]${RESET} Deleting log file" "${GREEN}\u2713${RESET}"
