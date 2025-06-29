#!/bin/bash

log_file_path="$(dirname "$0")/../logs"
log_file="$log_file_path/website-health.log"

time_stamp=$(date +"%d-%m-%Y_%H-%M-%S")

archive_path="$(dirname "$0")/../logs/website-archive-path"
archive_file="$archive_path/"$time_stamp.log""

mkdir -p "$archive_path"

file_size=$(du -k "$log_file" | cut -f1)

# if file size exceeds 15KB, rotate it
if [[ "$file_size" -gt 15 ]]; then
    echo "LogFile got above the size limit. Log File Rotated"
    mv "$log_file" "$archive_file"
    touch "$log_file"
    echo "New log file created at: $log_file"
fi

echo "$file_size KB"