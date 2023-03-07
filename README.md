# gfwlist2dnsmasq
Fetch https://github.com/gfwlist/gfwlist and converte into dnsmasq rule


# usage

```bash
./gfwlist2dnsmasq.sh --mirror github --dstfile ./gfwlist.conf --ipset gfwlist --extrafile mylist.txt  --reslover 1.1.1.1#53
```

# ref. 

https://github.com/gfwlist/gfwlist

https://github.com/cokebar/gfwlist2dnsmasq