# Week 2 – MikroTik Router & Host Networking Cheatsheet

---

## Prerequisites (Quick Check)

- MikroTik Router VM installed  
- Rocky or Ubuntu VM installed  
- 3 virtual network adapters attached:
  - WAN
  - LAN
  - (Optional second LAN if applicable)

---

## MikroTik CLI – WAN Configuration

### Create WAN Bridge
```bash
interface/bridge/add name=WAN
```
### Map WAN to Interface
```bash
interface/bridge/port add interface=ether1 bridge=WAN
```
### Assign WAN IP
```bash
/ip address add address=172.18.13.t/16 interface=WAN
```
### Add Default Route
```bash
/ip route add dst-address=0.0.0.0/0 gateway=172.18.0.1
```
### Add NAT Masquerade Rule
```bash
/ip firewall nat add chain=srcnat src-address=192.168.t.0/24 action=masquerade
```
### Test WAN Connectivity
```bash
ping 172.18.0.1
```
---

## MikroTik CLI – LAN Configuration

### Create LAN Bridge
```bash
interface/bridge/add name=LAN
```
### Map LAN to Interface
```bash
interface/bridge/port add interface=ether2 bridge=LAN
```
### Assign LAN IP
```bash
/ip address add address=192.168.t.1/24 interface=LAN
```
### Test LAN Interface
```bash
ping 192.168.t.1
```
---

## Host Machine – Network Configuration (nmcli)

### Assign IPv4 Address
```bash
nmcli connection modify "Wired connection 1" ipv4.address "192.168.t.2/24"
```
### Assign Default Gateway
```bash
nmcli connection modify "Wired connection 1" ipv4.gateway "192.168.t.1"
```
### Set IPv4 Method
```bash
nmcli connection modify "Wired connection 1" ipv4.method manual
```
### Restart Connection
```bash
nmcli connection down "Wired connection 1"  
nmcli connection up "Wired connection 1"
```
### Test Connectivity
```bash
ping 192.168.t.1  
ping 172.18.0.1
```
---

## Host Machine – Web Server (Apache)

### Install Apache
```bash
sudo apt update && sudo apt install apache2 -y
```
### Local Test
http://localhost

---

## MikroTik GUI – Port Forwarding (DST-NAT)

### Navigate
- Login to router GUI (http://172.18.13.t)
- Advanced → IP → Firewall → NAT → New

### General Tab
```text
- Chain: dstnat  
- Protocol: tcp  
- Dst. Port: 80  
- In. Interface: WAN  
```
### Action Tab
```text
- Action: dst-nat  
- To Addresses: 192.168.t.5  
- To Ports: 80  
```
### Apply
- Click OK  
- Move rule **above masquerade rule**

---

## MikroTik GUI – Firewall Filter Rule

### Navigate
- IP → Firewall → Filter Rules → New

### General Tab
```text
- Chain: forward  
- Protocol: tcp  
- Dst. Port: 80  
- Out. Interface: LAN  
```
### Action Tab
```text
- Action: accept  
```
### Apply
- Click OK

---

## Final Test

- From a **different machine/network (WAN)**:
  - Open browser
  - Navigate to: http://172.18.13.t
- Apache default page should load

---

## Common Gotchas (Quick Reminders)

- NAT masquerade must exist for outbound internet  
- DST-NAT rule must be ABOVE masquerade  
- Filter rule is REQUIRED for forwarded traffic  
- Testing from same LAN may fail (hairpin NAT)