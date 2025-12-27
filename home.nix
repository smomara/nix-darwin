{
  pkgs,
  ...
}:

let
  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpk+A7VTz5xCg1hfjSViJXTz0sT3SMq1c6c2+5YO8KP mseanomara@gmail.com";
  email = "mseanomara@gmail.com";
  name = "Sean O'Mara";

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
      spotify
    ];

    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "less";
      SHELL = "${pkgs.nushell}/bin/nu";
    };

    file = {
      ".ssh/allowed_signers" = {
        text = "${email} ${sshPublicKey}";
      };
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";
    image = conversionOfStPaul;
    polarity = "dark";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
      sizes = {
        applications = 12;
        terminal = 13;
        desktop = 12;
        popups = 12;
      };
    };
  };

  programs = {
    nushell = {
      enable = true;
      extraConfig = ''
        $env.PATH = [ "~/.nix-profile/bin" "/run/current-system/sw/bin" "/etc/profiles/per-user/somara/bin" ] ++ $env.PATH
      '';
    };

    kitty = {
      enable = true;
      settings = {
        shell = "${pkgs.nushell}/bin/nu";
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
          addKeysToAgent = "yes";
        };
      };
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = name;
          email = email;
        };

        core.editor = "hx";

        init = {
          defaultBranch = "master";
        };

        push = {
          autoSetupRemote = true;
        };

        pull = {
          rebase = true;
        };

        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
        commit.gpgsign = true;
        tag.gpgsign = true;
      };
    };

    helix = {
      enable = true;
      settings = {
        editor = {
          line-number = "relative";
          cursorline = true;
          color-modes = true;
          lsp.display-messages = true;
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
