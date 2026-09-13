# applications
{ config, pkgs, ... }:

{
  # user apps
  environment.systemPackages = with pkgs; [
      # apps
      telegram-desktop
      discord
      kdePackages.kolourpaint
    ];

  programs.steam.enable = true;
  programs.amnezia-vpn.enable = true;
}
