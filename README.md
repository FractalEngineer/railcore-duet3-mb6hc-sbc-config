# RailCore Duet 3 MB6HC SBC configuration

RepRapFirmware configuration and macros for this RailCore printer, intended for
RRF 3.6 with a Duet 3 MB6HC in SBC mode.

## One-command deployment

Start with a working DuetPi image. DSF must already be installed and the `dsf`
service account must exist. The bootstrap does not install or modify Raspberry
Pi OS, DSF, SPI, or GPIO settings.

With the printer idle and all heaters off, open a terminal on the DuetPi and
run:

```bash
wget -qO- https://raw.githubusercontent.com/FractalEngineer/railcore-duet3-mb6hc-sbc-config/master/install.sh | sudo bash
```

The same command handles both a fresh DuetPi configuration and later updates.
It asks for confirmation before interrupting DuetControlServer.

During first deployment it:

- Moves the previous `/opt/dsf/sd` to a timestamped backup.
- Clones this repository as the `dsf` account.
- Preserves generated machine state, print files, firmware, menus, scans, and
  Duet Web Control files.
- Checks that required system G-code files exist and are not empty.
- Restores the original directory automatically if migration fails.
- Installs the `update-dsf-config` and `backup-dsf-config` commands.

Backups are stored under `/opt/dsf/config-backups/`.

## Routine updates

After the first successful deployment, either repeat the one-command bootstrap
or run:

```bash
sudo update-dsf-config
```

The updater refuses unexpected local changes, creates a backup, performs a
fast-forward-only pull, validates the result, restores DSF-generated files, and
returns DuetControlServer to its previous running state. It does not reboot the
DuetPi.

For deliberate non-interactive use, after independently confirming that the
printer is idle:

```bash
sudo update-dsf-config --yes
```

## Manual configuration backup to GitHub

Pushing requires one-time GitHub authentication. A repository-scoped SSH
deploy key is recommended. Generate one as the `dsf` account:

```bash
sudo -H -u dsf mkdir -p /opt/dsf/.ssh
sudo -H -u dsf chmod 700 /opt/dsf/.ssh
sudo -H -u dsf ssh-keygen -t ed25519 -f /opt/dsf/.ssh/id_ed25519 -N "" -C "railcore-duetpi-backup"
sudo -H -u dsf cat /opt/dsf/.ssh/id_ed25519.pub
```

Add the displayed public key under the GitHub repository's **Settings > Deploy
keys**, selecting **Allow write access**. Then switch this checkout to SSH and
accept GitHub's host key once:

```bash
sudo -H -u dsf git -C /opt/dsf/sd remote set-url origin git@github.com:FractalEngineer/railcore-duet3-mb6hc-sbc-config.git
sudo -H -u dsf ssh -T git@github.com
```

GitHub should report successful authentication and then close the connection;
it does not provide an interactive shell.

After that one-time setup, manually back up and push configuration changes with
one command:

```bash
sudo backup-dsf-config
```

An optional commit message may be supplied:

```bash
sudo backup-dsf-config "Tune hotend PID at 225C"
```

The command commits only `sys`, `macros`, and filament-profile changes. It
excludes generated state such as the height map, resurrection data, event logs,
and `config-override.g`. It also fetches first and refuses to push over newer
GitHub commits or to include unrelated existing commits.

Without a supplied message, commits use `Config Backup YYYY-MM-DD HH:MM:SS` in
the DuetPi's local time.

## `config-override.g` write check

Deployment and update commands enforce `dsf:dsf` ownership, writable owner
permissions, and now explicitly verify that the `dsf` account can write both
`/opt/dsf/sd/sys` and `sys/config-override.g`. An empty old override file is no
longer restored over the repository copy during an update.

To inspect a deployed system manually:

```bash
sudo -H -u dsf test -w /opt/dsf/sd/sys && echo "sys writable"
sudo -H -u dsf test -w /opt/dsf/sd/sys/config-override.g && echo "override writable"
ls -ld /opt/dsf/sd/sys /opt/dsf/sd/sys/config-override.g
```

## Git inspection

The checkout is owned by the `dsf` account. Inspect it with:

```bash
sudo -H -u dsf git -C /opt/dsf/sd status
```

## Corrupt checkout recovery

An `object file ... is empty` message means the Git object database is corrupt;
it is not a Unix permission error. Check free space and kernel storage errors
before attempting another deployment:

```bash
df -h / /opt/dsf/sd
df -i / /opt/dsf/sd
findmnt -no SOURCE,FSTYPE,OPTIONS /opt/dsf/sd
sudo journalctl -k -b --no-pager | grep -Ei 'mmc|ext4|I/O error|buffer I/O|read-only|corrupt|reset'
```

If the storage is healthy, rerun the one-command deployment. It verifies the
Git object database, preserves the old directory, and rebuilds corrupt
checkouts. It also refuses to restore zero-byte runtime files and flushes the
new checkout to storage before declaring success.

## Legacy transfer-ready pin note

An older, damaged Raspberry Pi required `"TransferReadyPin": 24` in
`/opt/dsf/conf/config.json`. That Pi has been replaced. The installer does not
change `TransferReadyPin`; retain this value only as a recovery reference for
the old hardware.
