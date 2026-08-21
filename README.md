# Nordish

A GNOME Shell + GTK2/GTK3/GTK4 theme family built on the
[Nord color palette](https://github.com/nordtheme/nord), in four
variants: `Nordish-Dark`, `Nordish-Light`, and their `-Round`
counterparts (see [Round variants](#round-variants) below).

- **Dark variant** (`Nordish-Dark`): Polar Night background, Snow Storm text.
- **Light variant** (`Nordish-Light`): Snow Storm background, Polar Night text.
- Both share the same Frost/Aurora accent colors (`#5E81AC` selection blue,
  `#88C0D0` focus highlight, Nord's standard red/yellow/green for
  error/warning/success).
- The GNOME Shell top bar is semi-transparent in both variants
  (`rgba(46, 52, 64, 0.78)` dark / `rgba(236, 239, 244, 0.78)` light),
  turning more opaque on hover/overview for legibility.
- Window control buttons (minimize/maximize/close) are circular, with a
  subtle rest-state tint that shifts to the same Frost accent used for
  the quick-settings toggle's checked state on hover
  (`#88C0D0` dark / `#5E81AC` light).
- Styling is deliberately flat and minimal: no gradients, subtle 1px
  borders, small border radii — except the `-Round` variants, see below.

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

## Round variants

`Nordish-Dark-Round` and `Nordish-Light-Round` pair the same Nord palette
with a rounded shape language (pill-shaped buttons, larger radii, ripple
animations) instead of the flat originals' minimal styling.

- `gnome-shell/` in both is derived from the **Lycia** theme's shape,
  recolored to Nord.
- `gtk-2.0/`, `gtk-3.0/`, and `gtk-4.0/` in **both** Round variants are
  plain copies of `Nordish-Dark`'s / `Nordish-Light`'s own GTK
  stylesheets (not Lycia-derived) — Lycia's GTK layer had a persistent,
  never-fully-resolved bug where Electron/Chromium apps (Slack, VS
  Code, Discord) rendered a white window-frame top bar instead of the
  themed dark/light one, traced to several compounding issues in
  Lycia's own compiled CSS. Reusing the flat theme's proven-working GTK
  layer was more reliable than continuing to patch Lycia's. Practical
  effect: application windows (headerbars, buttons, dialogs) look
  identical between a Round variant and its flat counterpart; only the
  GNOME Shell chrome (top bar, quick settings, calendar, dash) differs.

`Nordish-Light`'s own GTK3 layer is a full Nord recolor of the
**Colloid-Light** theme (not hand-authored), for the same shape-reuse
reason; `Nordish-Dark`'s GTK3 layer is a Nord recolor of
**Nordic-Polar-standard-buttons**. Both keep their own hand-authored
GTK4 stylesheets.

## Install

```sh
./install.sh
```

This copies all four theme folders into `~/.themes/`. Re-run it after
pulling changes or editing anything here — since it's a copy, not a
symlink, edits in this repo won't show up in `~/.themes` until you do.
Then:

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

Beyond the classic `@theme_bg_color`-style named colors, each GTK4
stylesheet also defines libadwaita's own separate named-color system
(`@window_bg_color`, `@view_bg_color`, `@headerbar_bg_color`,
`@accent_bg_color`, `@popover_bg_color`, etc.) — libadwaita widgets read
these directly and otherwise fall back to their own internal defaults
regardless of the classic names, which shows up as "the dialog chrome
is themed but its buttons/dropdowns aren't." Defining both sets fixes
this for most libadwaita apps.

**Known limitation:** some dialogs shown via the XDG desktop portal
(e.g. a Qt app's native Save dialog, routed through
`xdg-desktop-portal-gnome`) can still show unstyled white
buttons/dropdowns even with both named-color sets defined and the
portal service restarted. This appears to be a hardcoded/internal
behavior in that specific dialog implementation, not something a GTK
theme file can reach — confirmed after checking that the portal's own
`Settings.Read` D-Bus API correctly reports the dark/light preference,
ruling out a settings-sync issue. Left as-is rather than routing
around it (e.g. forcing affected apps onto a non-portal Qt dialog via
`qt6ct`), since that trades a cosmetic issue for a bigger, unrelated
dependency.

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
GNOME Shell degrades unknown selectors gracefully — an unmatched selector
is silently ignored rather than erroring, which is convenient but means a
stale/wrong selector name fails *silently* (the element just falls back
to GNOME's own default styling, which can look plausible enough to miss
at a glance). Several selectors in earlier versions of this theme turned
out to be outdated this way (workspace-switcher dots, the calendar
popover, the Activities button's workspace indicator). When in doubt
about whether a selector is still current, extract GNOME's own default
stylesheet and grep it rather than trusting an older theme or memory:

```sh
gresource extract /usr/share/gnome-shell/gnome-shell-theme.gresource \
  /org/gnome/shell/theme/gnome-shell-dark.css > /tmp/gnome-shell-dark.css
```

If a future release renames something, file an issue (or just tweak the
CSS) for anything that looks unstyled.

## Customizing

All colors are plain Nord hex values inlined directly in `gnome-shell.css`
and `gtkrc` (GNOME Shell's CSS engine and legacy GTK2 don't support CSS
custom properties), with the palette documented in a comment block at the
top of each file. Change a value and reload (Alt+F2 → `r` on X11, or
logout/login on Wayland) to see it take effect.
