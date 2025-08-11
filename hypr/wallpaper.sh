#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
INTERVAL=300

set_random_wallpaper() {
  mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null)

  if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
  fi

  random_wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"

  swww img "$random_wallpaper" --transition-type wipe --transition-duration 2

  echo "Set wallpaper: $(basename "$random_wallpaper")"
}

if [ "$1" = "random" ]; then
  set_random_wallpaper
  exit 0
fi

while true; do
  set_random_wallpaper
  sleep $INTERVAL
done
