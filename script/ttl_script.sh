#!/bin/sh

# Check if the required parameters are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <enable|disable> <ttl_value>"
    exit 1
fi

# Assign the provided parameters to variables
mode="$1"
ttl_value="$2"

# Check if iptables is still set
ttlcheck=$(sudo /usr/sbin/iptables -w 5 -t mangle -vnL | grep TTL | awk '{print $13}')

# If TTL is still set, manually remove values
if [ ! -z "${ttlcheck}" ]; then
    sudo /usr/sbin/iptables -w 5 -t mangle -D POSTROUTING -o rmnet+ -j TTL --ttl-set "${ttlcheck}" &>/dev/null || true
    sudo /usr/sbin/ip6tables -w 5 -t mangle -D POSTROUTING -o rmnet+ -j HL --hl-set "${ttlcheck}" &>/dev/null || true
fi

# Handle the enable/disable mode
case "${mode}" in
    enable)
        # Echo TTL to file
        echo "${ttl_value}" > /tmp/ttlvalue

        # Set Start Service
        #sudo /usrdata/simplefirewall/ttl-override start
        ;;
    disable)
        # Remove TTL value file
        rm -f /tmp/ttlvalue

        # Stop the service
        #sudo /usrdata/simplefirewall/ttl-override stop
        ;;
    *)
        echo "Invalid mode: ${mode}"
        echo "Usage: $0 <enable|disable> <ttl_value>"
        exit 1
        ;;
esac