#!/bin/sh
# Ensure TinyTeX binaries are in PATH
export PATH="$PATH:$(find /root/.TinyTeX/bin -maxdepth 1 -type d -not -path /root/.TinyTeX/bin | head -n 1)"

set -e

echo "=== TeX to PDF Converter ==="
echo "MAIN_LATEX_FILE: $MAIN_LATEX_FILE"
echo "OUTPUT_DIR: $OUTPUT_DIR"
echo "CTAN_PACKAGES: $CTAN_PACKAGES"
echo "TOC: $TOC"

# Install additional packages if specified
if [ -n "$CTAN_PACKAGES" ]; then
    echo "Installing additional packages: $CTAN_PACKAGES..."
    tlmgr install $CTAN_PACKAGES
fi

mkdir -p "$OUTPUT_DIR"

# Run initial pass for TOC if requested
if [ "$TOC" = "true" ]; then
    echo "Generating Table of Contents (Pass 1)..."
    lualatex -interaction=nonstopmode -output-directory "$OUTPUT_DIR" "$MAIN_LATEX_FILE"
fi

echo "Generating PDF..."
lualatex -interaction=nonstopmode -output-directory "$OUTPUT_DIR" "$MAIN_LATEX_FILE"

echo "conversion_time=$(date)" >> "$GITHUB_OUTPUT"
echo "Success!"