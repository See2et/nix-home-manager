{
  description = "NixOS (WSL) + Home Manager configuration of see2et";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
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

      mkRustToolchain =
        pkgs:
        pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "clippy"
            "rustfmt"
          ];
        };

      pkgsLinux = mkPkgs "x86_64-linux";
      pkgsDarwin = mkPkgs "aarch64-darwin";

      rustLinux = mkRustToolchain pkgsLinux;
      rustDarwin = mkRustToolchain pkgsDarwin;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix

          (
            { ... }:
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config.allowUnfree = true;
            }
          )

          (
            { pkgs, ... }:
            {
              programs.zsh.enable = true;
              users.users.nixos.shell = pkgs.zsh;
              users.defaultUserShell = pkgs.zsh;

              services.pcscd.enable = true;
              services.udev.enable = true;
              services.udev.packages = [ pkgs.yubikey-personalization ];

              programs.gnupg.agent = {
                enable = true;
                enableSSHSupport = true;
              };
            }
          )

          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.05";
            wsl.enable = true;

            wsl.usbip.enable = true;
            # wsl.usbip.autoAttach = [ "1-9" ]; # replace with BUSID from `usbipd list` in PowerShell
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.nixos = import ./home.nix;

            home-manager.extraSpecialArgs = {
              isDarwin = false;
              rustToolchain = rustLinux;
            };
          }
        ];
      };

      homeConfigurations = {
        nixos = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsLinux;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            isDarwin = false;
            rustToolchain = rustLinux;
          };
        };

        darwin = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsDarwin;
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            isDarwin = true;
            rustToolchain = rustDarwin;
          };
        };
      };
    };
}
