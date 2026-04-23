#!/bin/sh
set -e

export PATH="/root/.TinyTeX/bin/x86_64-linux:$PATH"

echo "=== TeX to PDF Converter ==="
echo "MAIN_LATEX_FILE: $MAIN_LATEX_FILE"
echo "OUTPUT_DIR: $OUTPUT_DIR"
echo "CTAN_PACKAGES: $CTAN_PACKAGES"
echo "TOC: $TOC"

if ! command -v tlmgr >/dev/null 2>&1; then
    echo "ERROR: tlmgr not found"
    exit 1
fi

OUTPUT_DIR="$(cd "$OUTPUT_DIR" && pwd)"
mkdir -p "$OUTPUT_DIR"

if [ -n "$CTAN_PACKAGES" ]; then
    echo "Installing CTAN packages..."
    for pkg in $CTAN_PACKAGES; do
        echo "Installing $pkg..."
        tlmgr install "$pkg" || echo "Skipping $pkg"
    done
fi

compile() {
    lualatex -interaction=nonstopmode \
        -output-directory "$OUTPUT_DIR" \
        "$1" || {
        echo "ERROR: LaTeX compilation failed"
        exit 1
    }
}

echo "Generating PDF..."

FILE_DIR=$(dirname "$MAIN_LATEX_FILE")
FILE_NAME=$(basename "$MAIN_LATEX_FILE")

cd "$FILE_DIR"

if [ "$TOC" = "true" ]; then
    for i in 1 2 3; do
        echo "Pass $i (TOC mode)..."
        compile "$FILE_NAME"
    done
else
    for i in 1 2 3; do
        echo "Pass $i..."
        compile "$FILE_NAME"
    done
fi

if [ -n "$GITHUB_OUTPUT" ]; then
    echo "conversion_time=$(date)" >> "$GITHUB_OUTPUT"
fi

echo "Success!"