{ config, pkgs, username, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./apps.nix
      ./utils.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Omsk";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.enable = false;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = username;

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # ============================================================
  # АВТОМАТИЧЕСКОЕ ОБНОВЛЕНИЕ ТОЛЬКО AMNEZIA VPN
  # ============================================================

  systemd.services.update-amnezia = {
    description = "Check and update AmneziaVPN from nixos-unstable";

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      WorkingDirectory = "/etc/nixos";
    };

    script = ''
      set -eu

      FLAKE="/etc/nixos"
      LOCK="$FLAKE/flake.lock"

      # Запоминаем состояние lock-файла до проверки.
      OLD_HASH="$(${pkgs.coreutils}/bin/sha256sum "$LOCK" | ${pkgs.gawk}/bin/awk '{print $1}')"

      echo "Checking nixos-unstable for AmneziaVPN updates..."

      # Обновляем ТОЛЬКО nixpkgs-unstable.
      # nixpkgs (26.05), home-manager и plasma-manager
      # здесь не обновляются.
      ${pkgs.nix}/bin/nix flake update nixpkgs-unstable --flake "$FLAKE"

      NEW_HASH="$(${pkgs.coreutils}/bin/sha256sum "$LOCK" | ${pkgs.gawk}/bin/awk '{print $1}')"

      if [ "$OLD_HASH" = "$NEW_HASH" ]; then
        echo "No changes in nixpkgs-unstable."
        exit 0
      fi

      echo "nixos-unstable changed. Rebuilding NixOS..."

      ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch \
        --flake "$FLAKE#nixos"

      # После записи lock-файла root возвращаем владельцем
      # обычного пользователя, чтобы ты мог редактировать его без sudo.
      ${pkgs.coreutils}/bin/chown ${username} "$LOCK"

      echo "AmneziaVPN update check completed."
    '';
  };

  systemd.timers.update-amnezia = {
    description = "Hourly AmneziaVPN update check";

    wantedBy = [
      "timers.target"
    ];

    timerConfig = {
      # Проверять каждый час.
      OnCalendar = "hourly";

      # Если компьютер был выключен во время запуска —
      # выполнить пропущенную проверку после включения.
      Persistent = true;

      # Не запускать несколько проверок одновременно.
      RandomizedDelaySec = "5min";
    };
  };
}
