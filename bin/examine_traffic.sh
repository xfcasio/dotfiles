#!/usr/bin/bash

TEMP=$(mktemp)

tshark -n -T fields -e ip.dst > $TEMP

for ip in $(cat $TEMP | sort -rn | uniq); do
  echo $ip | grep '192.168.' > /dev/null
  [ $? == 0 ] && continue

  freq=$(cat $TEMP | sort -rn | uniq -c | grep $ip | awk '{ print $1 }')
  printf '%7d %20s : [%s] [%s]\n' $freq $ip \
    "$(whois $ip | grep 'Organization' || echo 'No Registered Organization')" \
    "$(whois $ip | grep 'City' || echo 'No Registered City')"
done | sort -rn

rm $TEMP 