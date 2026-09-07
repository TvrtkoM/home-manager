{
  description = "Home Manager configuration of tvrtko-majstorovic";

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
      system = "x86_64-linux";
      # Built with `import` (not legacyPackages) so we can attach a config:
      # `inherit pkgs` below bypasses the `nixpkgs.config` HM module option, so
      # unfree has to be whitelisted here. Predicate = only intelephense, rather
      # than a blanket allowUnfree.
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate =
          pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "intelephense" ];
      };
    in
    {
      homeConfigurations."tvrtko-majstorovic" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
