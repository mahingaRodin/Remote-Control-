#!/bin/bash

# Load the configuration file (user, ip, password)
if [ -f config.cfg ]; then
    source config.cfg
else
    echo "Error: Configuration file 'config.cfg' not found. Exiting."
    exit 1
fi

# Custom logging function to record script activities
log_activity() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a project_audit.log
}

# Step 1: Install necessary applications if they are not already installed
ensure_applications_installed() {
    log_activity "Checking and installing required applications..."
    applications=("sshpass" "nmap" "whois" "tor" "proxychains4" "curl" "jq")
    for app in "${applications[@]}"; do
        if ! command -v "$app" &> /dev/null; then
            log_activity "$app is not installed. Installing..."
            sudo apt install -y "$app"
        else
            log_activity "$app is already installed."
        fi
    done
}

# Step 2: Check network anonymity
verify_network_anonymity() {
    log_activity "Checking network anonymity..."

    # Start Tor service if not running
    if ! systemctl is-active --quiet tor; then
        log_activity "Starting Tor service..."
        sudo systemctl start tor
        sudo systemctl enable tor
    fi

    # Retry proxychains anonymity check
    attempts_remaining=3
    while [ $attempts_remaining -gt 0 ]; do
        # Using ip-api.com for geolocation and setting User-Agent header
        spoofed_info=$(proxychains4 curl -s -A "Mozilla/5.0" "http://ip-api.com/json/")

        # Extract country and IP from JSON response
        spoofed_country=$(echo "$spoofed_info" | jq -r '.country')
        spoofed_ip=$(echo "$spoofed_info" | jq -r '.query')

        if [ -n "$spoofed_country" ] && [ -n "$spoofed_ip" ]; then
            log_activity "Network is anonymous. Spoofed Country: $spoofed_country, Spoofed IP: $spoofed_ip"
            return
        else
            log_activity "Retrying anonymity check ($attempts_remaining attempts left)..."
            sleep 5
            attempts_remaining=$((attempts_remaining - 1))
        fi
    done

    log_activity "Network connection is not anonymous after retries. Exiting."
    exit 1
}

# Step 3: Prompt for the address to scan
prompt_for_address() {
    read -p "Enter the address to scan: " target_address
    log_activity "Address to scan: $target_address"
}

# Step 4: Automatically connect to remote server and display server info
connect_and_show_server_info() {
    remote_server="$user@$ip"
    log_activity "Connecting to the remote server..."
    sshpass -p "$password" ssh -o StrictHostKeyChecking=no "$remote_server" << EOF
        echo "Server Country: \$(proxychains4 curl -s -A 'Mozilla/5.0' 'http://ip-api.com/json/' | jq -r '.country')"
        echo "Server IP: \$(proxychains4 curl -s -A 'Mozilla/5.0' 'http://ip-api.com/json/' | jq -r '.query')"
        echo "Server Uptime: \$(uptime -p)"
EOF
    log_activity "Remote server details displayed."
}

# Step 5: Perform Whois lookup and port scan on the specified address
execute_scans() {
    log_activity "Performing Whois lookup and port scan on $target_address..."
    whois "$target_address" > whois_results.txt
    nmap "$target_address" -oN nmap_results.txt
    log_activity "Whois results saved to whois_results.txt"
    log_activity "Nmap results saved to nmap_results.txt"
}

# Step 6: Save results and create a log for auditing
update_audit_log() {
    audit_log_file="data_collection.log"
    echo "$(date): Whois and Nmap data collected for $target_address" >> "$audit_log_file"
    log_activity "Log file updated: $audit_log_file"
}

# Main function to execute all steps
run_script() {
    ensure_applications_installed         # Step 1
    verify_network_anonymity              # Step 2
    prompt_for_address                    # Step 3
    connect_and_show_server_info          # Step 4
    execute_scans                        # Step 5
    update_audit_log                      # Step 6
}

# Execute main function
run_script
