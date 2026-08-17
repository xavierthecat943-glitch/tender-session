{ stdenv, lib, writeText, bash, kitty }:

stdenv.mkDerivation {
  pname = "tender-session";
  version = "0.1.0";

  src = ../.;

  installPhase = ''
    mkdir -p $out/share/xsessions
    mkdir -p $out/bin

    # Install the session starter script
    cp ${./session-starter.sh} $out/bin/tender-session
    chmod +x $out/bin/tender-session

    # Install the .desktop file for session manager
    cp ${./tender-session.desktop} $out/share/xsessions/tender-session.desktop
  '';

  meta = with lib; {
    description = "A clear and calm NixOS session installer focused on kitty terminal";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
