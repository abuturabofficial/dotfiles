#!/bin/bash
if FANSPEED=$(/usr/bin/sensors | /bin/grep -A2 thinkpad-isa | /bin/grep fan1 | /usr/bin/awk '{print $2}'); then
  echo "%{T1}%{T-}%{T2} $FANSPEED"
fi

# Short text
#echo $FANSPEED
