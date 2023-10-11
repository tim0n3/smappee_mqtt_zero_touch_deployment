# Technical Design Specification

## Script Overview
The provided Bash script is designed to automate the installation and setup of the "smappee_mqtt" service. This script performs several tasks, including creating a system user, setting up the necessary directories, cloning a Git repository, installing Node.js dependencies, creating and configuring systemd services, and monitoring the service's logs.

Below is a technical design specification that outlines the key components of the script and their functionalities.

## Script Purpose
The script automates the installation and setup of the "smappee_mqtt" service, which may be related to monitoring and communicating with Smappee devices.

## Functions

### `log()`
- **Purpose**: Log messages to standard error (stderr) and a log file.
- **Input**: `message` (string) - The message to log.
- **Log File**: `/var/log/smappee_mqtt_install.log`

### `check_error()`
- **Purpose**: Check for errors in the previous command's exit code and exit the script if an error occurs.
- **Input**: None
- **Exit**: Exits the script if an error is detected.

### `create_user()`
- **Purpose**: Create the "smappee_mqtt" system user with restricted privileges.
- **Steps**:
  1. Create the user using `useradd`.
  2. Add the user to the "smappee_mqtt" group.
- **Exit**: Exits the script on failure to create the user.

### `create_user_home_dir()`
- **Purpose**: Create the `/var/smappee_mqtt` directory and set permissions.
- **Steps**:
  1. Create the directory.
  2. Set ownership to the "smappee_mqtt" user and group.
  3. Add the "dustin" user to the "smappee_mqtt" group.
- **Exit**: Exits the script on any failure during these steps.

### `clone_repo()`
- **Purpose**: Clone the "smappee_mqtt" Git repository and switch to the 'dev' branch.
- **Steps**:
  1. Change the working directory to `/var/smappee_mqtt`.
  2. Clone the Git repository from GitHub.
  3. Switch to the 'dev' branch.
- **Exit**: Exits the script on any failure during these steps.

### `install_node_dependancies()`
- **Purpose**: Install Node.js dependencies for the "smappee_mqtt" service.
- **Steps**:
  1. Change the working directory to `/var/smappee_mqtt`.
  2. Install Node.js dependencies using `npm install`.
- **Exit**: Exits the script on failure to install Node.js dependencies.

### `create_services()`
- **Purpose**: Configure and start the systemd service for "smappee_mqtt."
- **Steps**:
  1. Copy the systemd service file to `/etc/systemd/system`.
  2. Enable and start the systemd service.
- **Exit**: Exits the script on any failure during these steps.

### `tail_logs()`
- **Purpose**: Monitor the journalctl logs of the "smappee_mqtt" service.
- **Steps**:
  1. Display logs using `journalctl -f -u smappee_mqtt.service`.
- **Exit**: No explicit exit point.

### `clean_up()`
- **Purpose**: Update permissions on `/var/smappee_mqtt` to make it more secure.
- **Steps**:
  1. Change permissions on the directory to 755.
- **Exit**: Exits the script if it fails to update folder permissions.

### `main()`
- **Purpose**: The main function that orchestrates the setup process.
- **Steps**:
  1. Create the system user and home directory.
  2. Clone the repository and install Node.js dependencies.
  3. Create and configure systemd services.
  4. Perform clean-up tasks.
  5. Monitor service logs.

## Script Execution
The script should be executed as the root user. It can be run by invoking the `main()` function, which performs the entire installation and setup process.

## Pre-requisites
1. The script should be executed with root privileges.
2. Git and Node.js (and npm) should be installed on the system before running this script.

## Logging
The script logs messages to stderr and a log file located at `/var/log/smappee_mqtt_install.log`.

## Recommendations
1. Make sure that Git and Node.js are correctly installed on the system.
2. It is important to review and test the script on a non-production system before running it in a production environment.
3. Secure the log file and script to prevent unauthorized access.

This technical design specification outlines the functionality and purpose of the provided script. It is important to thoroughly test the script on your specific system and understand its implications before running it in a production environment.