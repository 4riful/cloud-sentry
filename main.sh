#!/bin/bash

# Cloud Sentry - Vigilant SNI Monitoring and Asset Enumeration

# Clear the screen before running
clear

# ASCII Art Logo with Colors
echo -e "\033[1;34m
█▀▀ █░░ █▀█ █░█ █▀▄   █▀ █▀▀ █▄░█ ▀█▀ █▀█ █▄█
█▄▄ █▄▄ █▄█ █▄█ █▄▀   ▄█ ██▄ █░▀█ ░█░ █▀▄ ░█░
\033[0m"

# Wholesome Acknowledgment
echo -e "\033[1;31m
🌟 A shitty work done by xettabyte 😵
\033[0m"
echo -e "\033[1;32m
🙌 Special thanks to the kaeferjaeger team for their amazing collective work and dedication!
\033[0m"

# Directory to store downloaded files
DOWNLOAD_DIR="sniranges"
OUTPUT_DIR="output"

# File to store the last execution time
LAST_EXECUTION_FILE="${OUTPUT_DIR}/last_execution_time.txt"

# Create directories if they don't exist
mkdir -p "$DOWNLOAD_DIR" "$OUTPUT_DIR"

# Advanced download and comparison function
download_and_compare() {
    local name=$1
    local url=$2
    local new_file="${DOWNLOAD_DIR}/${name}_new.txt"
    local old_file="${DOWNLOAD_DIR}/${name}.txt"

    echo -e "🚀  Downloading $name..."

    # Attempt to download the file with retries
    attempt=0
    max_attempts=5
    success=false

    while [[ $attempt -lt $max_attempts ]]; do
        curl -o "$new_file" --progress-bar "$url"
        if [[ $? -eq 0 ]]; then
            success=true
            break
        else
            echo -e "⚠️  Download failed. Retrying in 5 seconds... (Attempt $((attempt+1))/$max_attempts)"
            sleep 5
        fi
        attempt=$((attempt+1))
    done

    if [[ "$success" = true ]]; then
        echo -e "📥  Download completed."

        if [[ -f "$old_file" ]]; then
            old_size=$(stat -c%s "$old_file")
            new_size=$(stat -c%s "$new_file")

            if [[ $new_size -ne $old_size ]]; then
                mv "$new_file" "$old_file"
                echo -e "✅  $name updated (size: $((new_size / 1024)) KB)"
            else
                rm "$new_file"
                echo -e "⚖️  $name already up-to-date (size: $((old_size / 1024)) KB)"
            fi
        else
            mv "$new_file" "$old_file"
            echo -e "✅  $name downloaded (size: $(( $(stat -c%s "$old_file") / 1024 )) KB)"
        fi
    else
        echo -e "❌  Failed to download $name after $max_attempts attempts."
    fi
}

# Function to filter domains
filter_domains() {
    local domain=$1
    local output_file="${OUTPUT_DIR}/${domain}_subdomains.txt"

    echo -e "🔍  Filtering for domain: $domain..."
    
    # Filtering logic
    cat ${DOWNLOAD_DIR}/*.txt | grep -F "$domain" | awk -F'-- ' '{print $2}' | tr ' ' '\n' | tr '[' ' ' | sed 's/ //g' | sed 's/\]//g' | grep -F "$domain" | sort -u > "$output_file"
    
    local subdomain_count=$(wc -l < "$output_file")
    
    echo -e "📊  Found $subdomain_count subdomains for $domain."
    echo -e "💾  Results saved to $output_file."
    
    echo -e "🔍  Subdomains:\n"
    cat "$output_file"
}

# Main function to run the tool
main() {
    current_time=$(date +%s)

    # Check if the last execution time file exists
    if [[ -f "$LAST_EXECUTION_FILE" ]]; then
        last_execution_time=$(cat "$LAST_EXECUTION_FILE")
        time_diff=$(( (current_time - last_execution_time) / 60 ))

        # If less than 5 minutes, skip downloading
        if [[ $time_diff -lt 5 ]]; then
            echo -e "⏰ Last execution was less than 5 minutes ago. Skipping download."
            skip_download=true
        else
            skip_download=false
        fi
    else
        skip_download=false
    fi

    # Array of file names and URLs
    declare -A files
    files=(
        ["amazon"]="https://kaeferjaeger.gay/sni-ip-ranges/amazon/ipv4_merged_sni.txt"
        ["digitalocean"]="https://kaeferjaeger.gay/sni-ip-ranges/digitalocean/ipv4_merged_sni.txt"
        ["google"]="https://kaeferjaeger.gay/sni-ip-ranges/google/ipv4_merged_sni.txt"
        ["microsoft"]="https://kaeferjaeger.gay/sni-ip-ranges/microsoft/ipv4_merged_sni.txt"
        ["oracle"]="https://kaeferjaeger.gay/sni-ip-ranges/oracle/ipv4_merged_sni.txt"
    )

    # Download each file and compare sizes
    if [[ "$skip_download" == false ]]; then
        for name in "${!files[@]}"; do
            download_and_compare "$name" "${files[$name]}"
        done
    fi

    # Update the last execution time
    echo "$current_time" > "$LAST_EXECUTION_FILE"

    # Prompt user for domain input
    read -rp "Enter the domain to filter (e.g., .dell.com): " domain
    filter_domains "$domain"

    echo -e "🎉  Cloud Sentry tool completed!"
}

# Run the main function
main
