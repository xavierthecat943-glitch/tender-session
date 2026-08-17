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

### Option 1: Using the NixOS Module (Recommended)

Add this to your `flake.nix`:

```nix
inputs = {
  tender-session.url = "github:xavierthecat943-glitch/tender-session";
  tender-session.inputs.nixpkgs.follows = "nixpkgs";
};
```

Then in your `configuration.nix`:

```nix
{
  imports = [
    inputs.tender-session.nixosModules.default
  ];
  
  services.tender-session.enable = true;
}
```

### Option 2: Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/xavierthecat943-glitch/tender-session
cd tender-session
```

2. Build and install:
```bash
nix flake show
nix profile install .
```

3. Add to your NixOS configuration:
```nix
environment.systemPackages = with pkgs; [
  tender-session
];
```

## Usage

1. Reboot your system
2. At the login screen, select **Tender Session** from the session dropdown
3. Log in with your credentials
4. kitty terminal will launch

## Development

See `CONTRIBUTING.md` for development guidelines.

## License

MIT
