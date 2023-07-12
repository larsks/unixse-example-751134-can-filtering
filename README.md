# Rejecting CAN packets by UID

Part of <https://unix.stackexchange.com/q/751134/4989>.

## Requirements

You will need:

- [`canutils`](https://github.com/linux-can/can-utils)
- [`nftables`](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)
- `sudo` access

## Running the tests

As a non-`root` user with `sudo` access (because the script relies on the `SUDO_USER` and `SUDO_GID` environment variables to select a non-`root` account for the blocking rule):

```
sudo bash testcan.sh
```

Expected output:

```
creating interface can0
creating interface can1
configuring can gw
Running cangen as root
  can1  5B3   [8]  9F FB A5 4B 56 C5 4C 46
  can1  5B1   [8]  53 B0 5D 52 46 37 77 0C
  can1  41E   [8]  11 39 AD 76 DA 07 50 45
  can1  7A8   [8]  C4 8B 14 5E 83 F4 D1 25
Running cangen as lars (gid 1000)
write: No buffer space available
```

(Of course you will expect to see a different username.)

## Cleaning up

```
sudo bash cleanup.sh
```
