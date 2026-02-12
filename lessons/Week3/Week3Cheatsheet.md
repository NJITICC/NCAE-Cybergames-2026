# Week 3 – DNS (BIND9) Cheatsheet & Reference

---

## Prerequisites (Quick Check)

- MikroTik Router VM installed
- Rocky or Ubuntu VM with a web service installed
- Rocky or Ubuntu VM acting as DNS Server
- Two virtual networks:
  - LAN
  - WAN

Note: Review `Week2.md` for router and host networking configuration if needed.

`t = team number`

---

## DNS Install (BIND9)

### Install DNS Server
```bash
sudo apt update && sudo apt install bind9 -y
```
---

### DNS Configuration Directory
```text
/etc/bind
```
Common files:
- named.conf
- named.conf.options
- named.conf.default-zones
- db.empty

---

## DNS Concepts (Reference)

- Forward lookup: Domain → IP
- Reverse lookup: IP → Domain

Records used:
- A record: Domain → IPv4 address
- PTR record: IPv4 address → Domain

---

## DNS Internal Configuration (LAN)

---

### Define DNS Zones

Edit:
```text
/etc/bind/named.conf.default-zones
```
Add zones:
```text
zone "team<t>.org" IN {
    type master;
    file "/etc/bind/zones/forward.team<t>.org";
    allow-update { none; };
};

zone "<t>.168.192.in-addr.arpa" IN {
    type master;
    file "/etc/bind/zones/reverse.team<t>.org";
    allow-update { none; };
};
```
---

### Create Zone Directory and Files

Create zones directory:
```bash
sudo mkdir /etc/bind/zones
```
Forward zone:
```bash
sudo cp /etc/bind/db.empty /etc/bind/zones/forward.team<t>.org
```
Reverse zone:
```bash
sudo cp /etc/bind/db.empty /etc/bind/zones/reverse.team<t>.org
```
---

### Set Hostname (DNS Server)
```bash
sudo hostnamectl set-hostname ncae-lab2026
```
Verify:
```bash
hostname
```
---

### Forward Zone (A Records)

File:
```text
/etc/bind/zones/forward.team<t>.org

Required changes:
```text
- Change localhost → team<t>.org
- Change root.localhost. → root
- Increment serial number
- Replace localhost. with hostname
```
Records to add:
```text
ncae-lab2026    IN A    192.168.t.12
www             IN A    192.168.t.5
```
---

### Reverse Zone (PTR Records)

File:
```text
/etc/bind/zones/reverse.team<t>.org
```
Required changes:
```text
- localhost → ncae-lab2026.team<t>.org
- root.localhost. → root.team<t>.org.
- Increment serial number
- Replace localhost. with hostname
```
Record to add:
```text
5   IN PTR ncae-lab2026.team<t>.org
```
---

### Reload / Restart DNS
```bash
sudo systemctl restart bind9
```
---

## Internal DNS Testing

Set DNS on internal client:
```bash
nmcli connection modify "Wired Connection 1" ipv4.dns "192.168.t.12"
```
Test resolution:
```bash
nslookup 192.168.t.5
nslookup www.team<t>.org
nslookup ncae-lab2026.team<t>.org
```
---

## DNS External Configuration (WAN Access)

---

### MikroTik – Port Forward DNS (UDP 53)

Navigation:
Advanced → IP → Firewall → NAT → New

General:
```text
- Chain: dstnat
- Protocol: udp
- In. Interface: WAN
```
Action:
```text
- Action: dst-nat
- To Address: 192.168.t.12
- To Port: 53
```
---

### MikroTik – Firewall Filter Rule

Navigation:
Advanced → IP → Firewall → Filter Rules → New

General:
```text
- Protocol: udp
- Dst. Port: 53
- Out. Interface: LAN
```
Action:
```text
- Action: accept
```
---

### External DNS Zones

Create external forward zone:
```bash
sudo cp /etc/bind/db.empty /etc/bind/zones/forward.team<t>.cnyhackathon.org
```
Edit:
```text
/etc/bind/zones/forward.team<t>.cnyhackathon.org
```
Required contents:
```text
$TTL    86400
@       IN      SOA     ns1.team<t>.cnyhackathon.org root.ns1. (
                        2       ; Serial
                        604800  ; Refresh
                        86400   ; Retry
                        2419200 ; Expire
                        86400 ) ; Negative Cache TTL
;
@       IN      NS      ns1
ns1     IN      A       172.18.13.<t>
www     IN      A       172.18.13.<t>
```
---

Create external reverse zone:
```bash
sudo cp /etc/bind/db.empty /etc/bind/zones/web.team<t>.cnyhackathon.org
```
Edit:
```text
/etc/bind/zones/web.team<t>.cnyhackathon.org
```
Required contents:
```text
$TTL    86400
@       IN      SOA     ns1.team<t>.cnyhackathon.org. root.cnyhackathon.org. (
                        2       ; Serial
                        604800  ; Refresh
                        86400   ; Retry
                        2419200 ; Expire
                        86400 ) ; Negative Cache TTL
;
@       IN      NS      ns1.
2       IN      PTR     ns1.team<t>.cnyhackathon.org
2       IN      PTR     www.team<t>.cnyhackathon.org
```
---

Add external zones to:
```text
/etc/bind/named.conf.default-zones

```text
zone "team<t>.cnyhackathon.org" IN {
    type master;
    file "/etc/bind/zones/forward.team<t>.cnyhackathon.org";
    allow-update { none; };
};

zone "13.18.172.in-addr.arpa" IN {
    type master;
    file "/etc/bind/zones/web.team<t>.cnyhackathon.org";
    allow-update { none; };
};
```
---

Restart DNS:
```bash
sudo systemctl restart bind9
```
---

## External DNS Testing

```bash
dig external.team<t>.org
nslookup external.team<t>.org
```

Browser test:
```text
http://external.team<t>.org
```
---

## Verification & Troubleshooting

```bash
systemctl status bind9
named-checkconf
named-checkzone team<t>.org /etc/bind/zones/forward.team<t>.org
named-checkzone <t>.168.192.in-addr.arpa /etc/bind/zones/reverse.team<t>.org
ss -tulnp | grep :53
dig @127.0.0.1 team<t>.org
dig -x 192.168.t.5
```