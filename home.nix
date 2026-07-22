{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tvrtko-majstorovic";
  home.homeDirectory = "/home/tvrtko-majstorovic";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    ripgrep
    nb
    fd
    fzf
    htop
    jq
    tmux
    pass
    tree-sitter
    nerd-fonts.jetbrains-mono
    tinty
    ghostty

    nodejs_24

    # language servers and formatters
    vtsls
    lua-language-server
    vscode-langservers-extracted
    prettierd
    nixd
    nixfmt

    luarocks
  ];

  # Makes fonts from home.packages visible to fontconfig by writing
  # ~/.config/fontconfig/conf.d/10-hm-fonts.conf pointing at the Nix profile.
  fonts.fontconfig.enable = true;

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
      theme = "robbyrussell";
      plugins = [
        "git"
        "fzf"
      ];
    };

    # initialization commands
    initContent = ''
      # Single-user Nix install: nothing at the system level puts Nix on PATH.
      # The Nix installer appends this to ~/.zshrc, but Home Manager owns that
      # file now and regenerates it, so it has to live here to survive a switch.
      if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi

      tinty init
    '';
  };

  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Tvrtko Majstorović";
        email = "tvrtkomaj@gmail.com";
      };
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    terminal = "tmux-256color";
    extraConfig = ''
      set -g mouse on
      set -as terminal-features \",xterm-256color:RGB\"
      set -as terminal-features \",xterm-256color:usstyle\"
      set -g allow-passthrough on
      set -g focus-events on
      bind -T copy-mode    MouseDragEnd1Pane send -X copy-pipe-and-cancel "xclip -i -selection clipboard"
      bind -T copy-mode    Enter             send -X copy-pipe-and-cancel "xclip -i -selection clipboard"
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "xclip -i -selection clipboard"
      bind -T copy-mode-vi Enter             send -X copy-pipe-and-cancel "xclip -i -selection clipboard"
    '';
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".npmrc".text = ''
      min-release-age=3
      ignore-scripts=true
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tvrtko-majstorovic/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    CLAUDE_CODE_TMUX_TRUECOLOR = 1;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
