#!/bin/bash
#
# Banking Vertical - Java Test Runner
#
# This script compiles and runs the Banking Java test suite.
#
# Usage:
#   ./run_tests.sh
#

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "================================================"
echo "Banking Vertical - Java Test Runner"
echo "================================================"
echo ""

# Compile the test file
echo "📦 Compiling BankingValidatorTest.java..."
javac BankingValidatorTest.java

# Create package directory structure
echo "📁 Creating package structure..."
mkdir -p com/archailign/ebl/banking/tests
cp BankingValidatorTest.java com/archailign/ebl/banking/tests/
javac com/archailign/ebl/banking/tests/BankingValidatorTest.java

echo ""
echo "🚀 Running tests..."
echo ""

# Run the tests
java com.archailign.ebl.banking.tests.BankingValidatorTest

# Capture exit code
EXIT_CODE=$?

# Cleanup
echo ""
echo "🧹 Cleaning up..."
rm -rf com *.class 2>/dev/null || true

echo ""
echo "================================================"

# Exit with test result
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Tests completed successfully!"
    exit 0
else
    echo "❌ Tests failed with exit code $EXIT_CODE"
    exit $EXIT_CODE
fi
