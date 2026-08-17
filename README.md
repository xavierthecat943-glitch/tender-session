# tender-session

A clear and calm NixOS desktop session focused on simplicity and functionality.

## Overview

tender-session is a minimal NixOS desktop session (like KDE Plasma or Hyprland) that removes unnecessary complexity. It boots directly into a kitty terminal without bloated UI frameworks, making it lightweight and transparent.

## Goals

- **Simplicity**: Easy to understand and install
- **Clarity**: Clear configuration and setup process
- **Functionality**: Focus on getting the session working reliably
- **Minimal**: Kitty terminal only, no graphical overhead

## Dependencies

### Required
- **NixOS** - The distribution this session is built for
- **X11/Wayland** - Display server (via `services.xserver`)
- **D-Bus** - System message bus (automatically enabled)
- **kitty** - Terminal emulator

### Automatically Handled
The following are automatically installed when you enable tender-session:
- `dbus` - Session and system bus
- Base display server libraries

### Your Configuration Needs
- **Flakes enabled** (if using the recommended method)
- **git** (optional, but recommended for cloning repositories)
- `services.xserver.enable = true` in your NixOS configuration

---

## Installation

### Quick Start (Recommended)

The simplest way to get tender-session is through your NixOS configuration using Flakes.

#### Prerequisites
- NixOS with Flakes enabled
- `git` in your `environment.systemPackages` (optional but recommended)
- X11 enabled (`services.xserver.enable = true`)

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

  # Enable X11 (required)
  services.xserver.enable = true;

  # Enable tender-session
  services.tender-session.enable = true;

  # Make sure git is available (optional but recommended)
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
  # Enable X11 (required)
  services.xserver.enable = true;

  # Enable D-Bus (required)
  services.dbus.enable = true;

  # Add git to your environment (optional)
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

## Common Problems

### Error: `does not provide attribute 'packages.x86_64-linux.nixosConfigurations.nixos'`

**Symptom:**
```
error: flake 'path:/home/xavier' does not provide attribute 'packages.x86_64-linux.nixosConfigurations.nixos'
```

**Cause:**
Your flake output structure doesn't match the expected format. This happens when the `nixosModules` export in tender-session isn't properly available.

**Solution:**
Make sure you've pulled the latest version of tender-session (commit `0ed73082` or later), which properly exports `nixosModules`. Then:

1. Update your flake lock file:
```bash
nix flake update
```

2. Rebuild:
```bash
sudo nixos-rebuild switch --flake .#your-hostname
```

---

### Error: `undefined variable 'tender-session'`

**Symptom:**
```
error: undefined variable 'tender-session'
at /etc/nixos/configuration.nix:12:7:
```

**Cause:**
You haven't passed `tender-session` as a `specialArg` in your `flake.nix`, or your flake configuration doesn't properly export it.

**Solution:**
1. Make sure your `flake.nix` includes `specialArgs`:
```nix
outputs = { self, nixpkgs, tender-session, ... }: {
  nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit tender-session; };  # ← This line is required
    modules = [
      ./configuration.nix
    ];
  };
};
```

2. Then rebuild:
```bash
sudo nixos-rebuild switch --flake .#your-hostname
```

---

### Session not appearing in login screen

**Symptom:**
You log in but don't see "Tender Session" as an option in the session dropdown.

**Cause:**
X11 or D-Bus is not enabled, or the session wasn't properly registered.

**Solution:**
1. Make sure `services.xserver.enable` is `true` in your configuration
2. Ensure `services.dbus.enable` is `true`
3. Rebuild with `sudo nixos-rebuild switch`
4. Check the display manager logs: `journalctl -u display-manager -n 50`

---

### Terminal not launching

**Symptom:**
You select Tender Session and log in, but nothing happens or the screen is black.

**Cause:**
kitty is not installed, or the session starter script is failing.

**Solution:**
1. Check that `kitty` is in your `environment.systemPackages` or enabled by the module
2. Verify the session logs: `journalctl -xe`
3. Check X11 is properly configured: `echo $DISPLAY` (should show something like `:0`)
4. Try running kitty manually: `kitty` (to see if it's a PATH issue)

---

### "Command not found" or dependency errors after rebuild

**Symptom:**
You see errors about missing packages or commands after running `nixos-rebuild switch`.

**Cause:**
The configuration didn't fully apply, or you're missing required dependencies.

**Solution:**
1. Ensure you've run `sudo nixos-rebuild switch` after updating configuration (not just `nixos-rebuild`)
2. Check that all dependencies are listed in your configuration
3. Try a full rebuild: `sudo nixos-rebuild switch --recreate-lock-file`
4. If using flakes, make sure to commit changes: `git add . && git commit -m "update"`

---

### Git tree is dirty error

**Symptom:**
```
warning: Git tree '/etc/nixos' is dirty
```

**Cause:**
You have uncommitted changes in your NixOS configuration directory when using flakes.

**Solution:**
```bash
cd /path/to/your/nixos-config
git add .
git commit -m "Update configuration"
sudo nixos-rebuild switch --flake .#your-hostname
```

---

## Development

See `CONTRIBUTING.md` for development guidelines.

## License

MIT
