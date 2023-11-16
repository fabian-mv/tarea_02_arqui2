{ config, pkgs, ... }: {
  config =
    let
      inherit (config.networking) hostName;
    in
    {
      microvm = {
        volumes = [{
          mountPoint = "/var";
          image = "var-${hostName}.img";
          size = 256;
        }];

        shares = [{
          # use "virtiofs" for MicroVMs that are started by systemd
          proto = "9p";
          tag = "ro-store";
          # a host's /nix/store will be picked up so that no
          # squashfs/erofs will be built for it.
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
        }];

        hypervisor = "qemu";
        socket = "control-${hostName}.socket";
      };

      users.users.root.password = "";

      environment.systemPackages = [
        (pkgs.callPackage ./parteb.nix { })
      ];

      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "yes";
      };

      system.stateVersion = "23.05";

      programs.ssh.startAgent = true;

      environment.etc."passwords.txt".source = ./passwords.txt;
      environment.etc."mpi-hostfile".text = ''
                node0
                node1
                node2
                node3
        	  '';

      environment.variables."OMPI_ALLOW_RUN_AS_ROOT_CONFIRM" = "1";
    };
}
