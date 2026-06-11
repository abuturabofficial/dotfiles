#!/usr/bin/env bash

# This script copies a clipboard image to a webp file in the website directory.

set -euo pipefail


post_dir="$(dirname "$ZED_FILE")"
post_name="$(basename "$post_dir")"
year="$(basename "$(dirname "$post_dir")")"
dest_dir="${post_dir}"

if ! command -v magick >/dev/null 2>&1; then
  echo "magick (ImageMagick) not found in PATH" >&2
  exit 1
fi

mkdir -p "$dest_dir"

if [[ -z "${ZED_FILE:-}" ]]; then
  echo "ZED_FILE is not set. Run this from Zed with a markdown file open." >&2
  exit 1
fi

if [[ ! -f "$ZED_FILE" ]]; then
  echo "Open file does not exist: $ZED_FILE" >&2
  exit 1
fi

if [[ "${ZED_FILE##*.}" != "md" ]]; then
  echo "Current file is not a .md file: $ZED_FILE" >&2
  exit 1
fi

# Use post folder name instead of filename (handles index.md convention)
base_name="${1:-${post_name}}"

# Always start numbering from 1; find next available slot
i=1
while [[ -e "${dest_dir}/${base_name}-${i}.webp" ]]; do
  i=$((i + 1))
done

file_name="${base_name}-${i}.webp"
dest_path="${dest_dir}/${file_name}"

get_clipboard_image() {
  if command -v wl-paste >/dev/null 2>&1 && [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    local mime
    mime="$(wl-paste --list-types 2>/dev/null | grep -m1 '^image/' || true)"
    if [[ -n "$mime" ]]; then
      wl-paste --type "$mime"
      return 0
    fi
    echo "wl-paste found no image type. Available types:" >&2
    wl-paste --list-types >&2 || true
  fi

  if command -v xclip >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]; then
    local mime
    mime="$(xclip -selection clipboard -t TARGETS -o 2>/dev/null | tr -d '\r' | grep -m1 '^image/' || true)"
    if [[ -n "$mime" ]]; then
      if xclip -selection clipboard -t "$mime" -o 2>/dev/null; then
        return 0
      fi
    fi
  fi

  if command -v xsel >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]; then
    if xsel --clipboard --output 2>/dev/null; then
      return 0
    fi
  fi

  echo "No image found in clipboard" >&2
  return 1
}

get_clipboard_image | magick - -quality 80 "$dest_path"

markdown_link="![](${file_name})"

insert_markdown() {
  local target_file="$1"
  local text="$2"
  local row="${3:-}"
  local tmp

  if [[ -n "$row" && "$row" =~ ^[0-9]+$ && "$row" -gt 0 ]]; then
    tmp="$(mktemp)"
    awk -v row="$row" -v insert="$text" 'NR==row{print insert} NR!=row{print}' \
      "$target_file" > "$tmp"
    mv "$tmp" "$target_file"
    return 0
  fi

  printf '%s\n' "$text" >> "$target_file"
}

insert_markdown "$ZED_FILE" "$markdown_link" "${ZED_ROW:-}"
printf '%s\n' "$markdown_link"

if command -v wl-copy >/dev/null 2>&1; then
  printf '%s' "$markdown_link" | wl-copy
elif command -v xclip >/dev/null 2>&1; then
  printf '%s' "$markdown_link" | xclip -selection clipboard
elif command -v xsel >/dev/null 2>&1; then
  printf '%s' "$markdown_link" | xsel --clipboard --input
fi
