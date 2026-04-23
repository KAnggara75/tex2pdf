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
        echo "Package $pkg missing. Installing..."
        tlmgr install "$pkg"
    }

done < "$LOCK_FILE"

# Only allow packages that are in latex.lock
if [ -n "$CTAN_PACKAGES" ]; then
    for pkg in $CTAN_PACKAGES; do
        grep -q "^$pkg$" "$LOCK_FILE" || {
            echo "ERROR: Package '$pkg' is not allowed (not in latex.lock)"
            exit 1
        }
    done
fi

echo "All dependencies OK."