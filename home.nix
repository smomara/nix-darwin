{
  config,
  lib,
  pkgs,
  ...
}:

let
  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpk+A7VTz5xCg1hfjSViJXTz0sT3SMq1c6c2+5YO8KP mseanomara@gmail.com";

  conversionOfStPaul = pkgs.fetchurl {
    url = "https://api.nga.gov/iiif/50a2866d-de51-4824-a6b6-6c8643d94335/full/full/0/default.jpg?attachment_filename=the_conversion_of_saint_paul_1961.9.43.jpg";
    sha256 = "sha256-X7NQOiEYJbzitv0KGRVfnLGQKzENQJDeJyD6PUkDR78=";
  };
in
{
  home = {
    stateVersion = "26.05";

    packages = with pkgs; [
      cabal-install
      dhall
      dhall-lsp-server
      fourmolu
      gh
      ghc
      haskell-language-server
      hlint
      nil

      kitty
      nerd-fonts.fira-code

      spotify
    ];

    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };

    file = {
      "paul-tintoretto.jpg".source = conversionOfStPaul;
      ".ssh/allowed_signers".text = "mseanomara@gmail.com ${sshPublicKey}";

      ".config/kitty/kitty.conf".text = ''
        font_family       FiraCode Nerd Font Mono
        font_size         13.0
        disable_ligatures never
      '';
    };

    activation.setWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to "${config.home.homeDirectory}/paul-tintoretto.jpg"'
    '';
  };

  programs = {
    bash.enable = true;

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Sean O'Mara";
          email = "mseanomara@gmail.com";
        };

        core.editor = "hx";

        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
        commit.gpgsign = true;
        tag.gpgsign = true;
      };
    };

    helix = {
      enable = true;
      settings = {
        theme = "gruvbox_dark_hard";
        editor = {
          line-number = "relative";
          cursorline = true;
          color-modes = true;
        };
      };

      languages = {
        language-server = {
          haskell-language-server = {
            command = "haskell-language-server-wrapper";
            args = [ "--lsp" ];
          };

          dhall-lsp-server = {
            command = "dhall-lsp-server";
          };

          nil = {
            command = "nil";
          };
        };

        language = [
          {
            name = "haskell";
            language-servers = [ "haskell-language-server" ];
            formatter = {
              command = "fourmolu";
            };
          }

          {
            name = "dhall";
            language-servers = [ "dhall-lsp-server" ];
          }

          {
            name = "nix";
            language-servers = [ "nil" ];
          }
        ];
      };
    };

    tmux = {
      enable = true;
      terminal = "screen-256color";
      clock24 = true;
    };

  };
}
