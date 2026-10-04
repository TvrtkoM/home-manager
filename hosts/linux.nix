# Personal Linux machine: the full setup.
{
  config,
  lib,
  pkgs,
  php,
  ...
}:

let
  # laravel-ls: Laravel language server (Go). Not in nixpkgs, so built here.
  laravel-ls = pkgs.buildGoModule rec {
    pname = "laravel-ls";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "laravel-ls";
      repo = "laravel-ls";
      rev = "v${version}";
      hash = "sha256-RR3qYi8Lyx+z+KmpQj456P5youINDxQzfv9cyhrywEs=";
    };
    # It bundles tree-sitter grammars whose C sources live outside the imported
    # Go package; `go mod vendor` strips them and cgo fails. proxyVendor keeps
    # the full module cache instead (and changes vendorHash).
    proxyVendor = true;
    vendorHash = "sha256-fWbB4FclmSnfQxKFetn5RCPY1jlsm7PeO3VFAZresr4=";
    subPackages = [ "cmd/laravel-ls" ];
    ldflags = [
      "-s"
      "-w"
      "-X main.version=${version}"
    ];
    meta.mainProgram = "laravel-ls";
  };
in
{
  imports = [
    ../modules/common.nix
    ../modules/php.nix
  ];

  home.username = "tvrtko-majstorovic";
  home.homeDirectory = "/home/tvrtko-majstorovic";

  programs.git.settings.user.email = "tvrtkomaj@gmail.com";

  home.packages = with pkgs; [
    pass
    xclip
    htop
    fd
    tinty

    rustup

    php.packages.php-cs-fixer # PHP formatter (conform runs `php-cs-fixer`)
    intelephense # PHP LSP (unfree — whitelisted in flake.nix)
    laravel-ls # Laravel LSP for blade (defined in the let block)
    frankenphp

    basedpyright
    ruff
    uv

    emmet-language-server
    blade-formatter
  ];

  # Makes fonts from home.packages visible to fontconfig by writing
  # ~/.config/fontconfig/conf.d/10-hm-fonts.conf pointing at the Nix profile.
  fonts.fontconfig.enable = true;

  programs.zsh.oh-my-zsh.plugins = lib.mkAfter [ "pass" ];

  programs.zsh.initContent = lib.mkMerge [
    # Must run before anything that needs Nix binaries on PATH (e.g. tinty).
    (lib.mkBefore ''
      # Single-user Nix install: nothing at the system level puts Nix on PATH,
      # and ~/.profile (which used to) is gone, so this has to source nix.sh.
      if [ -z "''${__NIX_PROFILE_SOURCED-}" ]; then
        export __NIX_PROFILE_SOURCED=1
        if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
          . "$HOME/.nix-profile/etc/profile.d/nix.sh"
        fi
      fi
    '')
    ''
      # using xclip instead wl-copy for pass
      pass() { WAYLAND_DISPLAY= command pass "$@" }
    ''
  ];

  programs.tmux.extraConfig = ''
    bind -T copy-mode    MouseDragEnd1Pane send -X copy-pipe-and-cancel "xclip -i -selection clipboard"
    bind -T copy-mode    Enter             send -X copy-pipe-and-cancel "xclip -i -selection clipboard"
    bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "xclip -i -selection clipboard"
    bind -T copy-mode-vi Enter             send -X copy-pipe-and-cancel "xclip -i -selection clipboard"
  '';

  home.sessionPath = [
    # Binaries from `cargo install`
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables.CLAUDE_CODE_TMUX_TRUECOLOR = 1;
}
