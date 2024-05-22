usage() {
    printf "\n%s\n" "Usage : ./settings.sh [OPTION(s)]"
    printf "\n%s\n" "Options :"
    printf "%s\n" "  -h --help      : Display this help."
    printf "%s\n" "  -t --test      : Test mode."
    printf "%s\n" "  -g --gui       : Test mode with GUI selection."
    printf "%s\n" "  -f --force     : Force extra-installation."
    printf "%s\n" "  -i --install   : Install step only"
    printf "%s\n" "  -u --uninstall : Uninstall step only"
    printf "%s\n" "  -c --config    : configuration step only"
    printf "%s\n" "  -v --verbose   : Verbose mode."
    printf "%s\n" "  -n --no-log    : Delete log file."
    printf "%s\n" "  --no-clear     : Do not clear display between steps"
    printf "%s\n" "  --no-reboot    : Do not reboot the system at the end of the script."
}

valid_args=$(getopt -o htgfiucnv --long help,test,gui,force,install,uninstall,config,verbose,no-log,no-clear,no-reboot -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$valid_args"
while [ : ]; do
  case "$1" in
    -h | --help)
        usage
        exit 1
        ;;
    -t | --test)
        export TESTMODE=true
        export NOREBOOT=true
        shift
        ;;
    -g | --gui)
        export GUIMODE=true
        export NOREBOOT=true
        shift
        ;;
    -f | --force)
        export FORCEMODE=true
        shift
        ;;
    -i | --install)
        export INSTALLMODE=true
        shift
        ;;
    -u | --uninstall)
        export UNINSTALLMODE=true
        shift
        ;;
    -c | --config)
        export CONFIGMODE=true
        shift
        ;;
    -v | --verbose)
        export VERBOSE=true
        shift
        ;;
    -n | --no-log)
        export NOLOG=true
        shift
        ;;
    --no-clear)
        export NOCLEAR=true
        shift
        ;;
    --no-reboot)
        export NOREBOOT=true
        shift
        ;;
    --) shift; 
        break 
        ;;
  esac
done

if [[ -z ${TESTMODE+x} ]]; then
    export TESTMODE=false
fi

if [[ -z ${GUIMODE+x} ]]; then
    export GUIMODE=false
fi

if [[ -z ${FORCEMODE+x} ]]; then
    export FORCEMODE=false
fi

if [[ -z ${INSTALLMODE+x} ]]; then
    export INSTALLMODE=false
fi

if [[ -z ${UNINSTALLMODE+x} ]]; then
    export UNINSTALLMODE=false
fi

if [[ -z ${CONFIGMODE+x} ]]; then
    export CONFIGMODE=false
fi

if [[ -z ${VERBOSE+x} ]]; then
    export VERBOSE=false
fi

if [[ -z ${NOLOG+x} ]]; then
    export NOLOG=false
fi

if [[ -z ${NOCLEAR+x} ]]; then
    export NOCLEAR=false
fi
if [[ -z ${NOREBOOT+x} ]]; then
    export NOREBOOT=false
fi