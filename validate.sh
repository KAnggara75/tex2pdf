#!/bin/sh
set -e

echo "=== Validating LaTeX Dependencies ==="

LOCK_FILE="/latex.lock"

if [ ! -f "$LOCK_FILE" ]; then
    echo "ERROR: latex.lock not found"
    exit 1
fi

while read pkg; do
    case "$pkg" in
        ""|\#*) continue ;;
    esac

    echo "Checking: $pkg"

    kpsewhich "$pkg.sty" >/dev/null 2>&1 || {
        echo "ERROR: Missing package in image: $pkg"
        exit 1
    }

done < "$LOCK_FILE"

echo "All dependencies OK."