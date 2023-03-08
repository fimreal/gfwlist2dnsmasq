# gfwlist2dnsmasq

[![github pages](https://github.com/fimreal/gfwlist2dnsmasq/actions/workflows/cron_everyday.yaml/badge.svg?branch=main)](https://github.com/fimreal/gfwlist2dnsmasq/actions/workflows/cron_everyday.yaml)

Fetch https://github.com/gfwlist/gfwlist and converte into dnsmasq rule


# usage

```bash
./gfwlist2dnsmasq.sh --mirror github --dstfile ./gfwlist.conf --ipset gfwlist --extrafile mylist.txt  --reslover 1.1.1.1#53
```

or take Github action assest [gfwlist.conf](https://github.com/fimreal/gfwlist2dnsmasq/raw/public/gfwlist.conf)


# ref. 

https://github.com/gfwlist/gfwlist

https://github.com/cokebar/gfwlist2dnsmasq