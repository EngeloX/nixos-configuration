{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "cisco-packet-tracer";
  version = "8.2.2";

  src = ./CiscoPacketTracer822.deb;

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.dpkg
    pkgs.makeWrapper
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out
    cp -r opt/pt/* $out/
  '';

  postFixup = ''
    wrapProgram $out/bin/PacketTracer \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc
        pkgs.zlib
        pkgs.curl
        pkgs.openssl
      ]}"
  '';
}
