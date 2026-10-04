# My Nix home manager

Two configurations live in this repo; the config names match the usernames, so a plain `home-manager switch` picks the
right one on each machine:

| Machine                | Config name          | Entry point       |
| ---------------------- | -------------------- | ----------------- |
| Linux (personal)       | `tvrtko-majstorovic` | `hosts/linux.nix` |
| MacBook (work, Apple Silicon) | `tvrtkomajstorovic`  | `hosts/mac.nix`   |

Shared config lives in `modules/` (`common.nix`, `php.nix`); each host file imports what it needs.

On the Mac, Nix has to be the multi-user install (e.g. the Determinate Systems installer, which enables flakes). Then:

```bash
nix run home-manager/master -- switch --flake .#tvrtkomajstorovic
```

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

`home-manager expire-generations "-30 days"`
`nix-collect-garbage -d` will free up things nothing reference, but if there are leftover `result` symlinks or old
`nix develop` shells - this won't get freed.

Run `nix-store --gc --print-roots | grep -v /proc/` - shows what's holding on.

`nix-collect-garbage` without `-d` deletes non active shell packages.

## Updating flake

`nix flake update` rewrites `flake.lock`. Ater, run `home-manager switch`.

## Rolling back to older generation if `switch` breaks something

```bash
home-manager generations # list generations
/nix/store/...-home-manager-generation/activate # run this to activate specific generation
```
