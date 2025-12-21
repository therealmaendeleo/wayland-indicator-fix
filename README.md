# Layout Indicator Fix

A tiny utility that fixes Wayland layout indicator not updating in elementary OS wingpanel.

## Installation

```bash
git clone https://github.com/your-username/seamless-layout-indicator
cd seamless-layout-indicator
./setup.sh
```

For uninstall, use:

```bash
~/.local/bin/uninstall.sh
```

## How It Works

Monitors GSettings changes and updates wingpanel indicator without restart.

## Compatibility

- ✅ elementary OS 8 (Wayland)
- ⚠️ Ubuntu 22.04+ with wingpanel

## Requirements

- `gsettings` (GNOME Settings API)
- `pgrep`, `killall` (procps)
- elementary OS with wingpanel
- Wayland session

## Warning

Tested only on elementary OS 8 Wayland.
