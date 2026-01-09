{
  description = "Home Manager configuration of see2et";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      rust-overlay,
      ...
    }:
    let
      overlays = [ rust-overlay.overlays.default ];

      mkPkgs =
        system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };

      mkHome =
        system:
        let
          pkgs = mkPkgs system;
          rustToolchain = pkgs.rust-bin.stable.latest.default.override {
            extensions = [
              "rust-src"
              "clippy"
              "rustfmt"
            ];
          };
          isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit isDarwin rustToolchain; };
        };
    in
    {
      homeConfigurations."nixos" = mkHome "x86_64-linux";
      homeConfigurations."darwin" = mkHome "aarch64-darwin";
    };
}
