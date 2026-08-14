# Network Migration: Vodafone → Mercusys (DMZ)

## Topology (post-migration)

```
Internet
└─ Vodafone router (192.168.1.1) — modem mode + DMZ → 192.168.1.95, Wi-Fi OFF
└─ Mercusys BE9300 (192.168.0.1) — firewall, NAT, tri-band Wi-Fi
├─ 2.4 GHz (WPA2, 20 MHz, ch 6) → IoT devices
├─ 5/6 GHz → laptops, phones, consoles
└─ LAN → Mac Mini M4 (192.168.0.10, DHCP reservation)
```


## DNS chain

```
client :53 → pf rdr → 127.0.0.1:9053 (dnsmasq, Homebrew service)
→ Tailscale → Pi-hole + Unbound (tailnet IP) → filtered answers
```
- TCP :53 → 127.0.0.1:5355 (Docker published port, legacy path)
- UDP :53 → 127.0.0.1:9053 (dnsmasq — the reliable path)

## Why not bind :53 directly?

- macOS reserves port 53 (mDNSResponder/systemd-likes behavior)
- Port 5353 UDP = Bonjour/mDNS + Spotify (do NOT use for DNS proxies)
- socat UDP proved unstable for DNS; dnsmasq is purpose-built (caching, retries, proper DNS semantics)

## Pi-hole tuning

- Rate limit raised 1000 → 10000 queries/60s (Settings → DNS → rate limit). With a proxy, ALL clients appear as one source IP, so the per-client limit becomes a per-household limit; bursts from metadata scrapers (metahub/thetvdb/themoviedb) tripped the default.

## Lessons learned

1. Single NAT via DMZ fixes gaming NAT type and double-NAT pain.
2. Keep ISP Wi-Fi radios OFF to avoid co-channel interference.
3. Document IPs: gateway .1 (Mercusys), WAN .95, Mac .10, Pi-hole tailnet IP.
4. Backups live in ~/Documents/Mine/Homelab/Backups (pf, dnsmasq, compose, IPs).
