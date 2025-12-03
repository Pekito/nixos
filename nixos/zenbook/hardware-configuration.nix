# TODO: Generate this file on the Zenbook laptop by running:
#   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
#
# This is a placeholder configuration. Replace with actual hardware config.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # TODO: Replace these with actual values from nixos-generate-config
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];  # or kvm-amd depending on CPU
  boot.extraModulePackages = [ ];

  # TODO: Replace with actual filesystem UUIDs
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/REPLACE-WITH-ACTUAL-UUID";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
