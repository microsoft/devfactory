#!/bin/bash
set -e

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo -e "${BOLD}DevFactory Test Runner${NC}"
echo -e "===================\n"

# Function to run tests in a directory
run_test() {
  local test_dir=$1
  local test_name=$2

  echo -e "${YELLOW}Running ${test_name} tests...${NC}"

  # Initialize the test directory if needed
  if [ ! -d "${test_dir}/.terraform" ]; then
    echo -e "  Initializing ${test_dir}..."
    terraform -chdir="${test_dir}" init -input=false > /dev/null
  fi

  # Run the test and capture output
  echo -e "  Executing tests in ${test_dir}..."
  local test_output
  test_output=$(terraform -chdir="${test_dir}" test 2>&1)
  local test_exit_code=$?

  # Display the output
  echo "$test_output"

  # Check for the "0 passed, 0 failed" pattern which indicates no tests ran
  if echo "$test_output" | grep -q "0 passed, 0 failed"; then
    echo -e "  ${RED}✗ ${test_name} tests failed (no tests executed)${NC}"
    return 1
  elif [ $test_exit_code -eq 0 ]; then
    echo -e "  ${GREEN}✓ ${test_name} tests passed${NC}"
    return 0
  else
    echo -e "  ${RED}✗ ${test_name} tests failed${NC}"
    return 1
  fi
}

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the root directory (one level up from scripts)
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Change to the root directory
cd "$ROOT_DIR"

echo -e "${BOLD}Running Unit Tests${NC}"
echo -e "----------------\n"

# Create an array to store failed tests
failed_tests=()

# Run all unit tests
unit_test_dirs=("tests/unit/resource_group" "tests/unit/dev_center" "tests/unit/dev_center_environment_type" "tests/unit/dev_center_project" "tests/unit/dev_center_catalog")

for dir in "${unit_test_dirs[@]}"; do
  test_name=$(basename "$dir")
  if ! run_test "$dir" "$test_name"; then
    failed_tests+=("$test_name")
  fi
  echo ""
done

echo -e "${BOLD}Running Integration Tests${NC}"
echo -e "---------------------\n"

# Run integration tests
integration_test_dirs=("tests/integration")

for dir in "${integration_test_dirs[@]}"; do
  test_name=$(basename "$dir")
  if ! run_test "$dir" "integration"; then
    failed_tests+=("integration")
  fi
  echo ""
done

# Print summary
echo -e "${BOLD}Test Summary${NC}"
echo -e "------------"

total_tests=$((${#unit_test_dirs[@]} + ${#integration_test_dirs[@]}))
passed_tests=$((total_tests - ${#failed_tests[@]}))

echo -e "Total tests: ${total_tests}"
echo -e "${GREEN}Passed: ${passed_tests}${NC}"

if [ ${#failed_tests[@]} -gt 0 ]; then
  echo -e "${RED}Failed: ${#failed_tests[@]}${NC}"
  echo -e "${RED}Failed tests: ${failed_tests[*]}${NC}"
  exit 1
else
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
fi
