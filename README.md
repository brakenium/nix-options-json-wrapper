# Stylix options.json generator

This repository provides a Nix flake that generates a `hmOptions.json` file containing the Home Manager options for Stylix. It is designed to be used as a remote flake, so you can fetch the generated options from anywhere using Nix commands.

## Usage

### Build the options JSON file

To build the `hmOptions.json` file and place it in the `result` directory:

```sh
nix build github:brakenium/nix-options-json-wrapper#hmOptionsJSON
```

The resulting file will be at `./result` (symlinked to `hmOptions.json`).

### How it works

- The flake imports Stylix, Home Manager, and Nixpkgs.
  - To avoid manually updating the flake, we delete flake.lock.
- It constructs a minimal Home Manager configuration with Stylix modules.
- It uses `nixosOptionsDoc` to generate the options documentation in JSON format.
- The output is exposed as a buildable package named `hmOptionsJSON`.

## License

See the repository for license information.
