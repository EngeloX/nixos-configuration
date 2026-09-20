{ lib
, stdenv
, dpkg
, autoPatchelfHook
, makeWrapper

, glib
, fontconfig
, freetype

, systemd
, libdrm
, libGL
, libudev0-shim
, libxcb
, libX11
, libSM
, libICE
, libxkbcommon
, wayland

, xcbutil
, xcbutilimage
, xcbutilkeysyms
, xcbutilrenderutil
, xcbutilwm

, nss
, nspr
, libxml2_13
, libxslt

, libXcomposite
, libXdamage
, libXfixes
, libXrandr
, libXtst

, pulseaudio
, alsa-lib

, ...
}:

stdenv.mkDerivation rec {
  pname = "cisco-packet-tracer";
  version = "8.2.2";

  src = ./PacketTracer822.deb;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib

    # GLib / fonts
    glib
    fontconfig
    freetype

    # System / graphics
    systemd
    libdrm
    libGL
    libudev0-shim

    # X11
    libX11
    libSM
    libICE
    libXcomposite
    libXdamage
    libXfixes
    libXrandr
    libXtst

    # XCB
    libxcb
    xcbutil
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm

    # Keyboard / Wayland
    libxkbcommon
    wayland

    # Qt WebEngine
    nss
    nspr
    libxml2_13.out
    libxslt

    # Audio
    pulseaudio
    alsa-lib
  ];

  runtimeDependencies = [
    libxml2_13.out
    libudev0-shim
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';



  installPhase = ''
    mkdir -p $out
    cp -r opt $out/

    # Qt WebEngine ожидает Chromium resources
    # в подкаталоге bin/resources.
    mkdir -p $out/opt/pt/bin/resources

    ln -s ../icudtl.dat \
      $out/opt/pt/bin/resources/icudtl.dat

    ln -s ../qtwebengine_resources.pak \
      $out/opt/pt/bin/resources/qtwebengine_resources.pak

    ln -s ../qtwebengine_resources_100p.pak \
      $out/opt/pt/bin/resources/qtwebengine_resources_100p.pak

    ln -s ../qtwebengine_resources_200p.pak \
      $out/opt/pt/bin/resources/qtwebengine_resources_200p.pak

    mkdir -p $out/opt/pt/bin/translations

    ln -s ../qtwebengine_locales \
      $out/opt/pt/bin/translations/qtwebengine_locales
  '';




  postFixup = ''
    mkdir -p $out/bin

    cat > $out/bin/PacketTracer <<EOF
  #!/bin/sh

  export LD_LIBRARY_PATH="${libudev0-shim}/lib:\$LD_LIBRARY_PATH"

  cd "$out/opt/pt/bin" || exit 1
  exec "$out/opt/pt/bin/PacketTracer" "\$@"
  EOF

    chmod +x $out/bin/PacketTracer
  '';




  meta = {
    description = "Cisco Packet Tracer";
    homepage = "https://www.netacad.com/cisco-packet-tracer";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
