# omarchy-c64

A modern-retro Commodore 64 look for the terminal on [Omarchy](https://omarchy.org/):
C64 blue background, lavender text, yellow block cursor, Space Mono, and an optional subtle CRT
(scanlines, glow, vignette) in Ghostty. It only changes terminal config, not the Omarchy theme,
wallpaper or other apps.

## Contents

- `terminal/foot-c64.ini` – colours for foot
- `ghostty/config` – Ghostty config (colours, font, CRT shader)
- `ghostty/crt.glsl` – the CRT shader (tweak scanline darkness, glow and fringe at the top of the file)
- `fonts/` – Space Mono (default) and Departure Mono (alternative), both SIL OFL

## Install

    git clone https://github.com/Packetfunk/omarchy-c64 ~/Projects/omarchy-c64
    cp ~/Projects/omarchy-c64/fonts/*.ttf ~/Projects/omarchy-c64/fonts/*.otf ~/.local/share/fonts/ && fc-cache -f

**foot** – in `~/.config/foot/foot.ini` set:

    include=/path/to/omarchy-c64/terminal/foot-c64.ini
    font=Space Mono:size=9
    line-height=18px

**Ghostty** – in `~/.config/ghostty/config` replace the Omarchy theme include with:

    config-file = /path/to/omarchy-c64/ghostty/config

Bind it to a key, e.g. in `~/.config/hypr/bindings.lua`:

    o.bind("SUPER + ALT + SHIFT + RETURN", "Terminal (Ghostty CRT)", { launch = "ghostty" })

### Session resume (omarchy-layouts)

Keep **foot** as the default terminal (`omarchy default terminal foot`). The
[omarchy-layouts](https://github.com/Packetfunk) plugin only saves scrollback and working directory
for foot windows, because each foot window is its own process. Ghostty started by Omarchy's
launcher runs as one shared single-instance process, so its windows are restored in the right place
but empty. Use Ghostty as an opt-in CRT terminal.

Open new terminal windows afterwards. Existing windows keep their old colours, and a running
`tmux -L omarchy-layouts` server must be restarted to pick up new colours.

## Revert

Restore your backups (`foot.ini.bak.*`, `config.bak.*`) and run `omarchy default terminal foot`.
