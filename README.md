# My Nix home manager

## Before installing Nix (optional)

If system parttion is too small we need to mount new folder `/home/nix` onto `/nix` presuming `/home` is on another
partition.

```bash
sudo mkdir -p /home/nix /nix
echo '/home/nix /nix none bind 0 0' | sudo tee -a /etc/fstab
sudo mount /nix
```

---

Flakes need to be enabled after nix is installed. Currently experimental feature

```bash
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

## After nix is installed

Clone repository inside `~/.config/home-manager` and run

```bash
nix run home-manager/master -- switch
```

If that succeeds, there is `home-manager` cli in PATH and it should be used afterwards:

```
home-manager switch
```

## Cleaning up nix store

`nix-collect-garbage -d` will free up things nothing reference, but if there are leftover `result` symlinks or old
`nix develop` shells - this won't get freed.

Run `nix-store --gc --print-roots | grep -v /proc/` - shows what's holding on.

`nix-collect-garbage` without `-d` deletes non active shell packages.
