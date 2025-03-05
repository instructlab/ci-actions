#!/usr/bin/env bash
# shellcheck disable=SC2002  # Disables false positives on the 'cat' statements

set -eo pipefail

GET_SECURITY_GROUP_ID=0
GET_SUBNET=0
GET_AMI_ID=0

LOG_LEVEL="INFO"

usage() {
    echo "Usage: $0 [-z] [-c] [-v] [-l] [-h]"
    echo "  [ REQUIRED FLAGS ]"
    echo "  Each one of the base options requires the following flags. These flags require input values."
    echo "    -z   Availability zone"
    echo "    -c   Path to the regions configuration JSON file"
    echo "    -v   Value (field) to retrieve from the regions configuration JSON file. (See below for supported fields.)"
    echo ""
    echo "  [ SUPPORTED REGIONS CONFIGURATION FIELDS ]"
    echo "  Choose ONE of fields when using the -v flag:"
    echo "    security-group-id   Grabs the security group ID for the specified availability zone"
    echo "    ec2-ami             Grabs the EC2 AMI ID for the specified availability zone"
    echo "    subnet              Grabs the subnet associated with the specified availability zone"
    echo ""
    echo "  [ OPTIONAL FLAGS ]"
    echo "    -l   Log level. Set to one of: { INFO , ERROR }. If set to 'ERROR', then '[INFO]' logs will be ignored."
    echo ""
    echo "  [ OTHER ]"
    echo "  -h  Show this help text"
}

log_info() {
    # LOG_LEVEL is intended to disable info logging if desired. Good for unit tests.
    if [[ "$LOG_LEVEL" == "INFO" ]]; then
        echo "[INFO] ${1}"
    fi
}

log_error() {
    echo "[ERROR] ${1}"
}

is_availability_zone_supported() {
    local supported_availability_zones=(
        "us-east-1a"
        "us-east-1b"
        "us-east-1c"
        "us-east-1d"
        "us-east-1e"
        "us-east-1f"
        "us-east-2a"
        "us-east-2b"
        "us-east-2c"
    )

    user_selection=$1

    local found=0
    for az in "${supported_availability_zones[@]}"; do
        if [[ $az == "$user_selection" ]]; then
            found=1
            break
        fi
    done

    if (( found == 0 )); then
        log_error "Availability zone '$user_selection' is currently not supported by this GitHub action. If you would like this availability zone supported, please file an issue under: https://github.com/instructlab/ci-actions/issues"
        exit 1
    fi
}

validate_regions_config_json() {
    # This will throw an error if the JSON is not valid.
    log_info "Validating 'regions_config' input before proceeding..."
    python -mjson.tool "$REGIONS_CONFIG_FILE" > /dev/null
}

get_config_value() {
    # Basic error checking to ensure the two required inputs were passed in
    if [ -z "${AVAILABILITY_ZONE}" ]; then
        log_error "This internal script requires an availability zone, but one has not been provided. Please provide one with the -az flag."
        usage
        exit 1
    elif [ -z "${REGIONS_CONFIG_FILE}" ]; then
        log_error "This internal script requires a regions configuration file, but one has not been provided. Please provide one with the -c flag."
        usage
        exit 1
    fi

    # Validate the JSON file before proceeding
    validate_regions_config_json

    # If the availability zone is NOT supported, then exit the script now
    is_availability_zone_supported "${AVAILABILITY_ZONE}"

    # Get the region from the availability zone
    region="${AVAILABILITY_ZONE%?}"

    # Determine which config we want to get
    if [ "$GET_SECURITY_GROUP_ID" -eq 1 ]; then
        jq -r ".[] | select(.region == \"$region\") | to_entries[] | select(.key == \"security-group-id\") | .value" "${REGIONS_CONFIG_FILE}"
    elif [ "$GET_SUBNET" -eq 1 ]; then
        # First check if there are any subnets defined before we try to index
        subnet_map=$(jq -r ".[] | select(.region == \"${region}\") | .subnets" "${REGIONS_CONFIG_FILE}")
        if [[ -z "${subnet_map}" || "${subnet_map}" == "null" ]]; then
            log_error "No subnets defined for ${region}. Please provide a list of subnets in your 'regions_config' input."
            exit 1
        else
            echo "$subnet_map" | jq -r "to_entries[] | select(.key == \"${AVAILABILITY_ZONE}\") | .value"
        fi
    elif [ "$GET_AMI_ID" -eq 1 ]; then
        jq -r ".[] | select(.region == \"$region\") | to_entries[] | select(.key == \"ec2-ami\") | .value" "${REGIONS_CONFIG_FILE}"
    fi
}

# Process command line arguments
while getopts ":z:c:v:l:" opt; do
    case "${opt}" in
        z)
            AVAILABILITY_ZONE="${OPTARG}"
            ;;
        c)
            REGIONS_CONFIG_FILE="${OPTARG}"
            ;;
        v)
            if [[ "${OPTARG}" == "security-group-id" ]]; then
                GET_SECURITY_GROUP_ID=1
            elif [[ "${OPTARG}" == "ec2-ami" ]]; then
                GET_AMI_ID=1
            elif [[ "${OPTARG}" == "subnet" ]]; then
                GET_SUBNET=1
            else
                log_error "Unrecognized config value '${OPTARG}'. Choose from one of the valid retrievable, config values: { 'security-group-id', 'ec2-ami', 'subnet' }" 
                exit 1
            fi
            ;;
        l)
            # We don't need to do error checking at this point since we only have 'INFO' and 'ERROR'
            LOG_LEVEL="${OPTARG}"
            ;;
        *)
            echo "Invalid option: $1" >&2
            usage
            exit 1 ;;
    esac
done
shift $((OPTIND-1))

get_config_value