#!/bin/bash



# Function to log messages to stderr and a log file

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



# Check if the script is running as root

if [[ $EUID -ne 0 ]]; then

  log "Error: This script must be run as root."

  exit 1

fi


create_user() {
        # Create the smappee_mqtt user

        log "Creating smappee_mqtt user"

        useradd  -m -d /var/websocket websocket -r -s /bin/bash
        useradd  -m -d /var/cachemanager cachemanager -r -s /bin/bash

        check_error "Failed to create smappee_mqtt user"
}



add_user_to_sudo() {
        # Add the smappee_mqtt users to the sudoer group

        log "Creating smappee_mqtt user"

        useradd  -aG websocket
        useradd  -aG cachemanager

        check_error "Failed to add smappee_mqtt user to sudoers group"
}



main() {
        # Setup user
        create_user ;
        add_user_to_sudo;
}

main