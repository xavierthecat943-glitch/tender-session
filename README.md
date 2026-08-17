# tender-session

A clear and calm NixOS desktop session focused on simplicity and functionality.

## Overview

tender-session is a minimal NixOS desktop session (like KDE Plasma or Hyprland) that removes unnecessary complexity. It boots directly into a kitty terminal without bloated UI frameworks, making it lightweight and transparent.

## Goals

- **Simplicity**: Easy to understand and install
- **Clarity**: Clear configuration and setup process
- **Functionality**: Focus on getting the session working reliably
- **Minimal**: Kitty terminal only, no graphical overhead

## Installation

### Quick Start (Recommended)

The simplest way to get tender-session is through your NixOS configuration using Flakes.

#### Prerequisites
- NixOS with Flakes enabled
- `git` in your `environment.systemPackages`

#### Step 1: Update your `flake.nix`

Add tender-session to your inputs:

```nix
{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    tender-session.url = "github:xavierthecat943-glitch/tender-session";
    tender-session.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, tender-session, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit tender-session; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
```

#### Step 2: Update your `configuration.nix`

Add the module and enable the session:

```nix
{ config, pkgs, tender-session, ... }:

{
  imports = [
    tender-session.nixosModules.default
  ];

  # Enable tender-session
  services.tender-session.enable = true;

  # Make sure git is available (you likely already have this)
  environment.systemPackages = with pkgs; [
    git
  ];
}
```

#### Step 3: Rebuild and switch

```bash
sudo nixos-rebuild switch --flake .#your-hostname
```

---

### Alternative: Using `environment.systemPackages`

If you prefer to add it as a simple package without the full module:

1. Build the package locally:
```bash
git clone https://github.com/xavierthecat943-glitch/tender-session /tmp/tender-session
cd /tmp/tender-session
nix flake show
```

2. In your `configuration.nix`, add the path to your packages:

```nix
{ config, pkgs, ... }:

{
  # Add git to your environment
  environment.systemPackages = with pkgs; [
    git
  ];

  # Build and add tender-session from the local path
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage /path/to/tender-session/nix/default.nix { })
  ];
}
```

Then rebuild:
```bash
sudo nixos-rebuild switch
```

---

## Usage

1. **Reboot your system**
   ```bash
   sudo reboot
   ```

2. **At the login screen**, select **Tender Session** from the session dropdown menu (usually in the bottom-left corner)

3. **Log in** with your credentials

4. **kitty terminal** will launch automatically

---

## Troubleshooting

### Session not appearing in login screen
- Make sure `services.xserver.enable` is `true` in your configuration
- Ensure `services.dbus.enable` is `true`
- Rebuild with `sudo nixos-rebuild switch`

### Terminal not launching
- Check that `kitty` is in your `environment.systemPackages`
- Verify the session logs: `journalctl -xe`

---

## Development

See `CONTRIBUTING.md` for development guidelines.

## License

MIT
