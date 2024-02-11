declare -A step_list

selected_packages=""

set_step_list() {
    step_list=(
        [Init]="init_step"
        [Uninstall]="uninstall_step"
        [System update]="update_step"
        [Install]="install_step"
        [Configuration]="configuration_step"
        [End]="end_step"
    )
}
 

steps_selection() {
    action_type="steps"
    
    set_step_list

    select_from_list step_list "Choose step(s) to execute"

    local -r packages="${selected_packages}"

    selected_packages=""

    manage_lst "${packages}"
}