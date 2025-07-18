# Anti-Fall Vehicle Protection for FiveM

Prevents players from accidentally falling off vehicles at low speeds, with configurable speed thresholds and on-screen notifications.

## Features

- Prevents falling off vehicles below a configurable speed (default 250 KM/H)
- Commands to enable/disable anti-fall protection:
  - `/fall` — Enable falling off vehicles (disable protection)
  - `/unfall` — Disable falling off vehicles (enable protection)
  - `/fallstatus` — Show current status of anti-fall protection
- On-screen notifications displayed top-right with fade out effect
- Sound notification on falling off and command usage (configurable)
- Detects when player actually falls off the vehicle and notifies
- Lightweight and easy to configure

## Installation

1. Place the resource folder (e.g. `anti_fall`) into your server's `resources` directory.
2. Add the following line to your `server.cfg`:
3. Restart your server or resource.

## Configuration

Edit `config.lua` to adjust settings:

```lua
Config = {}

-- Speed in KM/H under which falling off is prevented
Config.FallOffSpeed = 250

-- Duration in milliseconds for on-screen notifications
Config.NotifyDuration = 3000

-- Play sound on notifications (true/false)
Config.NotifySound = true


## 📜 License
This resource is released for public and educational use under the MIT license. Attribution to Lancer is appreciated. Do not resell or repackage without permission.

## 📞 Support
💬 Discord: [discord.gg/lancerhud](https://discord.gg/x2nBqmEU)

🧑‍💻 GitHub:[https://github.com/Lancer-GWL](https://github.com/Lancer-GWL)
