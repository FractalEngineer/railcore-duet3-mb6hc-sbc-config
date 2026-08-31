#!/usr/bin/env bash

set -Eeuo pipefail

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

readonly backup_paths=(
    "sys"
    "macros"
    "filaments"
    "filaments.csv"
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
    echo "Run this updater with sudo." >&2
    exit 1
fi

for required_command in git sudo systemctl find cp install chown chmod; do
    if ! command -v "${required_command}" >/dev/null 2>&1; then
        echo "Required command not found: ${required_command}" >&2
        exit 1
    fi
done

if ! id dsf >/dev/null 2>&1; then
    echo "The dsf service account does not exist." >&2
    exit 1
fi

if [[ ! -d "${sd_dir}/.git" ]]; then
    echo "${sd_dir} is not a Git checkout." >&2
    exit 1
fi

if [[ "${assume_idle}" != true ]]; then
    if [[ ! -t 0 ]]; then
        echo "Non-interactive use requires --yes after independently confirming the printer is idle." >&2
        exit 1
    fi
    read -r -p "Confirm the printer is idle and all heaters are off [y/N]: " confirmation
    if [[ ! "${confirmation}" =~ ^[Yy]$ ]]; then
        echo "Update cancelled."
        exit 0
    fi
fi

run_as_dsf() {
    sudo -H -u dsf "$@"
}

normalize_permissions() {
    chown -R dsf:dsf "${sd_dir}"
    find "${sd_dir}" -type d -exec chmod 2750 {} +
    find "${sd_dir}" -type f -exec chmod 0640 {} +
}

is_runtime_path() {
    local candidate="$1"
    local runtime_path
    for runtime_path in "${runtime_paths[@]}"; do
        if [[ "${candidate}" == "${runtime_path}" ]]; then
            return 0
        fi
    done
    return 1
}

restore_runtime_files() {
    local runtime_path
    for runtime_path in "${runtime_paths[@]}"; do
        if [[ -f "${backup_dir}/${runtime_path}" ]]; then
            install -D -o dsf -g dsf -m 0640 \
                "${backup_dir}/${runtime_path}" "${sd_dir}/${runtime_path}"
        fi
    done
}

restore_backup() {
    local backup_path
    for backup_path in "${backup_paths[@]}"; do
        if [[ -d "${backup_dir}/${backup_path}" ]]; then
            install -d "${sd_dir}/${backup_path}"
            cp -a "${backup_dir}/${backup_path}/." "${sd_dir}/${backup_path}/"
        elif [[ -f "${backup_dir}/${backup_path}" ]]; then
            cp -a "${backup_dir}/${backup_path}" "${sd_dir}/${backup_path}"
        fi
    done
}

service_was_active=false
backup_ready=false
update_succeeded=false
backup_dir=""

finish() {
    local exit_status=$?
    set +e

    if [[ "${update_succeeded}" != true && "${backup_ready}" == true ]]; then
        echo "Update failed; restoring active configuration from ${backup_dir}." >&2
        if ! restore_backup; then
            echo "The automatic backup restore also failed; inspect ${backup_dir} manually." >&2
            exit_status=1
        fi
    fi

    if ! normalize_permissions; then
        echo "Failed to normalize DSF file ownership or permissions." >&2
        exit_status=1
    fi

    if [[ "${service_was_active}" == true ]]; then
        if ! systemctl start "${service_name}"; then
            echo "Failed to restart ${service_name}." >&2
            exit_status=1
        fi
    fi

    if [[ "${update_succeeded}" == true && ${exit_status} -eq 0 ]]; then
        echo "DSF configuration updated successfully. Backup: ${backup_dir}"
    else
        echo "DSF configuration update did not complete." >&2
    fi

    trap - EXIT
    exit "${exit_status}"
}

trap finish EXIT

run_as_dsf git -C "${sd_dir}" config core.fileMode false
normalize_permissions

working_tree_status="$(run_as_dsf git -C "${sd_dir}" status --porcelain=v1 --untracked-files=normal)"
if [[ -n "${working_tree_status}" ]]; then
    while IFS= read -r status_line; do
        [[ -z "${status_line}" ]] && continue
        changed_path="${status_line:3}"
        if [[ "${changed_path}" == *" -> "* ]]; then
            changed_path="${changed_path##* -> }"
        fi
        if ! is_runtime_path "${changed_path}"; then
            echo "Refusing to pull because an unexpected local change exists: ${changed_path}" >&2
            echo "Commit, discard, or back up that change before updating." >&2
            exit 1
        fi
    done <<< "${working_tree_status}"
fi

if systemctl is-active --quiet "${service_name}"; then
    service_was_active=true
    systemctl stop "${service_name}"
fi

timestamp="$(date +%Y%m%d-%H%M%S)-$$"
backup_dir="${backup_root}/${timestamp}"
install -d -o dsf -g dsf -m 0750 "${backup_dir}"

for backup_path in "${backup_paths[@]}"; do
    if [[ -d "${sd_dir}/${backup_path}" ]]; then
        cp -a "${sd_dir}/${backup_path}" "${backup_dir}/"
    elif [[ -f "${sd_dir}/${backup_path}" ]]; then
        cp -a "${sd_dir}/${backup_path}" "${backup_dir}/"
    fi
done
backup_ready=true

# Restore tracked copies of generated files temporarily so they cannot block
# a fast-forward pull. Their live versions are restored from the backup later.
for runtime_path in "${runtime_paths[@]}"; do
    if run_as_dsf git -C "${sd_dir}" ls-files --error-unmatch -- "${runtime_path}" >/dev/null 2>&1; then
        run_as_dsf git -C "${sd_dir}" restore --source=HEAD --staged --worktree -- "${runtime_path}"
    fi
done

run_as_dsf git -C "${sd_dir}" pull --ff-only

for required_file in "${required_files[@]}"; do
    if [[ ! -s "${sd_dir}/${required_file}" ]]; then
        echo "Required file is missing or empty after pull: ${required_file}" >&2
        exit 1
    fi
done

blank_system_files="$(find "${sd_dir}/sys" -maxdepth 1 -type f -name '*.g' -size 0 -print)"
if [[ -n "${blank_system_files}" ]]; then
    echo "Empty system G-code files detected after pull:" >&2
    echo "${blank_system_files}" >&2
    exit 1
fi

run_as_dsf git -C "${sd_dir}" diff --check
restore_runtime_files
normalize_permissions

# Keep the installed updater synchronized without executing a script from the
# live checkout while Git may be replacing it.
install -o root -g root -m 0755 \
    "${sd_dir}/scripts/update-dsf-config.sh" "/usr/local/sbin/update-dsf-config"

update_succeeded=true
