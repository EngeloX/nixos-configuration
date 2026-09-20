# terminal utilitas
{ config, pkgs, ... }:

{
  # konsole utilitas
  environment.systemPackages = with pkgs; [
      tree
      pciutils
      git
      git-lfs
    ];
}
