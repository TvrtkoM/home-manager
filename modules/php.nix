# PHP toolchain shared by every host. Extra tools (php-cs-fixer, LSPs, ...)
# are added by the host files that want them.
{ config, pkgs, ... }:

let
  php = pkgs.php84.buildEnv {
    extraConfig = ''
      memory_limit = 1G
    '';
  };
in
{
  # Lets host files reach the same PHP env (e.g. `php.packages.php-cs-fixer`).
  _module.args.php = php;

  home.packages = [
    php
    php.packages.composer
  ];

  # Binaries from `composer global require` (e.g. the `laravel` installer).
  # COMPOSER_HOME defaults to XDG ~/.config/composer, so global bins land here.
  home.sessionPath = [ "$HOME/.config/composer/vendor/bin" ];
}
