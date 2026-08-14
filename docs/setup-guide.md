# Setup Guide – Homelab Mac Mini M4

This guide walks through the setup of the full monitoring and security stack.

## Prerequisites
- macOS with Colima or Docker Desktop installed
- Tailscale account (with a reusable auth key)
- Git
- At least 12 GB of RAM allocated to the VM

---

## 🌐 Network Setup (Physical Layer)

Before starting the containers, configure the physical network topology.

### 1. Configure ISP router (Vodafone) as modem + DMZ

Access `http://192.168.1.1` → **Expert Mode** → **DMZ**:

| Setting | Value |
| :--- | :--- |
| DMZ enabled | `ON` |
| DMZ IP | `192.168.1.95` |
| Wi-Fi radios (all bands) | `OFF` |

> The ISP router becomes a pure modem. Its Wi-Fi creates co-channel
> interference with your own router — always disable it.

### 2. Configure your own router (Mercusys BE9300)

Access `http://192.168.0.1` (or `http://mwlogin.net`):

**WAN:**
- Connection type: `Dynamic IP`
- WAN IP (reserved at ISP router): `192.168.1.95`
- MAC address: `08:8A:F1:07:D4:CB` (reserve this MAC at the ISP DHCP)

**LAN / Wi-Fi bands:**

| Band | SSID | Security | Bandwidth | Channel | Purpose |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 2.4 GHz | `MERCUSYS_D4CA` | WPA2-PSK | 20 MHz | 6 | IoT devices (Aimor, Xiaomi, etc.) |
| 5 GHz | `MERCUSYS_D4CA_5G` | WPA3-SAE | 80 MHz | auto | Laptops, TV, consoles |
| 6 GHz | `MERCUSYS_D4CA_6G` | WPA3-SAE | 160 MHz | auto | iPhone 15 Pro Max, Mac Mini Wi-Fi 6E |

> **Why 20 MHz on 2.4 GHz?** IoT devices have weak radios.
> Narrow bandwidth = better sensitivity = stable connections.

### 3. DHCP reservations (Mercusys → LAN)

| Device | MAC | IP |
| :--- | :--- | :--- |
| Mac Mini M4 (Ethernet) | *(check Settings → Network)* | `192.168.0.10` |
| Mercusys WAN (at Vodafone DHCP) | `08:8A:F1:07:D4:CB` | `192.168.1.95` |

### 4. Verify single NAT

From the Mac Mini:

```bash
# Should show ONE private hop (192.168.0.1) before your public IP
traceroute -n 8.8.8.8 | head -5
```

If you see two private IPs (192.168.0.1 AND 192.168.1.1), DMZ is misconfigured and you have double NAT — gaming NAT type and port forwarding will suffer.

> For the full rationale (why DMZ, why disable ISP Wi-Fi, DNS chain details), see [network-migration-mercusys.md](network-migration-mercusys.md).

