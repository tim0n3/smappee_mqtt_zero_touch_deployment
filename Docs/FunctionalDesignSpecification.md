# smappee_prod_mqtt_user_creation_boot_script.sh

## Overview

This Bash script is designed to automate the installation and configuration of the MeshCentral agent and set up a user (`smappee_mqtt`) on a Debian-based system. Additionally, the script checks for system updates, installs necessary packages, and logs relevant information for troubleshooting purposes.

## Prerequisites

- This script is intended for Debian-based systems.
- Ensure that the script is executed with root privileges (`sudo` or as the root user).

## Usage

```bash
sudo ./smappee_prod_mqtt_user_creation_boot_script.sh
```

## Features

### 1. Root Check

The script checks whether it is executed with root privileges. If not, it exits with an error message.

### 2. Logging

The `log()` function is responsible for logging messages to both the terminal (stderr) and a log file (`/var/log/smappee_mqtt_install.log`).

### 3. User Management

The script creates a user (`smappee_mqtt`) and adds it to the sudoers group.

- `create_user()`: Creates the `smappee_mqtt` user with the necessary configurations.
- `add_user_to_sudo()`: Adds the `smappee_mqtt` user to the sudoers group.

### 4. System Updates

The script checks for system updates, attempts to fix unmet dependencies, and upgrades packages.

- `check_and_install_updates()`: Checks for updates, fixes unmet dependencies if needed, and upgrades packages.

### 5. MeshCentral Agent Installation

The script installs the MeshCentral agent using a specified script.

- `install_meshcentral_agent()`: Downloads and installs the MeshCentral agent.

### 6. Additional Packages

The script installs additional packages (`nmap`, `neofetch`, `vnstat`, `mtr`, `screen`, `wget`, `curl`).

### 7. Force Install Option

The script checks for unmet dependencies and provides an option (`-f`) for force installation.

- `check_force_install()`: Checks for unmet dependencies and attempts to fix them with force install if the option is enabled.

## Logging

- Log files are stored in `/var/log/smappee_mqtt_install.log`.
- Standard output is logged to `/var/log/debian-package-updater/stdout.log`.
- Standard error is logged to `/var/log/debian-package-updater/stderr.log`.

## Notes

- Ensure that the script is executed in a secure environment.
- Review the log files for troubleshooting and status updates.
- Use the script at your own risk.

## License

This script is provided under the [MIT License](LICENSE).
