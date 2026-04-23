#!/bin/sh
set -e

export PATH="/root/.TinyTeX/bin/x86_64-linux:$PATH"

echo "=== LaTeX Builder (Deterministic Mode) ==="

MAIN_LATEX_FILE="${MAIN_LATEX_FILE:-main.tex}"
OUTPUT_DIR="${OUTPUT_DIR:-output}"
TOC="${TOC:-false}"

mkdir -p "$OUTPUT_DIR"

if [ -n "$CTAN_PACKAGES" ]; then
    echo "Installing CTAN packages: $CTAN_PACKAGES"
    for pkg in $CTAN_PACKAGES; do
        tlmgr install "$pkg"
    done
fi

compile() {
    lualatex -interaction=nonstopmode \
        -halt-on-error \
        -output-directory "$OUTPUT_DIR" \
        "$1"
}

FILE_DIR=$(dirname "$MAIN_LATEX_FILE")
FILE_NAME=$(basename "$MAIN_LATEX_FILE")

cd "$FILE_DIR"

echo "Compiling: $FILE_NAME"

if [ "$TOC" = "true" ]; then
    for i in 1 2 3; do
        echo "Pass $i (TOC)..."
        compile "$FILE_NAME"
    done
else
    for i in 1 2 3; do
        echo "Pass $i..."
        compile "$FILE_NAME"
    done
fi

echo "Build completed."