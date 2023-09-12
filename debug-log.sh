# Path to the SSH log file
SSH_LOG_FILE="/var/log/auth.log"

# Function to list suspicious IPs from the SSH log within the last hour
list_suspicious_ips() {
    local ONE_HOUR_AGO=$(date -d '1 hour ago' +'%Y-%m-%dT%H:%M:%S')

    # Use awk to extract IPs from the log file
    SUSPICIOUS_IPS=($(awk -v one_hour_ago="$ONE_HOUR_AGO" '$1" "$2 >= one_hour_ago && /Failed password/ { for (i=1; i<=NF; i++) { if ($i == "from" && $(i-1) != "Invalid") { print $(i+1) } } }' "$SSH_LOG_FILE" | sort | uniq))

    echo "Suspicious IPs reported in the last hour:"
    for IP in "${SUSPICIOUS_IPS[@]}"; do
        echo "$IP"
    done
}

# Call the function to list suspicious IPs from the SSH log
list_suspicious_ips

