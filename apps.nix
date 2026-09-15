# applications
{ config, pkgs, ... }:

{
  # user apps
  environment.systemPackages = with pkgs; [
      # apps
      telegram-desktop
      discord
      pkgs.cisco-packet-tracer_9
    ];

  programs.steam.enable = true;
  programs.amnezia-vpn.enable = true;
}
