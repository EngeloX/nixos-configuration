# applications
{ config, pkgs, unstablePkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    telegram-desktop
    discord
    google-chrome
    (callPackage ./apps/packet-tracer {})
  ];

  programs.steam.enable = true;

  # AmneziaVPN берём ТОЛЬКО из nixos-unstable.
  programs.amnezia-vpn = {
    enable = true;
    package = unstablePkgs.amnezia-vpn;
  };

  # У unstable-версии Amnezia свои runtime-зависимости.
  # Не позволяем stable pkgs подставлять их в systemd PATH.
  systemd.services."AmneziaVPN".path = with unstablePkgs; [
    gawk
    iptables
    procps
    iproute2
    sudo
  ];
}
