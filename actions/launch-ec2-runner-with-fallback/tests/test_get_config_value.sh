#!/bin/bash
# shellcheck disable=SC2086,SC2128

###################################
#  GLOBAL VARIABLES (CONFIGS)     #
###################################
# Default, *relative* location for 'get_config_value.sh'
GET_CONFIG_VALUE_SCRIPT="../scripts/get_config_value.sh "

# Logging configs
LOG_LEVEL="ERROR"

# Valid configs
VALID_REGIONS_CONFIG="test-data/valid-regions-config.json"

# Invalid configs
INVALID_REGIONS_CONFIG_MISSING_SECURITY_GROUP_ID="test-data/invalid-regions-config-missing-security-group-id.json"
INVALID_REGIONS_CONFIG_MISSING_SUBNET="test-data/invalid-regions-config-missing-subnet.json"
INVALID_REGIONS_CONFIG_MISSING_EC2_AMI="test-data/invalid-regions-config-missing-ec2-ami.json"

# Keep track of passes, failures, and total tests
NUM_TESTS=0
NUM_SUCCESSES=0
NUM_FAILURES=0

###################################
#  UTILITY FUNCTIONS - NOT TESTS  #
###################################
fail_msg(){
    local function_name=$1
    local reason=$2
    echo "[ FAIL ] $function_name() failed: $reason"

    NUM_TESTS=$((NUM_TESTS+1))
    NUM_FAILURES=$((NUM_FAILURES+1))
}

pass_msg(){
    local function_name=$1
    echo "[ PASS ] $function_name() passed"

    NUM_TESTS=$((NUM_TESTS+1))
    NUM_SUCCESSES=$((NUM_SUCCESSES+1))
}

###################################
#  BEGIN TESTS                    #
###################################
# Make sure to add each NEW test to the "run_tests()" function at the end of this file!

test_validate_regions_config_field() {
    # Inputs
    availability_zone="us-east-2a"

    # Computation
    actual_result=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l "${LOG_LEVEL}" -c "${VALID_REGIONS_CONFIG}" -z "${availability_zone}" -v "fake-field")
    expected_result="[ERROR] Unrecognized config value 'fake-field'. Choose from one of the valid retrievable, config values: { 'security-group-id', 'ec2-ami', 'subnet' }"

    if [[ "${actual_result}" != "${expected_result}" ]]; then
        fail_msg $FUNCNAME "${actual_result} != ${expected_result}"
    else
        pass_msg $FUNCNAME
    fi
}

test_get_subnet_exists() {
    # Inputs
    availability_zone="us-east-2a"

    # Computation
    actual_subnet=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l "${LOG_LEVEL}" -c "${VALID_REGIONS_CONFIG}" -z "${availability_zone}" -v "subnet")
    expected_subnet="subnet-a"

    if [[ "${actual_subnet}" != "${expected_subnet}" ]]; then
        fail_msg $FUNCNAME "${actual_subnet} != ${expected_subnet}"
    else
        pass_msg $FUNCNAME
    fi
}

test_get_subnet_does_not_exist() {
    # Inputs
    availability_zone="us-east-2b"

    # Computation
    actual_subnet=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l "${LOG_LEVEL}" -c "${INVALID_REGIONS_CONFIG_MISSING_SUBNET}" -z "${availability_zone}" -v "subnet")
    expected_subnet=""

    if [[ "${actual_subnet}" != "${expected_subnet}" ]]; then
        fail_msg $FUNCNAME "${actual_subnet} != ${expected_subnet}"
    else
        pass_msg $FUNCNAME
    fi
}

test_get_subnet_no_subnets_defined() {
    # Inputs
    availability_zone="us-east-1a"

    # Computation
    actual_subnet=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l "${LOG_LEVEL}" -c "${INVALID_REGIONS_CONFIG_MISSING_SUBNET}" -z "${availability_zone}" -v "subnet")
    expected_error="[ERROR] No subnets defined for us-east-1. Please provide a list of subnets in your 'regions_config' input."

    if [[ "${actual_subnet}" != "${expected_error}" ]]; then
        fail_msg $FUNCNAME "${actual_subnet} != ${expected_error}"
    else
        pass_msg $FUNCNAME
    fi
}

test_get_subnet_but_availability_zone_is_not_supported() {
    # Inputs
    availability_zone="us-east-7a"

    # Computation
    actual_value=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l ${LOG_LEVEL} -c ${VALID_REGIONS_CONFIG} -z ${availability_zone} -v "subnet")
    expected_error="[ERROR] Availability zone '${availability_zone}' is currently not supported by this GitHub action. If you would like this availability zone supported, please file an issue under: https://github.com/instructlab/ci-actions/issues"

    if [[ "${actual_value}" != "${expected_error}" ]]; then
        fail_msg $FUNCNAME "Expected a specific error to be thrown, but got: ${actual_value}"
    else
        pass_msg $FUNCNAME
    fi
}

