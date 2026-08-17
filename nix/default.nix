{ stdenv, lib, xorg, kitty, dbus, bash, writeShellScript }:

let
  sessionStarter = writeShellScript "tender-session-start" ''
    # tender-session starter
    # Launches dbus session bus and kitty terminal
    
    if [ -z "''${DBUS_SESSION_BUS_ADDRESS}" ]; then
      eval "$(${dbus}/bin/dbus-launch --sh-syntax)"
    fi
    
    # Set up basic X11 environment variables if on X11
    if [ -n "''${DISPLAY}" ]; then
      export QT_QPA_PLATFORMTHEME=qt5ct
    fi
    
    # Start kitty terminal
    exec ${kitty}/bin/kitty
  '';
in
stdenv.mkDerivation {
  pname = "tender-session";
  version = "0.1.0";

  src = ./.;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/xsessions
    mkdir -p $out/bin

    # Install the session starter script
    cp ${sessionStarter} $out/bin/tender-session-start
    chmod +x $out/bin/tender-session-start

    # Install the .desktop file for session manager
    cp ${./tender-session.desktop} $out/share/xsessions/tender-session.desktop
    substitute $out/share/xsessions/tender-session.desktop \
      $out/share/xsessions/tender-session.desktop \
      --subst-var out
  '';

  meta = with lib; {
    description = "A clear and calm NixOS desktop session focused on kitty terminal";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
