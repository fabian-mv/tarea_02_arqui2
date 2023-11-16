{
  description = "NixOS in MicroVMs";

  inputs.microvm.url = "github:astro/microvm.nix";
  inputs.microvm.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, microvm }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      vms = map (n: "node" + toString n) [ 0 1 2 3 ];
    in
    with pkgs.lib; {
      formatter.${system} = pkgs.nixpkgs-fmt;

      packages.${system} = mapAttrs
        (_: system: system.config.microvm.declaredRunner)
        self.nixosConfigurations;

      nixosConfigurations = mapAttrs
        (name: _:
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              microvm.nixosModules.microvm
              ./system.nix
              { networking.hostName = name; }
            ];
          }
        )
        (listToAttrs (map (name: nameValuePair name null) vms));
    };
}
