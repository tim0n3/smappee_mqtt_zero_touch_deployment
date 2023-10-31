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

        sudo useradd  -m -d /home/websocket websocket -r -s /bin/bash
        sudo useradd  -m -d /home/cachemanager cachemanager -r -s /bin/bash

        check_error "Failed to create smappee_mqtt user"
}

create_user_home_dir() {
        # Create the /var/smappee_mqtt directory and set permissions

        log "Creating /var/smappee_mqtt directory and setting permissions"

        sudo mkdir -p /var/smappee_mqtt

        check_error "Failed to create /var/smappee_mqtt directory"

        sudo chown -R smappee_mqtt:smappee_mqtt /var/smappee_mqtt
        check_error "Failed to set permissions for /var/smappee_mqtt"
        usermod -aG smappee_mqtt dustin
        check_error "Failed to add to the smappe_mqtt group for user Dustin"
        #usermod -aG smappee_mqtt tim_forbes
        #check_error "Failed to add to the smappe_mqtt group for user Dustin"
        chmod 777 /var/smapee_mqtt
}

clone_repo() {
        # Clone the repository

        log "Cloning the smappee_mqtt repository"

        cd /var/smappee_mqtt

        check_error "Failed to change directory to /var/smappee_mqtt"

        git clone git@github.com:epicdev-za/smappee_mqtt.git /var/smappee_mqtt

        check_error "Failed to clone the repository"

        git checkout dev

        check_error "Failed to switch to the 'dev' branch"
}


install_node_dependancies() {
        # Install npm dependencies

        log "Installing npm dependencies"

        cd /var/smappee_mqtt

        check_error "Failed to change directory to smappee_mqtt"

        npm install

        check_error "Failed to install npm dependencies"
}


create_services() {
        # Copy the systemd service file

        log "Copying systemd service file"

        sudo cp smappee_mqtt.service /etc/systemd/system/smappee_mqtt.service

        check_error "Failed to copy systemd service file"



        # Enable and start the systemd service

        log "Enabling and starting smappee_mqtt service"

        sudo systemctl enable smappee_mqtt.service

        check_error "Failed to enable smappee_mqtt service"

        sudo systemctl start smappee_mqtt.service

        check_error "Failed to start smappee_mqtt service"
}

tail_logs() {
        # Monitor the service's journalctl logs

        log "Monitoring smappee_mqtt service logs"

        sudo journalctl -f -u smappee_mqtt.service
}

clean_up() {
        chmod 755 -R /var/smappee_mqtt
        check_error "Could not update folder permissions"
}

main() {
        # Setup user
        create_user ;
        #create_user_home_dir ;

        # Setup repos and dependencies
        clone_repo ;
        install_node_dependancies ;

        # Setup services
        create_services ;

        # cleanup
        clean_up ;
		
		# tail service
        tail_logs ;
}

