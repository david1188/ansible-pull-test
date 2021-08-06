#!/bin/bash

memory=$(free --giga | grep Mem | awk '{print $2}')
cur_buckets=$(cat /proc/sys/net/netfilter/nf_conntrack_buckets)
cur_count=$(cat /proc/sys/net/netfilter/nf_conntrack_count)
max_count=$(cat /proc/sys/net/netfilter/nf_conntrack_max)

echo ${memory}"[Gig] memory"
echo ${cur_buckets} "bucket"
echo ${cur_count} "current count"
echo ${max_count} "max count"

if (( ${cur_count} > ${max_count} )); then
  new_size=$( expr 2000 + ${cur_count})
  sysctl -w net.netfilter.nf_conntrack_max=${new_size}
  echo "net.netfilter.nf_conntrack_max=$new_size" >> /etc/sysctl.conf
  echo ${new_size}
fi
