{
  description = "A nix-packaged Emacs distribution.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, emacs-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ emacs-overlay.overlay ];
        };

        configFile = pkgs.writeText "config.el" (builtins.readFile ./config.el);

        # Note that use-package will actually pull packages in for us, so this is
        # for *very* extra packages.
        extraPackages = epkgs: with epkgs; [ use-package general ];
      in {
        packages = {
          neomacs = pkgs.emacsWithPackagesFromUsePackage {
            config = ./config.el;
            alwaysEnsure = true;
            alwaysTangle = true;
            extraEmacsPackages = extraPackages;
          };

          neomacsAlias = pkgs.writeShellApplication {
            name = "neomacs";
            runtimeInputs = [ self.packages.${system}.neomacs ];
            text = "emacs -q -l ${configFile}";
          };
        };

        defaultPackage = self.packages.${system}.neomacsAlias;
      });
}
