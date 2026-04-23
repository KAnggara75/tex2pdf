#!/bin/sh
set -e
export PATH="/root/.TinyTeX/bin/x86_64-linux:$PATH"

echo "=== TeX to PDF Converter ==="
echo "MAIN_LATEX_FILE: $MAIN_LATEX_FILE"
echo "OUTPUT_DIR: $OUTPUT_DIR"
echo "CTAN_PACKAGES: $CTAN_PACKAGES"
echo "TOC: $TOC"

OUTPUT_DIR=$(realpath "$OUTPUT_DIR")
mkdir -p "$OUTPUT_DIR"

if [ -n "$CTAN_PACKAGES" ]; then
    echo "Installing CTAN packages..."
    for pkg in $CTAN_PACKAGES; do
        tlmgr install "$pkg"
    done
fi

compile() {
    lualatex -interaction=nonstopmode -output-directory "$OUTPUT_DIR" "$MAIN_LATEX_FILE"
}

echo "Generating PDF..."

if [ "$TOC" = "true" ]; then
    for i in 1 2 3; do
        echo "LaTeX pass $i (TOC mode)..."
        compile
    done
else
    for i in 1 2; do
        echo "LaTeX pass $i..."
        compile
    done
fi

if [ -n "$GITHUB_OUTPUT" ]; then
    echo "conversion_time=$(date)" >> "$GITHUB_OUTPUT"
fi

echo "Success!"