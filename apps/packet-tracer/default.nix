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
    glib
    fontconfig
    freetype
    systemd
    libdrm
    libGL
    libxcb
    libX11
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
