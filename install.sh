#!/usr/bin/env bash
# install.sh: copy this kitty config into place and optionally pick a theme.
#
#   ./install.sh                  install, keep Modern Dark (or your current theme)
#   ./install.sh Amber            install and switch to Amber
#   ./install.sh --list           show the theme names you can pass

set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
stamp="$(date +%Y%m%d-%H%M%S)"

list_themes() {
    for f in "$src"/themes/*.conf; do
        printf '  %s\n' "$(basename "$f" .conf)"
    done
}

if [[ "${1:-}" == "--list" || "${1:-}" == "-l" ]]; then
    printf 'Themes:\n'
    list_themes
    exit 0
fi

theme_file=""
if [[ -n "${1:-}" ]]; then
    # Case-insensitive match on the file name, spaces or hyphens both work
    want="$(printf '%s' "$1" | tr '[:upper:] ' '[:lower:]-')"
    for f in "$src"/themes/*.conf; do
        name="$(basename "$f" .conf | tr '[:upper:]' '[:lower:]')"
        if [[ "$name" == "$want" ]]; then
            theme_file="$f"
            break
        fi
    done
    if [[ -z "$theme_file" ]]; then
        printf 'No theme named "%s". Pick one of:\n' "$1" >&2
        list_themes >&2
        exit 1
    fi
fi

mkdir -p "$dest/themes"

# Back up anything we are about to overwrite
for f in kitty.conf other.conf; do
    if [[ -f "$dest/$f" ]]; then
        cp "$dest/$f" "$dest/$f.bak-$stamp"
        printf 'Backed up %s to %s.bak-%s\n' "$f" "$f" "$stamp"
    fi
done

cp "$src/kitty.conf" "$src/other.conf" "$dest/"
cp "$src"/themes/*.conf "$dest/themes/"

if [[ -n "$theme_file" ]]; then
    cp "$theme_file" "$dest/current-theme.conf"
elif [[ ! -f "$dest/current-theme.conf" ]]; then
    cp "$src/current-theme.conf" "$dest/current-theme.conf"
fi

# Keep the label in the theme block matching whatever theme is active
pretty="$(sed -n 's/^## name: //p' "$dest/current-theme.conf" | head -n 1)"
if [[ -n "$pretty" ]]; then
    sed -i "/# BEGIN_KITTY_THEME/{n;s/^# .*/# ${pretty//\//\\/}/}" "$dest/kitty.conf"
    printf 'Theme: %s\n' "$pretty"
fi

# SIGUSR1 tells running kitty instances to reload their config
if pgrep -x kitty >/dev/null 2>&1; then
    pkill -USR1 -x kitty || true
    printf 'Reloaded running kitty windows\n'
fi

printf 'Installed to %s\n' "$dest"
