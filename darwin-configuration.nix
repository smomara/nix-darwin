{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      vim
      curl
      wget
      git
    ];

    shells = [
      pkgs.nushell
    ];

    variables = {
      EDITOR = "vim";
    };
  };

  nix = {
    enable = false;
    settings.experimental-features = "nix-command flakes";
  };

  system = {
    stateVersion = 6;

    primaryUser = "somara";

    defaults = {
      dock.autohide = true;
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false;
      };
    };
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  users.users.somara = {
    name = "somara";
    home = "/Users/somara";
    shell = pkgs.nushell;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
