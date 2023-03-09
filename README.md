# gfwlist2dnsmasq

[![github pages](https://github.com/fimreal/gfwlist2dnsmasq/actions/workflows/cron_everyday.yaml/badge.svg?branch=main)](https://github.com/fimreal/gfwlist2dnsmasq/actions/workflows/cron_everyday.yaml)

Fetch https://github.com/gfwlist/gfwlist and converte into dnsmasq rule

# download

Script:

[gfwlist2dnsmasq.sh](https://github.com/fimreal/gfwlist2dnsmasq/raw/main/gfwlist2dnsmasq.sh)

Or take Github action assest:

[gfwlist.conf](https://github.com/fimreal/gfwlist2dnsmasq/raw/public/gfwlist.conf)

[gfwlist_ipset.conf](https://github.com/fimreal/gfwlist2dnsmasq/raw/public/gfwlist_ipset.conf)

[gfwlist_in_ipset.conf](https://github.com/fimreal/gfwlist2dnsmasq/raw/public/gfwlist_in_ipset.conf)

CDN:

https://gfwlist2dnsmasq.epurs.com/\<filename\>

# usage

```bash
./gfwlist2dnsmasq.sh --mirror github --dstfile ./gfwlist.conf --ipset gfwlist --extrafile mylist.txt  --reslover 1.1.1.1#53
```

# ref. 

https://github.com/gfwlist/gfwlist

https://github.com/cokebar/gfwlist2dnsmasq