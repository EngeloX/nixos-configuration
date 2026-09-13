# applications
{ config, pkgs, ... }:

{
  # user apps
  environment.systemPackages = with pkgs; [
      telegram-desktop
      discord
    ];

  programs.steam.enable = true;
  programs.amnezia-vpn.enable = true;
}
