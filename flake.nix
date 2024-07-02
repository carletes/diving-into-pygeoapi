{
  description = "Diving into pygeopai";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            docker-compose
            python3

            # Keep this line if you use bash.
            bashInteractive
          ];

          shellHook = ''
            if [ ! -d .venv ] ; then
              ${pkgs.python311}/bin/python3 -m venv .venv
            fi
            . ./.venv/bin/activate

            if [ ! -r ./.venv/.done ] ; then
              python3 -m pip install \
                setuptools_rust \
                wheel
              python3 -m pip install \
                -r workshop/content/requirements.txt
              touch ./.venv/.done
            fi
          '';
        };
      });
}
