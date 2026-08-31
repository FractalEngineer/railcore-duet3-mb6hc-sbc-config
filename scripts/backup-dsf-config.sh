#!/usr/bin/env bash

set -Eeuo pipefail

readonly sd_dir="/opt/dsf/sd"
readonly remote_name="origin"
readonly remote_branch="master"

readonly config_paths=(
    "sys"
    "macros"
    "filaments"
)

readonly runtime_paths=(
    "sys/config-override.g"
    "sys/heightmap.csv"
    "sys/resurrect.g"
    "sys/eventlog.txt"
    "eventlog.txt"
    "filaments.csv"
)

readonly required_files=(
    "sys/config.g"
    "sys/daemon.g"
    "sys/homeall.g"
    "sys/homez.g"
    "sys/bed.g"
)

if (( EUID != 0 )); then
    echo "Run this backup command with sudo." >&2
    exit 1
fi

for required_command in git sudo date id; do
    if ! command -v "${required_command}" >/dev/null 2>&1; then
        echo "Required command not found: ${required_command}" >&2
        exit 1
    fi
done

if ! id dsf >/dev/null 2>&1; then
    echo "The dsf service account does not exist." >&2
    exit 1
fi

run_as_dsf() {
    sudo -H -u dsf "$@"
}

if ! run_as_dsf git -C "${sd_dir}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "${sd_dir} is not a valid Git checkout." >&2
    exit 1
fi

current_branch="$(run_as_dsf git -C "${sd_dir}" symbolic-ref --quiet --short HEAD || true)"
if [[ "${current_branch}" != "${remote_branch}" ]]; then
    echo "Refusing to back up from branch '${current_branch:-detached HEAD}'; expected ${remote_branch}." >&2
    exit 1
fi

if ! run_as_dsf git -C "${sd_dir}" diff --cached --quiet; then
    echo "Refusing to continue because the Git index already contains staged changes." >&2
    echo "Review them with: sudo -H -u dsf git -C ${sd_dir} diff --cached" >&2
    exit 1
fi

echo "Checking the GitHub branch before creating the backup commit..."
run_as_dsf git -C "${sd_dir}" fetch --prune "${remote_name}"

if ! run_as_dsf git -C "${sd_dir}" merge-base --is-ancestor \
        "${remote_name}/${remote_branch}" HEAD; then
    echo "The GitHub branch contains commits that are not installed locally." >&2
    echo "Resolve the local changes and update before creating a backup commit." >&2
    exit 1
fi

if [[ "$(run_as_dsf git -C "${sd_dir}" rev-parse HEAD)" != \
        "$(run_as_dsf git -C "${sd_dir}" rev-parse "${remote_name}/${remote_branch}")" ]]; then
    echo "Unpushed local commits already exist; refusing to include them implicitly." >&2
    echo "Inspect them, then push or reconcile them manually." >&2
    exit 1
fi

echo "Verifying GitHub push access before creating the backup commit..."
if ! run_as_dsf git -C "${sd_dir}" push --dry-run "${remote_name}" \
        "HEAD:${remote_branch}"; then
    echo "GitHub push access is not configured for the dsf account." >&2
    echo "No files were staged and no backup commit was created." >&2
    exit 1
fi

for required_file in "${required_files[@]}"; do
    if [[ ! -s "${sd_dir}/${required_file}" ]]; then
        echo "Required file is missing or empty: ${required_file}" >&2
        exit 1
    fi
done

run_as_dsf git -C "${sd_dir}" add -A -- "${config_paths[@]}"

# Generated DSF state is restored across deployments but does not belong in a
# manual source-configuration backup.
for runtime_path in "${runtime_paths[@]}"; do
    if run_as_dsf git -C "${sd_dir}" ls-files --error-unmatch -- \
            "${runtime_path}" >/dev/null 2>&1; then
        run_as_dsf git -C "${sd_dir}" restore --staged -- "${runtime_path}"
    fi
done

if run_as_dsf git -C "${sd_dir}" diff --cached --quiet; then
    echo "No source configuration changes to back up."
    exit 0
fi

run_as_dsf git -C "${sd_dir}" diff --cached --check

if (( $# > 0 )); then
    commit_message="$*"
else
    commit_message="Config Backup $(date '+%Y-%m-%d %H:%M:%S')"
fi

run_as_dsf git -C "${sd_dir}" \
    -c user.name="RailCore DuetPi" \
    -c user.email="railcore-duetpi@localhost" \
    commit -m "${commit_message}"

if ! run_as_dsf git -C "${sd_dir}" push "${remote_name}" \
        "HEAD:${remote_branch}"; then
    echo "The configuration was committed locally, but GitHub push failed." >&2
    echo "The commit is retained. Check the dsf account's GitHub credentials." >&2
    exit 1
fi

echo "DSF source configuration committed and pushed successfully."
