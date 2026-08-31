#!/usr/bin/env bash

set -Eeuo pipefail

readonly deployer_url="https://raw.githubusercontent.com/FractalEngineer/railcore-duet3-mb6hc-sbc-config/master/scripts/deploy-dsf-config.sh"

assume_idle=false
if [[ "${1:-}" == "--yes" ]]; then
    assume_idle=true
elif (( $# != 0 )); then
    echo "Usage: $0 [--yes]" >&2
    exit 2
fi

if (( EUID != 0 )); then
    echo "Run this installer with sudo." >&2
    exit 1
fi

temporary_directory="$(mktemp -d)"
cleanup() {
    if [[ -n "${temporary_directory}" && -d "${temporary_directory}" ]]; then
        rm -rf -- "${temporary_directory}"
    fi
}
trap cleanup EXIT

download() {
    local source_url="$1"
    local destination="$2"

    if command -v curl >/dev/null 2>&1; then
        curl --fail --silent --show-error --location \
            "${source_url}" --output "${destination}"
    elif command -v wget >/dev/null 2>&1; then
        wget --quiet --output-document="${destination}" "${source_url}"
    else
        echo "Either curl or wget is required to bootstrap the installation." >&2
        return 1
    fi
}

install_prerequisites() {
    local command_name
    local missing=false

    for command_name in curl git sudo; do
        if ! command -v "${command_name}" >/dev/null 2>&1; then
            missing=true
        fi
    done

    if [[ "${missing}" == true ]]; then
        if ! command -v apt-get >/dev/null 2>&1; then
            echo "Missing prerequisites and apt-get is unavailable." >&2
            return 1
        fi
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y \
            ca-certificates curl git sudo
    fi
}

install_prerequisites

if ! id dsf >/dev/null 2>&1; then
    echo "DSF is not installed. Start with a DuetPi image, then rerun this command." >&2
    exit 1
fi

download "${deployer_url}" "${temporary_directory}/deploy-dsf-config.sh"
bash -n "${temporary_directory}/deploy-dsf-config.sh"

deployer_arguments=()
if [[ "${assume_idle}" == true ]]; then
    deployer_arguments+=("--yes")
fi
bash "${temporary_directory}/deploy-dsf-config.sh" "${deployer_arguments[@]}"
