#!/usr/bin/env bash

set -Eeuo pipefail

readonly repo_url="https://github.com/FractalEngineer/railcore-duet3-mb6hc-sbc-config.git"
readonly repo_branch="master"
readonly updater_url="https://raw.githubusercontent.com/FractalEngineer/railcore-duet3-mb6hc-sbc-config/master/scripts/update-dsf-config.sh"
readonly sd_dir="/opt/dsf/sd"
readonly service_name="duetcontrolserver"
readonly backup_root="/opt/dsf/config-backups"

readonly runtime_paths=(
    "sys/config-override.g"
    "sys/heightmap.csv"
    "sys/resurrect.g"
    "sys/eventlog.txt"
    "eventlog.txt"
    "filaments.csv"
)

readonly preserved_directories=(
    "gcodes"
    "firmware"
    "menu"
    "scans"
    "www"
)

readonly required_files=(
    "sys/config.g"
    "sys/daemon.g"
    "sys/homeall.g"
    "sys/homez.g"
    "sys/bed.g"
)

assume_idle=false
if [[ "${1:-}" == "--yes" ]]; then
    assume_idle=true
elif (( $# != 0 )); then
    echo "Usage: $0 [--yes]" >&2
    exit 2
fi

if (( EUID != 0 )); then
    echo "Run this deployer with sudo." >&2
    exit 1
fi

for required_command in bash curl git sudo systemctl find cp install chown chmod mv mktemp rm id date; do
    if ! command -v "${required_command}" >/dev/null 2>&1; then
        echo "Required command not found: ${required_command}" >&2
        exit 1
    fi
done

if ! id dsf >/dev/null 2>&1; then
    echo "The dsf service account does not exist. Install DSF before running this deployer." >&2
    exit 1
fi

if [[ "${assume_idle}" != true ]]; then
    if [[ ! -r /dev/tty ]]; then
        echo "Non-interactive use requires --yes after independently confirming the printer is idle." >&2
        exit 1
    fi
    read -r -p "Confirm the printer is idle and all heaters are off [y/N]: " confirmation </dev/tty
    if [[ ! "${confirmation}" =~ ^[Yy]$ ]]; then
        echo "Deployment cancelled."
        exit 0
    fi
fi

run_as_dsf() {
    sudo -H -u dsf "$@"
}

normalize_permissions() {
    chown -R dsf:dsf "${sd_dir}"
    find "${sd_dir}" -type d -exec chmod 2755 {} +
    find "${sd_dir}" -type f -exec chmod 0644 {} +
}

install_latest_updater() {
    local temporary_updater
    temporary_updater="$(mktemp)"
    curl --fail --silent --show-error --location "${updater_url}" --output "${temporary_updater}"
    bash -n "${temporary_updater}"
    install -o root -g root -m 0755 "${temporary_updater}" /usr/local/sbin/update-dsf-config
    rm -f "${temporary_updater}"
}

validate_checkout() {
    local required_file
    local blank_system_files

    for required_file in "${required_files[@]}"; do
        if [[ ! -s "${sd_dir}/${required_file}" ]]; then
            echo "Required file is missing or empty: ${required_file}" >&2
            return 1
        fi
    done

    blank_system_files="$(find "${sd_dir}/sys" -maxdepth 1 -type f -name '*.g' -size 0 -print)"
    if [[ -n "${blank_system_files}" ]]; then
        echo "Empty system G-code files detected:" >&2
        echo "${blank_system_files}" >&2
        return 1
    fi
}

# Valid existing Git installations use the separately installed transactional
# updater. A present but invalid .git directory falls through to the migration
# path so the entire old directory is preserved before recloning.
if [[ -d "${sd_dir}/.git" ]]; then
    normalize_permissions
    if run_as_dsf git -C "${sd_dir}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        run_as_dsf git -C "${sd_dir}" config core.fileMode false
        install_latest_updater
        exec /usr/local/sbin/update-dsf-config --yes
    fi
    echo "Existing .git directory is invalid; preserving and rebuilding the checkout." >&2
fi

service_was_active=false
migration_started=false
deployment_succeeded=false
moved_directories=()
full_backup=""
failed_checkout=""

finish() {
    local exit_status=$?
    local preserved_directory
    set +e

    if [[ "${deployment_succeeded}" != true && "${migration_started}" == true ]]; then
        echo "Deployment failed; restoring the original DSF directory." >&2

        for preserved_directory in "${moved_directories[@]}"; do
            if [[ -e "${sd_dir}/${preserved_directory}" && -n "${full_backup}" ]]; then
                mv "${sd_dir}/${preserved_directory}" \
                    "${full_backup}/${preserved_directory}"
            fi
            if [[ -e "${full_backup}/${preserved_directory}.from-repository" ]]; then
                mv "${full_backup}/${preserved_directory}.from-repository" \
                    "${sd_dir}/${preserved_directory}"
            fi
        done

        if [[ -e "${sd_dir}" ]]; then
            mv "${sd_dir}" "${failed_checkout}"
            echo "Incomplete checkout retained at ${failed_checkout}." >&2
        fi

        if [[ -n "${full_backup}" && -e "${full_backup}" ]]; then
            mv "${full_backup}" "${sd_dir}"
        fi
    fi

    if [[ -d "${sd_dir}" ]]; then
        normalize_permissions
    fi

    if [[ "${service_was_active}" == true ]]; then
        if ! systemctl start "${service_name}"; then
            echo "Failed to restart ${service_name}." >&2
            exit_status=1
        fi
    fi

    if [[ "${deployment_succeeded}" == true && ${exit_status} -eq 0 ]]; then
        echo "DSF Git deployment completed successfully."
        if [[ -n "${full_backup}" ]]; then
            echo "Previous configuration backup: ${full_backup}"
        fi
    else
        echo "DSF Git deployment did not complete." >&2
    fi

    trap - EXIT
    exit "${exit_status}"
}

trap finish EXIT

if systemctl is-active --quiet "${service_name}"; then
    service_was_active=true
    systemctl stop "${service_name}"
fi

timestamp="$(date +%Y%m%d-%H%M%S)-$$"
install -d -o dsf -g dsf -m 0755 "${backup_root}"
failed_checkout="/opt/dsf/sd-failed-${timestamp}"

if [[ -e "${sd_dir}" ]]; then
    full_backup="${backup_root}/pre-git-${timestamp}"
    mv "${sd_dir}" "${full_backup}"
fi
migration_started=true

install -d -o dsf -g dsf -m 0755 "${sd_dir}"
run_as_dsf git clone --branch "${repo_branch}" --single-branch "${repo_url}" "${sd_dir}"
run_as_dsf git -C "${sd_dir}" config core.fileMode false

if [[ -n "${full_backup}" ]]; then
    preserved_directory=""
    for runtime_path in "${runtime_paths[@]}"; do
        if [[ -s "${full_backup}/${runtime_path}" ]]; then
            install -D -o dsf -g dsf -m 0644 \
                "${full_backup}/${runtime_path}" "${sd_dir}/${runtime_path}"
        fi
    done

    for preserved_directory in "${preserved_directories[@]}"; do
        if [[ ! -e "${full_backup}/${preserved_directory}" ]]; then
            continue
        fi

        if [[ -e "${sd_dir}/${preserved_directory}" ]]; then
            mv "${sd_dir}/${preserved_directory}" \
                "${full_backup}/${preserved_directory}.from-repository"
        fi
        mv "${full_backup}/${preserved_directory}" \
            "${sd_dir}/${preserved_directory}"
        moved_directories+=("${preserved_directory}")
    done
fi

validate_checkout
normalize_permissions
install -o root -g root -m 0755 \
    "${sd_dir}/scripts/update-dsf-config.sh" /usr/local/sbin/update-dsf-config

deployment_succeeded=true
