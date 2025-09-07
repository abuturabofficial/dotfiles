#!/bin/bash
set -euo pipefail

# --- configuration ---
LOW_BAT_PERCENT=50
AC_PROFILE="performance"
BAT_PROFILE="balanced"
LOW_BAT_PROFILE="power-saver"

# --- battery paths ---
BAT=$(echo /sys/class/power_supply/BAT* 2>/dev/null || true)
BAT_STATUS="$BAT/status"
BAT_CAP="$BAT/capacity"

# --- sanity checks ---
command -v inotifywait >/dev/null || {
  echo "inotifywait not found"
  exit 1
}
[[ -n "$BAT" && -r "$BAT_STATUS" && -r "$BAT_CAP" ]] || {
  echo "No battery detected"
  exit 0
}

# --- optional startup wait ---
[[ -z ${STARTUP_WAIT:-} ]] || sleep "$STARTUP_WAIT"

# --- monitor loop ---
prev=""
while true; do
  status=$(<"$BAT_STATUS")
  cap=$(<"$BAT_CAP")

  if [[ $status == "Discharging" ]]; then
    if ((cap > LOW_BAT_PERCENT)); then
      profile=$BAT_PROFILE
    else
      profile=$LOW_BAT_PROFILE
    fi
  else
    profile=$AC_PROFILE
  fi

  if [[ $prev != "$profile" ]]; then
    echo "$(date '+%F %T') setting power profile to $profile"
    powerprofilesctl set "$profile"
    prev=$profile
  fi

  # wait for changes, fallback timeout every 5 min
  inotifywait -qq -t 300 "$BAT_STATUS" "$BAT_CAP" || sleep 300
done
