# Smappee MQTT Installation Script

This Bash script is designed to automate the installation of the Smappee MQTT software on a Linux system. Mosquitto MQTT is a tool for interfacing with Smappee energy monitors and publishing their data to an MQTT broker.

## Prerequisites

Before running this script, please ensure you have the following prerequisites:

- A Linux-based system
- Root access or sudo privileges
- Git installed on your system
- Node.js and npm (Node Package Manager) installed on your system
- An MQTT broker (e.g., Mosquitto) installed and running on your system (optional)

## Usage

To install Smappee MQTT using this script, follow these steps:

1. **Clone the Repository**:

   First, clone this repository to your system using Git. Open your terminal and run the following command:

   ```bash
   git clone https://github.com/tim0n3/smappee_mqtt_zero_touch_deployment.git
   ```

2. **Change Directory**:

   Navigate to the cloned repository directory:

   ```bash
   cd smappee_mqtt
   ```

3. **Run the Script**:

   Make sure you have executed the script with root privileges or sudo:

   ```bash
   sudo bash smappee_zero_touch_deployment.sh
   ```

4. **Follow the On-Screen Instructions**:

   The script will guide you through the installation process, creating a system user, setting up directories, cloning the Smappee MQTT repository, installing dependencies, creating systemd services, and tailing the service logs.

5. **Monitoring Logs**:

   After installation, the script will start monitoring the logs for the Smappee MQTT service. You can view the logs by executing:

   ```bash
   sudo journalctl -f -u smappee_mqtt.service
   ```

6. **Cleanup**:

   The script will also perform some cleanup tasks, such as updating folder permissions.

## Note

- By default, this script assumes that the MQTT broker is running locally. If your MQTT broker is hosted on a different server or has custom configuration, make sure to modify the Smappee MQTT configuration accordingly after installation.

- You can customize the installation process by editing the `smappee_zero_touch_deployment.sh` script to suit your specific requirements.

- This script assumes that you have the necessary privileges to create system users, directories, and systemd services. Ensure that you have the appropriate permissions before running the script.

- This script is provided as-is and does not include error handling for all possible scenarios. Ensure that you have backups and understand the changes being made to your system before running the script.

## License

This script is provided under the [MIT License](LICENSE).