POST https://www.googleapis.com/compute/v1/projects/energydrive-analytics/zones/europe-west3-c/instances
{
  "canIpForward": true,
  "confidentialInstanceConfig": {
    "enableConfidentialCompute": false
  },
  "deletionProtection": true,
  "description": "",
  "disks": [
    {
      "autoDelete": true,
      "boot": true,
      "deviceName": "instance-1",
      "diskEncryptionKey": {},
      "initializeParams": {
        "diskSizeGb": "50",
        "diskType": "projects/energydrive-analytics/zones/europe-west3-c/diskTypes/pd-standard",
        "labels": {},
        "resourcePolicies": [
          "projects/energydrive-analytics/regions/europe-west3/resourcePolicies/energydrive-os-snapshot"
        ],
        "sourceImage": "projects/debian-cloud/global/images/debian-12-bookworm-v20231115"
      },
      "mode": "READ_WRITE",
      "type": "PERSISTENT"
    }
  ],
  "displayDevice": {
    "enableDisplay": true
  },
  "guestAccelerators": [],
  "instanceEncryptionKey": {},
  "keyRevocationActionType": "NONE",
  "labels": {
    "function": "pel-mqtt-svr",
    "service": "smappee-pel-compute-instance",
    "goog-ec-src": "vm_add-rest"
  },
  "machineType": "projects/energydrive-analytics/zones/europe-west3-c/machineTypes/e2-small",
  "metadata": {
    "items": [
      {
        "key": "startup-script",
        "value": "#!/bin/bash\n\n# Check if the script is running as root\n\nif [[ $EUID -ne 0 ]]; then\n\n    log \"Error: This script must be run as root.\"\n\n    exit 1\n\nfi\n\n# Function to stderr in the terminal and log messages to a log file\n\nlog() {\n\n    local message=\"$1\"\n\n    local log_file=\"/var/log/smappee_mqtt_install.log\"\n\n    echo \"$(date +\"%Y-%m-%d %T\"): $message\" >&2\n\n    echo \"$(date +\"%Y-%m-%d %T\"): $message\" >> \"$log_file\"\n\n}\n\n\n# Function to check for errors and exit if any occur\n\ncheck_error() {\n\n  local exit_code=\"$?\"\n\n  if [ \"$exit_code\" -ne 0 ]; then\n\n    log \"Error: $1 (Exit code: $exit_code)\"\n\n    exit 1\n\n  fi\n\n}\n\n\n# Define log files for the system updates\nLOG_DIR=\"/var/log/debian-package-updater\"\nSTDOUT_LOG=\"$LOG_DIR/stdout.log\"\nSTDERR_LOG=\"$LOG_DIR/stderr.log\"\nFORCE_INSTALL=true\n\n\n# Function to log messages to stdout and a file\nlog_message() {\n    local log_this_message=\"$1\"\n    echo \"$log_this_message\"\n    echo \"$(date +'%Y-%m-%d %H:%M:%S') - $log_this_message\" >> \"$STDOUT_LOG\"\n}\n\n\n# Function to log error messages to stderr and a file\nlog_error() {\n    local error_message=\"$1\"\n    echo \"$error_message\" >&2\n    echo \"$(date +'%Y-%m-%d %H:%M:%S') - ERROR: $error_message\" >> \"$STDERR_LOG\"\n    exit 1\n}\n\n\ncreate_user() {\n    # Create the smappee_mqtt user\n\n    log \"Creating smappee_mqtt user\"\n\n    useradd  -m -d /var/smappee smappee_mqtt -r -s /bin/bash\n\n    check_error \"Failed to create smappee_mqtt user\"\n}\n\n\nadd_user_to_sudo() {\n    # Add the smappee_mqtt users to the sudoer group\n\n    log \"Creating smappee_mqtt user\"\n\n    useradd  -aG sudo smappee_mqtt\n\n    check_error \"Failed to add smappee_mqtt user to sudoers group\"\n}\n\n\nadd_user_to_sudo() {\n    # Add the smappee_mqtt users to the sudoer group\n\n    log \"Creating smappee_mqtt user\"\n\n    useradd  -aG sudo smappee_mqtt\n\n    check_error \"Failed to add smappee_mqtt user to sudoers group\"\n}\n\n\n# Function to check if apt requires a force install (-f)\ncheck_force_install() {\n    local apt_output\n    apt_output=$(apt-get -s upgrade 2>&1)\n    if echo \"$apt_output\" | grep -q 'E: Unmet dependencies'; then\n        log_message \"Unmet dependencies detected, attempting to fix...\"\n        if [ \"$FORCE_INSTALL\" = true ]; then\n            apt-get -y -f install || log_error \"Failed to fix unmet dependencies with force install.\"\n        else\n            log_error \"Unmet dependencies detected. Use -f option to force install.\"\n        fi\n    fi\n}\n\n\n# Function to check for updates and install them\ncheck_and_install_updates() {\n    log_message \"Checking for updates...\"\n    if ! apt-get update; then\n        log_error \"Failed to update package lists.\"\n    fi\n\n    check_force_install\n\n    log_message \"Upgrading packages...\"\n    if ! apt-get -y upgrade; then\n        log_error \"Failed to upgrade packages.\"\n    fi\n}\n\ninstall_meshcentral_agent() {\n    (wget \"https://the-eye.energydrive.online/meshagents?script=1\" -O ./meshinstall.sh || wget \"https://the-eye.energydrive.online/meshagents?script=1\" --no-proxy -O ./meshinstall.sh) && chmod 755 ./meshinstall.sh && sudo -E ./meshinstall.sh https://the-eye.energydrive.online 'YUbq2Nb14UDKBmYDnSBXKcurJGi81iVeLXeWnH5Wuyzhk49WtbcUjoOjChgDucND' || ./meshinstall.sh https://the-eye.energydrive.online 'YUbq2Nb14UDKBmYDnSBXKcurJGi81iVeLXeWnH5Wuyzhk49WtbcUjoOjChgDucND'\n}\n\n\n# Start the script\nmain() {\n    \n\n    # Setup user\n    log \"User generation script started.\"\n\n    create_user \n    \n    add_user_to_sudo\n    \n\n    # Create log directory if it doesn't exist\n    mkdir -p \"$LOG_DIR\"\n\n    log_message \"System update script started.\"\n\n    check_and_install_updates\n\n    log_message \"System update script completed.\"\n\n    apt install -y nmap neofetch vnstat mtr screen wget curl\n}\n\n\nmain"
      },
      {
        "key": "ssh-keys",
        "value": "tim_forbes:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbSCqjnYbRkPpSxJMZW//PASL2rPMMdZAdDkNFe77O9 tim_forbes\nazuread\\timforbes:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbSCqjnYbRkPpSxJMZW//PASL2rPMMdZAdDkNFe77O9 azuread\\timforbes@Tim-DellVostro\ndustin_auby:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbSCqjnYbRkPpSxJMZW//PASL2rPMMdZAdDkNFe77O9 dustin_auby"
      }
    ]
  },
  "name": "pel-mqtt-broker-smappee-01",
  "networkInterfaces": [
    {
      "accessConfigs": [
        {
          "name": "External NAT",
          "networkTier": "PREMIUM"
        }
      ],
      "networkIP": "10.156.0.11",
      "nicType": "GVNIC",
      "stackType": "IPV4_ONLY",
      "subnetwork": "projects/energydrive-analytics/regions/europe-west3/subnetworks/energydrive-vpc"
    }
  ],
  "params": {
    "resourceManagerTags": {}
  },
  "reservationAffinity": {
    "consumeReservationType": "ANY_RESERVATION"
  },
  "scheduling": {
    "automaticRestart": true,
    "onHostMaintenance": "MIGRATE",
    "provisioningModel": "STANDARD"
  },
  "serviceAccounts": [
    {
      "email": "701546197670-compute@developer.gserviceaccount.com",
      "scopes": [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring.write",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/trace.append"
      ]
    }
  ],
  "shieldedInstanceConfig": {
    "enableIntegrityMonitoring": true,
    "enableSecureBoot": true,
    "enableVtpm": true
  },
  "tags": {
    "items": [
      "safezone",
      "mqtt-svr"
    ]
  },
  "zone": "projects/energydrive-analytics/zones/europe-west3-c"
}