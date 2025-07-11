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
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      makeOptionsDoc =
        configuration:
        pkgs.nixosOptionsDoc {
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
        (makeOptionsDoc (
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
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
      packages = {
        ${system} = {
          inherit hmOptionsJSON;
        };
      };
    };
}
