{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tender-session;
  tender-session-pkg = pkgs.callPackage ./default.nix { };
in
{
  options.services.tender-session = {
    enable = mkEnableOption "tender-session desktop session";

    package = mkPackageOption pkgs "tender-session" { };
  };

  config = mkIf cfg.enable {
    # Ensure X server is enabled
    services.xserver.enable = true;
    
    # Register the session with the display manager
    services.xserver.displayManager.sessionPackages = [ cfg.package ];

    # Ensure necessary packages are available systemwide
    environment.systemPackages = with pkgs; [
      cfg.package
      kitty
      dbus
    ];

    # Required for session to work properly
    services.dbus.enable = true;
  };
}
