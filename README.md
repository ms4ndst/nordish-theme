# Nordish

A minimal GNOME Shell theme and GTK2 "Legacy Applications" theme built on the
[Nord color palette](https://github.com/nordtheme/nord).

- **Dark variant** (`Nordish-Dark`): Polar Night background, Snow Storm text.
- **Light variant** (`Nordish-Light`): Snow Storm background, Polar Night text.
- Both share the same Frost/Aurora accent colors (`#5E81AC` selection blue,
  `#88C0D0` focus highlight, Nord's standard red/yellow/green for
  error/warning/success).
- The GNOME Shell top bar is semi-transparent in both variants
  (`rgba(46, 52, 64, 0.78)` dark / `rgba(236, 239, 244, 0.78)` light),
  turning more opaque on hover/overview for legibility.
- Styling is deliberately flat and minimal: no gradients, subtle 1px
  borders, small border radii.

## What's included

```
Nordish-Dark/
  index.theme
  gnome-shell/gnome-shell.css   # Shell theme: top bar, overview, quick
                                 settings, notifications, dialogs, etc.
  gtk-4.0/gtk.css               # GTK4 theme
  gtk-4.0/gtk-dark.css          # symlink -> gtk.css (see note below)
  gtk-3.0/gtk.css               # Applications (GTK3) theme
  gtk-3.0/gtk-dark.css          # symlink -> gtk.css (see note below)
  gtk-2.0/gtkrc                 # Legacy Applications (GTK2) theme
Nordish-Light/
  ... (same layout)
```

The GTK2 theme uses only the built-in `default` engine, so it works
without installing `gtk-engines`/murrine — it stays flat/minimal rather
than trying to imitate GTK3 widget shapes. The GTK3 and GTK4 stylesheets
define the standard Adwaita named colors (`@theme_bg_color`,
`@theme_selected_bg_color`, etc.) so apps and libraries that reference
them pick up the Nord palette too, plus flat rules for buttons, entries,
headerbars, menus/popovers, switches, and scrollbars. The GTK4 file
mirrors the GTK3 one with the property/selector names that changed
between the two (`-gtk-icon-effect` instead of `-gtk-icon-shadow`,
`notebook > header > tabs > tab` instead of `notebook > header tab`).

## Install

```sh
./install.sh
```

This symlinks both theme folders into `~/.themes/`, so `git pull` updates
apply without reinstalling. Then:

1. Install the **User Themes** extension if you don't have it, so GNOME
   Tweaks can set a custom shell theme:
   https://extensions.gnome.org/extension/19/user-themes/
2. Open **GNOME Tweaks → Appearance** (or Settings → Appearance for the
   Applications theme):
   - **Applications** (GTK3, and GTK4 for apps that don't use
     libadwaita): choose `Nordish-Dark` or `Nordish-Light`
   - **Shell**: choose `Nordish-Dark` or `Nordish-Light`
   - **Legacy Applications** (GTK2): choose `Nordish-Dark` or `Nordish-Light`
3. If the shell theme doesn't apply immediately, log out/in (Wayland) or
   press `Alt+F2`, type `r`, `Enter` (X11) to restart the shell.

Note on GTK4: `gtk-4.0/gtk.css` styles plain GTK4 apps, but most GTK4
apps use libadwaita, which layers its own stylesheet on top and mostly
ignores a named theme's CSS beyond light/dark preference (and, on
newer libadwaita, an OS accent color). Set the system color scheme to
match the variant you picked (Settings → Appearance → Style) for the
closest result in libadwaita apps — full re-theming of libadwaita
itself is out of scope here.

Note on Electron apps (Slack, VS Code, Discord, ...): under Wayland
these draw their own frame instead of getting one from the compositor,
and Chromium's GTK integration colors that frame by querying a
specific `.solid-csd decoration` CSS node from the active GTK3 theme
(distinct from the plain `decoration` / `.default-decoration` node used
for genuine Mutter-drawn fallback frames on X11). Both `gtk-3.0` and
`gtk-4.0` stylesheets style all of these nodes, so Electron apps'
frames should match the rest of the theme in both the focused and
unfocused (`:backdrop`) state.

GTK3/GTK4 themes can ship a `gtk-dark.css` alongside `gtk.css`, loaded
instead of `gtk.css` when the system prefers a dark color scheme
(`org.gnome.desktop.interface color-scheme` = `prefer-dark`). Full GTK
apps fall back to `gtk.css` automatically when `gtk-dark.css` is
missing, but Chromium's own (independent) GTK-theme-reading code may
not — so each variant here ships `gtk-dark.css` as a symlink to its own
`gtk.css`, ensuring Electron apps find a stylesheet either way. Note
this means `Nordish-Light` is *not* meant to be used with a
system-wide dark color-scheme preference (or vice versa) — pick the
variant matching your `color-scheme` setting.

## Compatibility notes

Written against the GNOME Shell selector set that's been stable since the
3.3x/4x series (panel, quick settings, calendar, message list, OSD, modal
dialogs, screenshot UI, etc.) and expected to keep working on GNOME 50.
GNOME Shell degrades unknown selectors gracefully, so if a future release
renames something, the rest of the theme keeps working — file an issue
(or just tweak the CSS) for anything that looks unstyled.

## Customizing

All colors are plain Nord hex values inlined directly in `gnome-shell.css`
and `gtkrc` (GNOME Shell's CSS engine and legacy GTK2 don't support CSS
custom properties), with the palette documented in a comment block at the
top of each file. Change a value and reload (Alt+F2 → `r` on X11, or
logout/login on Wayland) to see it take effect.
