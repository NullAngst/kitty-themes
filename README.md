# kitty-config

A kitty terminal setup with seven custom color themes that plug into kitty's own theme picker, plus an `other.conf` that holds every non-color setting with comments.

## What's in here

- `kitty.conf`: tiny on purpose. It pulls in `other.conf`, then the active theme.
- `other.conf`: fonts, cursor, scrollback, tabs, padding, transparency, keys. Every option has a comment saying what the values do.
- `themes/`: the seven themes.
- `current-theme.conf`: the active theme. Starts as Modern Dark.
- `install.sh`: copies everything into place and can switch themes.

## Themes

- **Amber**: amber phosphor CRT on near-black. Blue and cyan are pulled into tan and pale gold so nothing breaks the look.
- **Modern Dark**: neutral charcoal. Your old palette, toned down slightly.
- **Modern Light**: off-white with dark ink.
- **Verdigris Copper**: oxidized green background, pale verdigris text, copper cursor and highlights.
- **Kawaii Light**: pastel pink with plum text.
- **Kawaii Dark**: deep plum with pastel candy accents.
- **Blurple**: dark indigo with blurple accents.

Each theme also sets the tab bar, window borders and cursor, so the whole window matches.

## Prerequisites

- kitty 0.33 or newer, since that's when Nerd Font symbols got built in. Older kitty works fine, you just won't get icons without a patched font.
- bash, for the installer.

## Install

1. Extract the tar: `tar -xf kitty-config.tar`
2. Move into the folder: `cd kitty-config`
3. See the theme names: `./install.sh --list`
4. Install with a theme: `./install.sh Amber` (or whichever theme you want; case and hyphens don't matter, so `"verdigris copper"` works too)

The installer writes to `~/.config/kitty` (or `$XDG_CONFIG_HOME/kitty` if you set that). Your existing `kitty.conf` and `other.conf` get backed up as `kitty.conf.bak-<date>` first. If kitty is running, it gets told to reload, so you see the change right away.

Running `./install.sh` with no theme keeps whatever theme you already have.

4.5. Prefer doing it by hand? Copy `kitty.conf`, `other.conf`, `current-theme.conf` and the `themes/` folder into `~/.config/kitty/`. Same result.

## Switching themes later

Press `ctrl+shift+f12`. That opens kitty's theme picker in an overlay. The seven themes here sit under the "User" category. Pick one and kitty rewrites `current-theme.conf` and the theme block in `kitty.conf` for you.

You can also run `kitty +kitten themes` from any shell, or rerun `./install.sh <name>`.

## Changing settings

Open `~/.config/kitty/other.conf` in nano, or whichever editor you prefer. Change a value, save, then press `ctrl+shift+f5` to reload. No restart needed for most options.

The common ones:

- **Font**: `font_family` and `font_size`. I left it as `monospace` so it follows your system font. Swap in one of the commented examples if you want Hasklig or similar. Run `kitty +list-fonts` to see exact names.
- **Cursor**: `cursor_shape` is beam. `cursor_blink_interval 0` stops blinking.
- **Transparency**: set `background_opacity` below 1.0, like 0.92. On KDE Plasma, set `background_blur` to 1 or higher for frosted glass.
- **Tabs**: `tab_bar_edge` and `tab_bar_style`.
- **Padding**: `window_padding_width`.

DO NOT PUT COLORS IN OTHER.CONF. The theme loads after it and wins, so your color lines will look like they do nothing. Edit the theme file in `themes/` instead, or copy one under a new name and change its `## name:` line so it shows up as its own entry in the picker.

If something doesn't look right, run `kitty --debug-config` to see what kitty actually loaded.

## Notes

- The light themes use mid gray for ANSI "white" so programs that print white text stay readable. On a light background that's the tradeoff: "white" won't look white.
- Amber deliberately has no true blue or cyan. Tools that use blue for meaning (like `ls` directory colors) will show tan instead. If that bugs you, Modern Dark or Verdigris Copper are better daily drivers.
- Remote control stays off. The theme picker doesn't need it.

Now kitty is running with your chosen theme, reloads on `ctrl+shift+f5`, and switches themes from `ctrl+shift+f12`. Tinker with `other.conf` as you see fit.
