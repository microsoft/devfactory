#!/bin/bash
set -e

# Move to the repository root
cd "$(dirname "$0")/.."

# Create temporary files to store results
results_file=$(mktemp)
echo -n > "$results_file"  # Clear the file

# Function to run tests and store results
run_test() {
    local test_file="$1"
    local test_type="$2"
    # Prettify test name: remove _test, replace _ and - with space, remove U, title case
    local test_name=$(basename "$test_file" .tftest.hcl | \
        sed 's/_test$//' | \
        sed 's/[_-]/ /g' | \
        sed 's/U//g' | \
        awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) tolower(substr($i,2)) }}1')
    echo "Running $test_name Test:"
    # Run test and capture exit code
    if terraform test -verbose "$test_file"; then
        printf "%s|%s|%s\n" "$test_name" "$test_type" "✅ PASS" >> "$results_file"
    else
        printf "%s|%s|%s\n" "$test_name" "$test_type" "❌ FAIL" >> "$results_file"
    fi
    echo ""
}

# Function to print test summary
print_summary() {
    local total=0
    local passed=0
    local failed=0
    # Prepare a temp file for column output
    tmp_table=$(mktemp)
    echo "Test Name|Type|Status" > "$tmp_table"
    while IFS='|' read -r name type status; do
        if [[ -n "$name" ]]; then
            ((total++))
            if [[ "$status" == "✅ PASS" ]]; then
                ((passed++))
            else
                ((failed++))
            fi
            echo "$name|$type|$status" >> "$tmp_table"
        fi
    done < "$results_file"
    echo
    echo "==================== Test Summary ===================="
    column -t -s '|' "$tmp_table"
    echo "-----------------------------------------------------"
    printf "Total: %d   Passed: %d   Failed: %d\n" "$total" "$passed" "$failed"
    echo "====================================================="
    rm -f "$results_file" "$tmp_table"
    return $((failed > 0))
}

echo "Running all tests in the repository..."

# Function to run tests in a directory
run_tests_in_dir() {
    local dir="$1"
    local type="$2"
    if [ -d "$dir" ]; then
        echo "Running $type tests..."
        find "$dir" -name "*_test.tftest.hcl" -type f | sort | while read -r test_file; do
            run_test "$test_file" "$type"
        done
    fi
}

# Run root test first
if [ -f "test.tftest.hcl" ]; then
    echo "Running root test..."
    run_test "test.tftest.hcl" "Root"
fi

# Run different types of tests
run_tests_in_dir "tests/unit" "Unit"
run_tests_in_dir "tests/integration" "Integration"
run_tests_in_dir "tests/examples" "Example"

# Print test summary (code coverage style)
print_summary
