{
  description = "A very basic flake";

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

        # Note that use-package will actually pull packages in for us, so this is
        # for *very* extra packages.
        extraPackages = epkgs: with epkgs; [ use-package ];
      in {
        packages = {
          neomacs = pkgs.emacsWithPackagesFromUsePackage {
            config = ./config.org;
            alwaysEnsure = true;
            alwaysTangle = true;
            extraEmacsPackages = extraPackages;
          };

          neomacsAlias = pkgs.writeShellApplication {
            name = "neomacs";
            runtimeInputs = [ self.packages.${system}.neomacs ];
            text = "emacs";
          };
        };

        defaultPackage = self.packages.${system}.neomacs;
      });
}
