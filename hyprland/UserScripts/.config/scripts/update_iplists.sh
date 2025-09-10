#!/bin/bash
# opensnitch - 2021-2022
#
# https://github.com/evilsocket/opensnitch/wiki/block-lists
#
# Add the script to a regular user's crontab:
# $ crontab -e
# 0 11,17,23 * * * /home/user/scripts/update_adlists.sh

# Use any directory you want to save the lists.
# If you use /etc/opensnitchd, give write permissions to blocklists/* for your user (chown -R /etc/opensnitchd/blocklists/).
# or use a directory from your user's home.
ipsDir="/home/abuturab/.config/scripts/opensnitchd/blocklists/ips/"

# If you add new urls, remember to add the corresponding filename where it'll be save on disk.
ipsList=(
  "https://malware-filter.gitlab.io/malware-filter/urlhaus-filter-dnscrypt-blocked-ips.txt")
ipsListNames=(
  "urlhaus-ips.txt")

function download_list {
  echo -n "[+] downloading new ips list... $1 -> $2 ($3, $4)"
  curl --silent "$1" -o $2
  [ $? -eq 0 ] && echo "   OK" || echo "   FAIL"
}

function download_ips_list {
  reload=0
  for idx in ${!ipsList[@]}; do
    echo "[+] Checking list ${ipsList[$idx]}, ${ipsListNames[$idx]}"
    remoteSize=$(curl --silent -I ${ipsList[$idx]} | awk '/content-length:/ {print $2}' | tr -d '\r')
    localSize=$(stat -c %s $ipsDir/${ipsListNames[$idx]} 2>/dev/null)

    if [ ! -z $remoteSize ]; then
      if [ "$remoteSize" != "$localSize" ]; then
        download_list "${ipsList[$idx]}" "$ipsDir/${ipsListNames[$idx]}" $remoteSize $localSize
        reload=1
      else
        echo "[-] ips list not updated yet:  $remoteSize, $localSize - ${ipsList[$idx]}"
      fi
    else
      echo "[!] No content-length header found: ${ipsList[$idx]}"
      echo "[.] Trying with Last-Modidifed"
      lastMod=$(date +%s -d "$(curl --silent -I ${ipsList[$idx]} | grep Last-Modified | cut -d: -f 2)")
      localMod=$(stat -c %Y $ipsDir/${ipsListNames[$idx]} 2>/dev/null)
      [ $? -eq 1 ] && localMod=0
      if [ ! -z $lastMod -a $lastMod -gt $localMod ]; then
        download_list "${ipsList[$idx]}" "$ipsDir/${ipsListNames[$idx]}" $remoteSize $localSize
      else
        echo "[-] ips list not updated yet:  $lastMod, $localMod - ${ipsList[$idx]}"
      fi
    fi
  done
}

if [ ! -d $ipsDir ]; then
  mkdir -p $ipsDir
fi

cd $ipsDir

download_ips_list

echo "[~] Done"
