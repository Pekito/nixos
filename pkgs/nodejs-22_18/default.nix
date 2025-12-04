# Custom Node.js 22.18.0 package
{ pkgs, stdenv, lib, fetchurl, autoPatchelfHook, zlib, icu, openssl }:

stdenv.mkDerivation rec {
  pname = "nodejs";
  version = "22.18.0";
  
  src = fetchurl {
    url = "https://nodejs.org/download/release/v${version}/node-v${version}-linux-x64.tar.xz";
    sha256 = "sha256-wb/uzx10BPp0co+dty5pfey9gRnMxvWilNeVdW38/Kc=";
  };
  
  nativeBuildInputs = [
    autoPatchelfHook
  ];
  
  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    icu
    openssl
  ];
  
  dontBuild = true;
  
  installPhase = ''
    runHook preInstall
    
    mkdir -p $out
    cp -r bin lib include share $out/
    
    runHook postInstall
  '';
  
  meta = with lib; {
    description = "Node.js v22.18.0 from official release";
    homepage = "https://nodejs.org";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "node";
  };
}
