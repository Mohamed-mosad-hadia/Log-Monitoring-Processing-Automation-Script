#!/bin/bash

# ---------- Variables ---------- #
TODAY=$(date +%Y-%m-%d)
RAW_DIR=~/project_pipeline/logs/raw
PROCESSED_DIR=~/project_pipeline/logs/processed
REPORT_FILE=~/project_pipeline/reports/report_$TODAY.txt

mkdir -p "$RAW_DIR" "$PROCESSED_DIR" "$(dirname $REPORT_FILE)"

echo "===== Daily Monitoring Report ($TODAY) =====" | tee "$REPORT_FILE"

# ---------- Functions ---------- #

# Check Disk Usage
check_disk() {
    size=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo "Disk usage: $size%" | tee -a "$REPORT_FILE"

    if [ "$size" -gt 80 ]; then
        echo "⚠ WARNING: Disk usage above 80%!" | tee -a "$REPORT_FILE"
    else
        echo "✅ Disk usage is stable" | tee -a "$REPORT_FILE"
    fi
    echo "----------------------------------" | tee -a "$REPORT_FILE"
}

# Top Processes
top_processes() {
    echo "Top 5 processes by memory usage:" | tee -a "$REPORT_FILE"
    ps aux --sort=-%mem | head -n 6 | awk '{print $1,$2,$3,$4,$11}' | tee -a "$REPORT_FILE"
    echo "----------------------------------" | tee -a "$REPORT_FILE"
}

# Network Check
network_check() {
    echo "Checking network connection..." | tee -a "$REPORT_FILE"
    if ping -c 2 google.com > /dev/null 2>&1; then
        echo "✅ Network is ONLINE" | tee -a "$REPORT_FILE"
    else
        echo "❌ Network is DOWN! Exiting script." | tee -a "$REPORT_FILE"
        exit 1
    fi
    echo "----------------------------------" | tee -a "$REPORT_FILE"
}

# Process Logs by Type
process_logs() {
    echo "Processing Log Files..." | tee -a "$REPORT_FILE"

    for file in "$RAW_DIR"/*.log 2>/dev/null; do
        [ -e "$file" ] || { echo "No .log files found." | tee -a "$REPORT_FILE"; break; }

        case "$file" in
            *error*)
                log_type="error"
                echo "Error Log Found: $(basename "$file")" | tee -a "$REPORT_FILE"
                ;;
            *access*)
                log_type="access"
                echo "Access Log Found: $(basename "$file")" | tee -a "$REPORT_FILE"
                ;;
            *)
                log_type="general"
                echo "General Log Found: $(basename "$file")" | tee -a "$REPORT_FILE"
                ;;
        esac

        timestamp=$(date +%H-%M-%S)
        new_name="${log_type}_log_${TODAY}_${timestamp}.log"

        mv "$file" "$PROCESSED_DIR/$new_name"
        echo "Moved → $new_name" | tee -a "$REPORT_FILE"
    done

    echo "----------------------------------" | tee -a "$REPORT_FILE"
}

# Cleanup Old Logs
cleanup_logs() {
    echo "Cleaning logs older than 7 days..." | tee -a "$REPORT_FILE"
    find "$PROCESSED_DIR" -name "*.log" -mtime +7 -type f -exec rm {} \;
    echo "✅ Cleanup complete" | tee -a "$REPORT_FILE"
    echo "----------------------------------" | tee -a "$REPORT_FILE"
}

# ---------- Execute Script ---------- #
check_disk
top_processes
network_check
process_logs
cleanup_logs

echo "✅ Monitoring completed successfully!" | tee -a "$REPORT_FILE"
echo "==================================" | tee -a "$REPORT_FILE"
