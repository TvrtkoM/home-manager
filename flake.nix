{
  description = "Home Manager configurations of tvrtko-majstorovic";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      # Built with `import` (not legacyPackages) so we can attach a config:
      # `inherit pkgs` below bypasses the `nixpkgs.config` HM module option, so
      # unfree has to be whitelisted here. Predicate = only intelephense, rather
      # than a blanket allowUnfree.
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "intelephense" ];
        };
    in
    {
      # Config names match the usernames, so a plain `home-manager switch`
      # picks the right one on each machine.
      homeConfigurations = {
        # Personal Linux machine.
        "tvrtko-majstorovic" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          modules = [ ./hosts/linux.nix ];
        };

        # Work MacBook (Apple Silicon).
        "tvrtkomajstorovic" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "aarch64-darwin";
          modules = [ ./hosts/mac.nix ];
        };
      };
    };
}
