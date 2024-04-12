# debian-auto-ricer

Personal script to auto rice any Debian based distro.

> [!Important]
> It is thought to be used with `GNOME`, so please, install it before :D
> You'll need to have sudo permissions in your user (add it to the `/etc/sudoers` file)

## Instructions to execute

> [!Tip]
> Just run:

```shell
git clone https://github.com/gitblanc/debian-auto-ricer.git
chmod +x debian-auto-ricer/auto-ricer.sh
./auto-ricer.sh
```

## Language && Keyboard Layout

`American English` with `Spanish` layout.

## Apps

| Name       | Logo | Description                              |
| ---------- | ---- | ---------------------------------------- |
| jq         | --   | cli app to edit `.json` files            |
| Brave      | --   | Private browser                          |
| Keepassxc  | --   | Local password manager                   |
| Shutter    | --   | Screenchot taker                         |
| Neofetch   | --   | Cli app to display system info           |
| Obsidian   | --   | Markdown editor for note taking          |
| VSCode     | --   | Programming IDE                          |
| NordVPN    | --   | VPN provider                             |
| Spotify    | --   | Music provider                           |
| Ulauncher  | --   | Fast app launcher                        |
| Vim        | --   | Cli file editor                          |
| locate     | --   | Cli app to locate anything on the system |
| Oh-my-posh | ---- | App to customize terminal                |

## Dock

| Name      | Description                     |
| --------- | ------------------------------- |
| Terminal  | Bash Terminal                   |
| Nautilus  | File explorer                   |
| Spotify   | Music provider                  |
| Brave     | Private Browser                 |
| Keepassxc | Local password manager          |
| Obsidian  | Markdown editor for note taking |
| VSCode    | Programming IDE                 |
| NordVPN   | VPN provider                    |

## GNOME Extensions

| Name              | Description                    |
| ----------------- | ------------------------------ |
| Vitals            | Real-time system info          |
| Quick settings    | More settings                  |
| Coverflow Alt-Tab | Iterate through windows better |
| User themes       | Allows customizing             |

## System && Icons themes

- [System- Orchis theme](https://github.com/vinceliuice/Orchis-theme.git)
- [Icons - Tela](https://github.com/vinceliuice/Tela-icon-theme/)

## After finishing installation instructions

1. Launch `Ulauncher`
   1. Change Hotkey to `Ctrl+D`
   2. Manually change the theme to `Transparent Adwaita`
   3. Enable `Launch at Login`
   4. Disable `Show Indicator Icon`
2. Launch `gnome-tweaks`
   1. Manually change the **system** theme to`Orchis-Dark-Compact`
   2. Manually change the **icons** theme to `Tela-Dark`
3. Launch `Vitals`
   1. Set up `Seconds between updates to 1`
