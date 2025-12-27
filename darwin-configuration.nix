{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.vim
  ];

  nix = {
    enable = false;
    settings.experimental-features = "nix-command flakes";
  };

  system = {
    primaryUser = "somara";
    defaults = {
      dock.autohide = true;
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false;
      };
    };
    stateVersion = 6;
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  users.users.somara = {
    name = "somara";
    home = "/Users/somara";
  };
}
