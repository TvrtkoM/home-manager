# Shared by every host: shell, git, tmux, neovim and its language servers.
{ config, pkgs, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. Don't change it without reading the release notes.
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    ripgrep
    neovim
    lazygit
    starship
    nb
    fzf
    jq
    tmux
    tree-sitter
    nerd-fonts.jetbrains-mono

    nodejs_24

    # language servers and formatters
    vtsls
    lua-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    vue-language-server
    prettierd
    nixd
    nixfmt

    luarocks

    direnv
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
    };

    oh-my-zsh = {
      enable = true;
      theme = "";
      # Hosts append their own plugins (e.g. "pass" on Linux).
      plugins = [
        "git"
        "fzf"
      ];
    };

    initContent = ''
      tinty init
    '';
  };

  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";
      user.name = "Tvrtko Majstorović";
      # user.email is set per host.
    };

    # Writes ~/.config/git/ignore and points core.excludesfile at it.
    ignores = [
      ".history/"
      "node_modules/"
      "tmp/"
      "dist/"
      "**/.claude/settings.local.json"
    ];
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      nix_shell = {
        symbol = "❄ ";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    terminal = "tmux-256color";
    # Clipboard bindings are per host (xclip on Linux, pbcopy on macOS).
    extraConfig = ''
      set -g mouse on
      set -as terminal-features \",xterm-256color:RGB\"
      set -as terminal-features \",xterm-256color:usstyle\"
      set -g allow-passthrough on
      set -g focus-events on
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  home.file.".npmrc".text = ''
    min-release-age=3
    ignore-scripts=true
  '';

  home.sessionPath = [
    # pipx, pip --user, and anything else following the XDG user-binary convention.
    "$HOME/.local/bin"
    "$HOME/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
