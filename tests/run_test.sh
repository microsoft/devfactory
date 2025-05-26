#!/bin/bash
set -e

# Colors for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# This script runs specific Terraform tests for the DevFactory project

# Function to display usage information
show_usage() {
  echo -e "${BOLD}Usage:${NC}"
  echo -e "  $0 [options] <test_type> <test_name>"
  echo ""
  echo -e "${BOLD}Test Types:${NC}"
  echo "  resource_group          - Run resource group tests"
  echo "  dev_center              - Run dev center tests"
  echo "  environment_type        - Run environment type tests"
  echo "  project                 - Run project tests"
  echo "  integration             - Run integration tests"
  echo "  all                     - Run all tests"
  echo ""
  echo -e "${BOLD}Options:${NC}"
  echo "  -v, --verbose           - Show verbose output"
  echo "  -r, --run <run_name>    - Run a specific test run block"
  echo "  -h, --help              - Show this help message"
  echo ""
  echo -e "${BOLD}Examples:${NC}"
  echo "  $0 resource_group                      - Run all resource group tests"
  echo "  $0 --verbose dev_center                - Run dev center tests with verbose output"
  echo "  $0 -r test_basic_project project       - Run only the test_basic_project run block in project tests"
  echo "  $0 all                                 - Run all tests"
}

# Parse arguments
VERBOSE=""
RUN_NAME=""

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -v|--verbose)
      VERBOSE="-verbose"
      shift
      ;;
    -r|--run)
      if [[ "$#" -lt 2 ]]; then
        echo -e "${RED}Error: Missing run name after $1${NC}"
        show_usage
        exit 1
      fi
      RUN_NAME="$2"
      shift 2
      ;;
    -h|--help)
      show_usage
      exit 0
      ;;
    *)
      if [[ -z "$TEST_TYPE" ]]; then
        TEST_TYPE="$1"
      else
        echo -e "${RED}Error: Unexpected argument $1${NC}"
        show_usage
        exit 1
      fi
      shift
      ;;
  esac
done

# Check if test type is provided
if [[ -z "$TEST_TYPE" ]]; then
  echo -e "${RED}Error: Test type not specified${NC}"
  show_usage
  exit 1
fi

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the root directory
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Change to the root directory
cd "$ROOT_DIR"

# Function to run a test
run_test() {
  local test_dir=$1
  local test_name=$2

  echo -e "${YELLOW}Running ${test_name} tests...${NC}"

  # Initialize the test directory if needed
  if [ ! -d "${test_dir}/.terraform" ]; then
    echo -e "  Initializing ${test_dir}..."
    terraform -chdir="${test_dir}" init -input=false > /dev/null
  fi

  # Run the test
  echo -e "  Executing tests in ${test_dir}..."

  if [[ -n "$RUN_NAME" ]]; then
    # Run a specific test run block
    if terraform -chdir="${test_dir}" test $VERBOSE run "$RUN_NAME"; then
      echo -e "  ${GREEN}✓ ${test_name} test '${RUN_NAME}' passed${NC}"
      return 0
    else
      echo -e "  ${RED}✗ ${test_name} test '${RUN_NAME}' failed${NC}"
      return 1
    fi
  else
    # Run all test run blocks in the file
    if terraform -chdir="${test_dir}" test $VERBOSE; then
      echo -e "  ${GREEN}✓ ${test_name} tests passed${NC}"
      return 0
    else
      echo -e "  ${RED}✗ ${test_name} tests failed${NC}"
      return 1
    fi
  fi
}

# Run tests based on the test type
case "$TEST_TYPE" in
  resource_group)
    run_test "tests/unit/resource_group" "Resource Group"
    ;;
  dev_center)
    run_test "tests/unit/dev_center" "Dev Center"
    ;;
  environment_type)
    run_test "tests/unit/dev_center_environment_type" "Environment Type"
    ;;
  project)
    run_test "tests/unit/dev_center_project" "Project"
    ;;
  integration)
    run_test "tests/integration" "Integration"
    ;;
  all)
    run_test "tests/unit/resource_group" "Resource Group" && \
    run_test "tests/unit/dev_center" "Dev Center" && \
    run_test "tests/unit/dev_center_environment_type" "Environment Type" && \
    run_test "tests/unit/dev_center_project" "Project" && \
    run_test "tests/integration" "Integration"
    ;;
  *)
    echo -e "${RED}Error: Unknown test type '${TEST_TYPE}'${NC}"
    show_usage
    exit 1
    ;;
esac
