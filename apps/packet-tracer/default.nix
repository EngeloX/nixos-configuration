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
, libxcb
, libX11
, libSM
, libICE
, libxkbcommon
, libxkbcommon
, wayland
, nss
, nspr
, libXcomposite
, libXdamage
, libXfixes
, libXrandr
, libXtst
, libxml2
, libxslt
, xcb-util-cursor
, xcb-util-image
, xcb-util-keysyms
, xcb-util-renderutil
, xcb-util-wm
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

    # system / graphics
    systemd
    libdrm
    libGL

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
    xcb-util-cursor
    xcb-util-image
    xcb-util-keysyms
    xcb-util-renderutil
    xcb-util-wm

    # keyboard / Wayland
    libxkbcommon
    wayland

    # Qt WebEngine
    nss
    nspr
    libxml2
    libxslt

    # audio
    pulseaudio
    alsa-lib
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out
    cp -r opt/pt/* $out/
  '';

  postFixup = ''
    wrapProgram $out/bin/PacketTracer
  '';

  meta = {
    description = "Cisco Packet Tracer";
    homepage = "https://www.netacad.com/cisco-packet-tracer";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
