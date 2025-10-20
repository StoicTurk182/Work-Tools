#!/bin/bash

SCRIPT_REGISTRY="/root/script-registry.txt"

update_registry() {
    echo "Updating script registry..."

    # Overwrite the registry file with header
    cat > "$SCRIPT_REGISTRY" << EOF
SCRIPT REGISTRY
===============
Last Updated: $(date)
Search Locations: /root /usr/local/bin /home/debian /opt

EOF

    # Find and process all scripts in multiple directories
    find /root /usr/local/bin /home/debian /opt -name "*.sh" -type f 2>/dev/null | while read script; do
        echo "File: $(basename "$script")" >> "$SCRIPT_REGISTRY"
        echo "Path: $script" >> "$SCRIPT_REGISTRY"
        echo "Size: $(stat -c "%s" "$script") bytes" >> "$SCRIPT_REGISTRY"
        echo "Modified: $(stat -c "%y" "$script")" >> "$SCRIPT_REGISTRY"
        purpose=$(grep "^# " "$script" | head -1 | sed 's/^# //')
        echo "Purpose: $purpose" >> "$SCRIPT_REGISTRY"
        echo "Executable: $([ -x "$script" ] && echo "Yes" || echo "No")" >> "$SCRIPT_REGISTRY"
        echo "---" >> "$SCRIPT_REGISTRY"
    done

    echo "Registry updated!"
}

case "$1" in
    "update")
        update_registry
        ;;
    "show")
        cat "$SCRIPT_REGISTRY"
        ;;
    *)
        echo "Usage: $0 {update|show}"
        echo "  update - Update the script registry"
        echo "  show   - Show the registry contents"
        ;;
esac
