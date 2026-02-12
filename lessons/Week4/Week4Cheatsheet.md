# Week 4 – SSH / SSL / DNS Cheatsheet (Quick Reference)

---

`t = team number`

---

## SSH – Install & Service Control

Install OpenSSH Server:
```bash
sudo apt update && sudo apt install ssh -y
```
Start SSH service:
```bash
sudo systemctl start ssh
```
Check SSH status:
```bash
sudo systemctl status ssh
```
Restart SSH (if needed):
```bash
sudo systemctl restart ssh
```
---

## SSH – Remote Connections (Internal)

SSH to MikroTik Router (example):
```bash
ssh admin@172.18.13.t
```
Credentials:
- Username: admin
- Password: NCAE

SSH to DNS Server:
```bash
ssh ncae-lab2026@192.168.t.12
```
SSH to Web / Database Server:
```bash
ssh ncae-lab2026@192.168.t.5
```
---

## SSH – Key-Based Authentication

Generate SSH keypair:
```bash
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/SSHSERVER -C "ncae-lab2026@SSHServer"
```
Public key file:
```text
~/.ssh/SSHSERVER.pub

Append public key to remote server:
```bash
echo "(PASTE FULL PUBLIC KEY HERE)" >> ~/.ssh/authorized_keys
```
Login using key:
```bash
ssh 192.168.t.12
```
---

## MikroTik – HTTPS Port Forward (TCP 443)

DST-NAT Rule:
```text
Chain: dstnat
Protocol: tcp
Dst. Port: 443
In. Interface: WAN
```
Action:
```text
Action: dst-nat
To Address: 192.168.t.5
To Port: 443
```
Firewall Filter Rule:
```text
Chain: forward
Protocol: tcp
Dst. Port: 443
In. Interface: WAN
Out. Interface: LAN
Action: accept
```
---

## MikroTik – DNS Port Forward (UDP 53)

DST-NAT Rule:
```text
Chain: dstnat
Protocol: udp
In. Interface: WAN
```
Action:
```text
Action: dst-nat
To Address: 192.168.t.12
To Port: 53
```
Firewall Filter Rule:
```text
Protocol: udp
Dst. Port: 53
Out. Interface: LAN
Action: accept
```
---

## SSL – Install NCAE Root CA

Download Root CA:
```bash
wget https://ca.ncaecybergames.org/roots.pem --no-check-certificate
```
Install Root CA:
```bash
sudo cp roots.pem /usr/local/share/ca-certificates/ncae-root-ca.crt
```
Update trust store:
```bash
sudo update-ca-certificates
```
---

## SSL – Certbot (Web Server)

Request certificate:
```bash
sudo certbot --apache --server https://ca.ncaecybergames.org/acme/acme/directory -d www.teamt.ncaecybergames.org
```
---

## Verification Commands

Check SSH listening:
```bash
ss -tulnp | grep :22
```
Check HTTPS listening:
```bash
ss -tulnp | grep :443
```
Check DNS listening:
```bash
ss -tulnp | grep :53
```
Test DNS locally:
```bash
dig @127.0.0.1 teamt.org
```
Test external DNS:
```bash
dig external.teamt.org
```
Test HTTPS:
```text
https://www.teamt.ncaecybergames.org
```
---

## Common Gotchas

- SSH service installed but not started
- Wrong router credentials (admin / NCAE)
- NAT rule below masquerade
- Missing firewall filter rule
- DNS works internally but not externally (UDP 53 not forwarded)
- Certbot fails due to closed port 443

---

