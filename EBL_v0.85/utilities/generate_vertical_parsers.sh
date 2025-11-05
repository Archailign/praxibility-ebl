#!/bin/bash
#
# Generate ANTLR Parsers for All Verticals
#
# This script generates Python and Java parsers from vertical-specific grammars.
# Each vertical gets its own generated parsers in verticals/[vertical]/generated/
#
# Usage:
#   From EBL_v0.85/:     ./utilities/generate_vertical_parsers.sh
#   From utilities/:     ./generate_vertical_parsers.sh
#
# Prerequisites:
#   - Java 11+ installed

set -e  # Exit on error

# Determine if we're in utilities/ or EBL_v0.85/
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$(basename "$SCRIPT_DIR")" == "utilities" ]]; then
    # We're in utilities/, go up one level
    cd "$SCRIPT_DIR/.."
fi

echo "📂 Working directory: $(pwd)"
echo ""

ANTLR_JAR="antlr-4.13.1-complete.jar"
ANTLR_URL="https://www.antlr.org/download/antlr-4.13.1-complete.jar"

# Check if ANTLR JAR exists
if [ ! -f "$ANTLR_JAR" ]; then
    echo "📥 Downloading ANTLR $ANTLR_JAR..."
    curl -LO "$ANTLR_URL"
    echo "✅ Downloaded $ANTLR_JAR"
fi

# List of verticals
VERTICALS=(
    "banking"
    "healthcare"
    "retail"
    "insurance"
    "kyc_compliance"
    "adtech"
    "logistics"
    "it_infrastructure"
)

# Grammar file mapping (snake_case to PascalCase)
declare -A GRAMMAR_NAMES=(
    ["banking"]="Banking"
    ["healthcare"]="Healthcare"
    ["retail"]="Retail"
    ["insurance"]="Insurance"
    ["kyc_compliance"]="KYC_Compliance"
    ["adtech"]="AdTech"
    ["logistics"]="Logistics"
    ["it_infrastructure"]="IT_Infrastructure"
)

echo "🚀 Generating ANTLR parsers for all verticals..."
echo ""

for vertical in "${VERTICALS[@]}"; do
    grammar_name="${GRAMMAR_NAMES[$vertical]}"
    grammar_file="verticals/${vertical}/grammar/${grammar_name}_v0_85.g4"

    if [ ! -f "$grammar_file" ]; then
        echo "⚠️  Skipping $vertical: Grammar file not found at $grammar_file"
        continue
    fi

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 Processing: $vertical"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Create output directories
    python_output="verticals/${vertical}/generated/python"
    java_output="verticals/${vertical}/generated/java"

    mkdir -p "$python_output"
    mkdir -p "$java_output"

    # Generate Python parser
    echo "  🐍 Generating Python parser..."
    java -jar "$ANTLR_JAR" \
        -Dlanguage=Python3 \
        -visitor \
        -listener \
        -o "$python_output" \
        "$grammar_file"

    # Generate Java parser
    echo "  ☕ Generating Java parser..."
    java -jar "$ANTLR_JAR" \
        -Dlanguage=Java \
        -visitor \
        -listener \
        -o "$java_output" \
        -package "com.archailign.ebl.${vertical}" \
        "$grammar_file"

    echo "  ✅ Generated parsers for $vertical"
    echo "     Python: $python_output"
    echo "     Java:   $java_output"
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All parsers generated successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Next steps:"
echo "   1. Update validators to import from generated/ directories"
echo "   2. Run vertical-specific tests"
echo ""
echo "💡 To generate parsers for a single vertical:"
echo "   ./generate_vertical_parsers.sh banking"
echo ""
