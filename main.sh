#!/bin/bash

# Cloud Sentry - Vigilant SNI Monitoring and Asset Enumeration

# ASCII Art Logo with Colors
echo -e "\033[1;34m
█▀▀ █░░ █▀█ █░█ █▀▄   █▀ █▀▀ █▄░█ ▀█▀ █▀█ █▄█
█▄▄ █▄▄ █▄█ █▄█ █▄▀   ▄█ ██▄ █░▀█ ░█░ █▀▄ ░█░
\033[0m"

# Function to download files and compare sizes
download_and_compare() {
    local name=$1
    local url=$2
    local new_file="${name}_new.txt"
    local old_file="${name}.txt"

    echo -e "🚀 Downloading $name..."
    curl -o "$new_file" --progress-bar "$url"

    if [[ -f "$old_file" ]]; then
        old_size=$(stat -c%s "$old_file")
        new_size=$(stat -c%s "$new_file")

        if [[ $new_size -ne $old_size ]]; then
            mv "$new_file" "$old_file"
            echo -e "✅ $name updated (size: $new_size bytes)"
        else
            rm "$new_file"
            echo -e "⚖️ $name already up-to-date (size: $old_size bytes)"
        fi
    else
        mv "$new_file" "$old_file"
        echo -e "✅ $name downloaded (size: $(stat -c%s "$old_file") bytes)"
    fi
}

# Function to filter domains
filter_domains() {
    local domain=$1
    echo -e "🔍 Filtering for domain: $domain"
    cat *.txt | grep -F "$domain" | awk -F'-- ' '{print $2}' | tr ' ' '\n' | tr '[' ' ' | sed 's/ //' | sed 's/]//' | grep -F "$domain" | sort -u
}

# Main function to run the tool
main() {
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
    for name in "${!files[@]}"; do
        download_and_compare "$name" "${files[$name]}"
    done

    # Prompt user for domain input
    read -rp "Enter the domain to filter (e.g., .dell.com): " domain
    filter_domains "$domain"

    echo -e "🎉 Cloud Sentry tool completed!"
}

# Run the main function
main
