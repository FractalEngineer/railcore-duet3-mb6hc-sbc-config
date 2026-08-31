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
- Installs the `update-dsf-config` command for subsequent updates.

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

## Git inspection

The checkout is owned by the `dsf` account. Inspect it with:

```bash
sudo -H -u dsf git -C /opt/dsf/sd status
```

## Legacy transfer-ready pin note

An older, damaged Raspberry Pi required `"TransferReadyPin": 24` in
`/opt/dsf/conf/config.json`. That Pi has been replaced. The installer does not
change `TransferReadyPin`; retain this value only as a recovery reference for
the old hardware.
