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
    if ! terraform -chdir="${test_dir}" init -input=false > /dev/null 2>&1; then
      echo -e "  ${RED}✗ Failed to initialize ${test_dir}${NC}"
      echo -e "  ${RED}✗ ${test_name} tests failed (initialization failed)${NC}"
      return 1
    fi
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

# Initialize the root configuration first (required for tests that reference root modules)
echo -e "${YELLOW}Initializing root configuration...${NC}"
if [ ! -d ".terraform" ] || [ ! -f ".terraform/modules/modules.json" ]; then
  echo -e "  Initializing root directory..."
  if ! terraform init -input=false > /dev/null 2>&1; then
    echo -e "  ${RED}✗ Failed to initialize root configuration${NC}"
    echo -e "  This may cause some tests to fail"
  else
    echo -e "  ${GREEN}✓ Root configuration initialized${NC}"
  fi
else
  echo -e "  ${GREEN}✓ Root configuration already initialized${NC}"
fi
echo ""

echo -e "${BOLD}Running Unit Tests${NC}"
echo -e "----------------\n"

# Create an array to store failed tests
failed_tests=()

# Dynamically discover unit test directories
echo -e "${YELLOW}Discovering test directories...${NC}"
unit_test_dirs=()
if [ -d "tests/unit" ]; then
  while IFS= read -r -d '' dir; do
    if [ -d "$dir" ] && [ -n "$(find "$dir" -name "*.tftest.hcl" -o -name "*.tf" 2>/dev/null)" ]; then
      unit_test_dirs+=("$dir")
    fi
  done < <(find tests/unit -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
fi

echo -e "Found ${#unit_test_dirs[@]} unit test directories"
for dir in "${unit_test_dirs[@]}"; do
  echo -e "  - $(basename "$dir")"
done
echo ""

# Initialize all test directories first
echo -e "${YELLOW}Initializing all test directories...${NC}"
for dir in "${unit_test_dirs[@]}"; do
  if [ ! -d "${dir}/.terraform" ]; then
    echo -e "  Initializing $(basename "$dir")..."
    if ! terraform -chdir="${dir}" init -input=false > /dev/null 2>&1; then
      echo -e "  ${RED}✗ Failed to initialize ${dir}${NC}"
    else
      echo -e "  ${GREEN}✓ Initialized ${dir}${NC}"
    fi
  else
    # Check if modules.json exists and is recent
    if [ ! -f "${dir}/.terraform/modules/modules.json" ] || [ "${dir}/.terraform/modules/modules.json" -ot "../../../.terraform/modules/modules.json" ] 2>/dev/null; then
      echo -e "  Re-initializing $(basename "$dir") (modules may be outdated)..."
      if ! terraform -chdir="${dir}" init -input=false > /dev/null 2>&1; then
        echo -e "  ${RED}✗ Failed to re-initialize ${dir}${NC}"
      else
        echo -e "  ${GREEN}✓ Re-initialized ${dir}${NC}"
      fi
    else
      echo -e "  ${GREEN}✓ $(basename "$dir") already initialized${NC}"
    fi
  fi
done
echo ""

for dir in "${unit_test_dirs[@]}"; do
  test_name=$(basename "$dir")
  if ! run_test "$dir" "$test_name"; then
    failed_tests+=("$test_name")
  fi
  echo ""
done

echo -e "${BOLD}Running Integration Tests${NC}"
echo -e "---------------------\n"

# Dynamically discover integration test directories
integration_test_dirs=()
if [ -d "tests/integration" ]; then
  while IFS= read -r -d '' dir; do
    if [ -d "$dir" ] && [ -n "$(find "$dir" -name "*.tftest.hcl" -o -name "*.tf" 2>/dev/null)" ]; then
      integration_test_dirs+=("$dir")
    fi
  done < <(find tests/integration -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

  # If no subdirectories with tests found, check if integration directory itself has tests
  if [ ${#integration_test_dirs[@]} -eq 0 ] && [ -n "$(find tests/integration -maxdepth 1 -name "*.tftest.hcl" -o -name "*.tf" 2>/dev/null)" ]; then
    integration_test_dirs+=("tests/integration")
  fi
fi

echo -e "Found ${#integration_test_dirs[@]} integration test directories"
for dir in "${integration_test_dirs[@]}"; do
  echo -e "  - $(basename "$dir")"
done
echo ""

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
