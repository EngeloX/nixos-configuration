# applications
{ config, pkgs, ... }:

{
  # user apps
  environment.systemPackages = with pkgs; [
      # apps
      telegram-desktop
      discord

      # Widgets
      plasma-panel-colorizer
      kdePackages.spectacle
      python3
      python3Packages.dbus-python
      python3Packages.pygobject3
    ];

  programs.steam.enable = true;
  programs.amnezia-vpn.enable = true;
}
