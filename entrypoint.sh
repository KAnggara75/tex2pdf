#!/bin/sh
set -e

export PATH="/root/.TinyTeX/bin/x86_64-linux:$PATH"

echo "=== LaTeX Builder (Deterministic Mode) ==="

MAIN_LATEX_FILE="${MAIN_LATEX_FILE:-main.tex}"
OUTPUT_DIR="${OUTPUT_DIR:-output}"
TOC="${TOC:-false}"

mkdir -p "$OUTPUT_DIR"

# OPTIONAL: CTAN install (kalau masih pakai)
if [ -n "$CTAN_PACKAGES" ]; then
    echo "Installing CTAN packages: $CTAN_PACKAGES"
    for pkg in $CTAN_PACKAGES; do
        tlmgr install "$pkg" || echo "Skip $pkg"
    done
fi

compile() {
    lualatex \
        -interaction=nonstopmode \
        -halt-on-error \
        -output-directory="$OUTPUT_DIR" \
        "$MAIN_LATEX_FILE"
}

echo "Compiling: $MAIN_LATEX_FILE"

if [ "$TOC" = "true" ]; then
    for i in 1 2 3; do
        echo "Pass $i (TOC)..."
        compile
    done
else
    for i in 1 2 3; do
        echo "Pass $i..."
        compile
    done
fi

echo "Build completed."