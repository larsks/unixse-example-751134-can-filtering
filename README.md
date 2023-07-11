# Rejecting CAN packets by UID

Part of <https://unix.stackexchange.com/q/751134/4989>.

## Requirements

You will need:

- [`socat`](http://www.dest-unreach.org/socat/)
- [`nftables`](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)
- `sudo` access

## Running the tests

As a non-`root` user with `sudo` access (because the script relies on the `SUDO_USER` and `SUDO_GID` environment variables to select a non-`root` account for the blocking rule):

```
sudo bash testcan.sh
```

Expected output:

```
creating virtual cable
creating interface can0
creating interface can1
Running cangen as root
  can1  14B   [8]  E9 2F 91 35 93 BE 89 0A
  can1  790   [7]  D1 AE A8 60 1D D4 A7
  can1  36A   [8]  A1 3D A9 22 D0 21 9E 55
  can1  4EC   [8]  78 EC 0C 77 BD ED F8 07
Running cangen as lars (gid 1000)
write: No buffer space available
```

(Of course you will expect to see a different username.)

## Cleaning up

```
sudo bash cleanup.sh
```
