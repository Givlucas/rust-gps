{
  description = "nn in rust";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };
  outputs = { self, nixpkgs }: 
  let
    systems = [ "x86_64-linux" "riscv64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.rustPlatform.buildRustPackage {
          name = "rs-mnist";
          version = "1.0.0";
          cargoLock = {
            lockFile = ./Cargo.lock;
          };
          src = self;
          buildInputs = [
            pkgs.rustc
            pkgs.cargo
            pkgs.rust-analyzer
            pkgs.lldb_9
            pkgs.gdb
            pkgs.pkg-config
          ];
          nativeBuildInputs = [
            pkgs.rustc
            pkgs.cargo
            pkgs.rust-analyzer
            pkgs.lldb_9
            pkgs.gdb
            pkgs.pkg-config
          ];
        };
      }
    );

    devShells = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        default = pkgs.mkShell {
          packages = [
            pkgs.rustc
            pkgs.cargo
            pkgs.rust-analyzer
            pkgs.lldb_9
            pkgs.gdb
            pkgs.pkg-config
          ];
          shellHook = ''
          echo "dev"
          RUST_BACKTRACE=1 test="dev" $SHELL
          echo "exiting dev"
          exit
          '';
        };
      }
    );
  };
}
