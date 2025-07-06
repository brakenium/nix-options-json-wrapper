{
  description = "Stylix options.json generator";

  inputs.stylix.url = "github:nix-community/stylix";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs =
    {
      nixpkgs,
      stylix,
      home-manager,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      makeOptionsDoc =
        system: configuration:
        nixpkgsFor.${system}.nixosOptionsDoc {
          inherit (configuration) options;
          # Filter out any options not beginning with `stylix`
          transformOptions =
            option:
            option
            // {
              visible = option.visible && builtins.elemAt option.loc 0 == "stylix";
            };
        };

      hmOptionsJSON =
        system:
        (makeOptionsDoc system (
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgsFor.${system};
            modules = [
              stylix.homeModules.stylix
              (stylix + "/doc/hm_compat.nix")
              {
                home = {
                  homeDirectory = "/home/book";
                  stateVersion = "22.11";
                  username = "book";
                };
              }
            ];
          }
        )).optionsJSON;
    in
    {
      packages = forAllSystems (system: {
        hmOptionsJSON = hmOptionsJSON system;
      });
    };
}