test_get_security_group_exists() {
    # Inputs
    availability_zone="us-east-2a"

    # Computation
    actual_sg_id=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l "${LOG_LEVEL}" -c "${VALID_REGIONS_CONFIG}" -z "${availability_zone}" -v "security-group-id")
    expected_sg_id="sg-0"

    if [[ "${actual_sg_id}" != "${expected_sg_id}" ]]; then
        fail_msg $FUNCNAME "${actual_sg_id} != ${expected_sg_id}"
    else
        pass_msg $FUNCNAME
    fi
}

test_get_security_group_does_not_exist() {
    # Inputs
    availability_zone="us-east-1a"

    # Computation
    actual_sg_id=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l "${LOG_LEVEL}" -c "${INVALID_REGIONS_CONFIG_MISSING_SECURITY_GROUP_ID}" -z "${availability_zone}" -v "security-group-id")
    expected_sg_id=""

    if [[ "${actual_sg_id}" != "${expected_sg_id}" ]]; then
        fail_msg $FUNCNAME "Expected a specific error to be thrown, but got: ${actual_sg_id}"
    else
        pass_msg $FUNCNAME
    fi
}

test_get_security_group_but_availability_zone_is_not_supported() {
    # Inputs
    availability_zone="us-east-7a"

    # Computation
    actual_value=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l "${LOG_LEVEL}" -c "${VALID_REGIONS_CONFIG}" -z "${availability_zone}" -v "security-group-id")
    expected_error="[ERROR] Availability zone '${availability_zone}' is currently not supported by this GitHub action. If you would like this availability zone supported, please file an issue under: https://github.com/instructlab/ci-actions/issues"

    if [[ "${actual_value}" != "${expected_error}" ]]; then
        fail_msg $FUNCNAME "Expected a specific error to be thrown, but got: ${actual_value}"
    else
        pass_msg $FUNCNAME
    fi
}

test_get_ec2_ami_exists() {
    # Inputs
    availability_zone="us-east-2a"

    # Computation
    actual_ami_id=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l "${LOG_LEVEL}" -c "${VALID_REGIONS_CONFIG}" -z "${availability_zone}" -v "ec2-ami")
    expected_ami_id="ami-01234567890"

    if [[ "${actual_ami_id}" != "${expected_ami_id}" ]]; then
        fail_msg $FUNCNAME "${actual_ami_id} != ${expected_ami_id}"
    else
        pass_msg $FUNCNAME
    fi
}

test_get_ec2_ami_does_not_exist() {
    # Inputs
    availability_zone="us-east-1a"

    # Computation
    actual_ami_id=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l "${LOG_LEVEL}" -c "${INVALID_REGIONS_CONFIG_MISSING_EC2_AMI}" -z "${availability_zone}" -v "ec2-ami")
    expected_ami_id=""

    if [[ "${actual_ami_id}" != "${expected_ami_id}" ]]; then
        fail_msg $FUNCNAME "Expected a specific error to be thrown, but got: ${actual_ami_id}"
    else
        pass_msg $FUNCNAME
    fi
}

test_get_ec2_ami_but_availability_zone_is_not_supported() {
    # Inputs
    availability_zone="us-east-7a"

    # Computation
    actual_ami_id=$(sh ${GET_CONFIG_VALUE_SCRIPT} -l "${LOG_LEVEL}" -c "${VALID_REGIONS_CONFIG}" -z "${availability_zone}" -v "ec2-ami")
    expected_error="[ERROR] Availability zone '${availability_zone}' is currently not supported by this GitHub action. If you would like this availability zone supported, please file an issue under: https://github.com/instructlab/ci-actions/issues"

    if [[ "${actual_value}" != "${expected_error}" ]]; then
        fail_msg $FUNCNAME "Expected a specific error to be thrown, but got: ${actual_value}"
    else
        pass_msg $FUNCNAME
    fi
}

###################################
#  TEST RUNNER                    #
###################################
# Add unit tests here
run_tests() {
    echo "===================================================="
    echo "Running 'unit' tests for 'get_config_values.sh()'..."
    echo "===================================================="

    # User input tests
    test_validate_regions_config_field

    # Subnet tests
    test_get_subnet_exists
    test_get_subnet_does_not_exist
    test_get_subnet_no_subnets_defined
    test_get_subnet_but_availability_zone_is_not_supported

    # Security group ID tests
    test_get_security_group_exists
    test_get_security_group_does_not_exist
    test_get_security_group_but_availability_zone_is_not_supported

    # AMI ID tests
    test_get_ec2_ami_exists
    test_get_ec2_ami_does_not_exist
    test_get_ec2_ami_but_availability_zone_is_not_supported
}

###################################
#  ANALYZE TEST RESULTS           #
###################################
# Run the tests and abort if there is even 1 failure
run_tests

echo "----------------------------------------------------"
echo ">>> Summary":
echo "${NUM_SUCCESSES} / ${NUM_TESTS} tests passed"

if (( NUM_FAILURES > 0)); then
    echo " ** Detected at least one failure. Review the above output to determine which tests failed and why."
    echo " ** All tests are required to pass. Aborting..."
    exit 1
fi