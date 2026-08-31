#!/usr/bin/env bash

set -Eeuo pipefail

readonly deployer_url="https://raw.githubusercontent.com/FractalEngineer/railcore-duet3-mb6hc-sbc-config/master/scripts/deploy-dsf-config.sh"
readonly duet_key_url="https://pkg.duet3d.com/duet3d.gpg"
readonly duet_feed_url="https://pkg.duet3d.com/duet3d.list"
readonly transfer_ready_pin=24

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

    for command_name in curl git sudo python3; do
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
            ca-certificates curl git sudo python3
    fi
}

install_dsf() {
    local architecture

    if ! command -v apt-get >/dev/null 2>&1 || ! command -v dpkg >/dev/null 2>&1; then
        echo "Automatic DSF installation requires Raspberry Pi OS or Debian." >&2
        return 1
    fi

    architecture="$(dpkg --print-architecture)"
    if [[ "${architecture}" != "armhf" && "${architecture}" != "arm64" ]]; then
        echo "Automatic DSF installation supports ARM Raspberry Pi systems only; found ${architecture}." >&2
        return 1
    fi

    if command -v raspi-config >/dev/null 2>&1; then
        raspi-config nonint do_spi 0
    elif [[ ! -e /dev/spidev0.0 ]]; then
        echo "SPI is not enabled and raspi-config is unavailable." >&2
        return 1
    fi

    printf '%s\n' 'options spidev bufsiz=8192' > /etc/modprobe.d/spidev.conf

    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https

    download "${duet_key_url}" "${temporary_directory}/duet3d.gpg"
    download "${duet_feed_url}" "${temporary_directory}/duet3d.list"
    install -o root -g root -m 0644 \
        "${temporary_directory}/duet3d.gpg" /etc/apt/trusted.gpg.d/duet3d.gpg
    install -o root -g root -m 0644 \
        "${temporary_directory}/duet3d.list" /etc/apt/sources.list.d/duet3d.list

    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y duetsoftwareframework

    if ! id dsf >/dev/null 2>&1; then
        echo "DSF installation completed without creating the dsf account." >&2
        return 1
    fi
}

set_transfer_ready_pin() {
    local config_file="/opt/dsf/conf/config.json"

    if [[ ! -f "${config_file}" ]]; then
        echo "DSF configuration was not created at ${config_file}." >&2
        return 1
    fi

    python3 - "${config_file}" "${transfer_ready_pin}" <<'PY'
import json
import os
import pathlib
import sys
import tempfile

path = pathlib.Path(sys.argv[1])
pin = int(sys.argv[2])
metadata = path.stat()
data = json.loads(path.read_text(encoding="utf-8"))
data["TransferReadyPin"] = pin

descriptor, temporary_name = tempfile.mkstemp(dir=path.parent, prefix=f".{path.name}.")
try:
    with os.fdopen(descriptor, "w", encoding="utf-8") as output:
        json.dump(data, output, indent=2)
        output.write("\n")
        output.flush()
        os.fsync(output.fileno())
    os.chown(temporary_name, metadata.st_uid, metadata.st_gid)
    os.chmod(temporary_name, metadata.st_mode & 0o7777)
    os.replace(temporary_name, path)
finally:
    if os.path.exists(temporary_name):
        os.unlink(temporary_name)
PY
}

install_prerequisites

installed_dsf=false
configure_transfer_ready=false
if ! id dsf >/dev/null 2>&1; then
    echo "DSF was not found; installing the official stable DSF packages."
    install_dsf
    installed_dsf=true
    configure_transfer_ready=true
elif [[ ! -d /opt/dsf/sd/.git ]]; then
    configure_transfer_ready=true
fi

download "${deployer_url}" "${temporary_directory}/deploy-dsf-config.sh"
bash -n "${temporary_directory}/deploy-dsf-config.sh"

deployer_arguments=()
if [[ "${assume_idle}" == true ]]; then
    deployer_arguments+=("--yes")
fi
bash "${temporary_directory}/deploy-dsf-config.sh" "${deployer_arguments[@]}"

if [[ "${configure_transfer_ready}" == true ]]; then
    set_transfer_ready_pin
fi

if [[ "${installed_dsf}" == true ]]; then
    systemctl enable duetcontrolserver duetwebserver
    systemctl stop duetcontrolserver >/dev/null 2>&1 || true
    echo
    echo "Clean installation completed. Reboot now to activate SPI and start DSF:"
    echo "  sudo reboot"
elif [[ "${configure_transfer_ready}" == true ]] && \
        systemctl is-active --quiet duetcontrolserver; then
    systemctl restart duetcontrolserver
fi
