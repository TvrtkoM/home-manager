# Work MacBook (Apple Silicon): a trimmed-down subset of the Linux setup.
{ config, pkgs, ... }:

{
  imports = [
    ../modules/common.nix
    ../modules/php.nix
  ];

  home.username = "tvrtkomajstorovic";
  home.homeDirectory = "/Users/tvrtkomajstorovic";

  programs.git.settings.user.email = "tvrtko.majstorovic@appliment.eu";

  # JetBrains Mono Nerd Font (from common.nix) is copied to
  # ~/Library/Fonts/HomeManager automatically by Home Manager on macOS.

  # pbcopy ships with macOS, so it replaces xclip.
  programs.tmux.extraConfig = ''
    bind -T copy-mode    MouseDragEnd1Pane send -X copy-pipe-and-cancel "pbcopy"
    bind -T copy-mode    Enter             send -X copy-pipe-and-cancel "pbcopy"
    bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "pbcopy"
    bind -T copy-mode-vi Enter             send -X copy-pipe-and-cancel "pbcopy"
  '';
}
