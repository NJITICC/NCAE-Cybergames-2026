# Week 1 – Host Networking & Web Service Cheatsheet

---

## Host Networking Requirements (Quick Reference)

A host must have the following to join a network:

- IP Address
- Subnet Mask
- Default Gateway
- DNS (optional for routing, required for hostname resolution)

---

## Rocky Linux – Network Configuration (CLI)

### Identify Network Interfaces
```bash
ip a
```
---

### Locate NetworkManager Connection File
```bash
sudo nmcli -f NAME,DEVICE,FILENAME connection show
```
---

### Configure IPv4 Settings (nmcli)

Replace `interface_name` with your actual connection name.

Set IP Address
```bash
sudo nmcli connection modify "interface_name" ipv4.addresses "192.168.100.2/24"
```
Set Default Gateway
```bash
sudo nmcli connection modify "interface_name" ipv4.gateway "192.168.100.1"
```
Set DNS
```bash
sudo nmcli connection modify "interface_name" ipv4.dns "192.168.100.1"
```
Set IPv4 Method
```bash
sudo nmcli connection modify "interface_name" ipv4.method manual
```
---

### Restart Network Interface
```bash
nmcli connection down interface_name  
nmcli connection up interface_name
```
---

### Test Connectivity
```bash
ping -c 4 192.168.100.1
```
---

## Ubuntu Networking

- Manual configuration required
- Students experiment independently
- No reference steps provided for Week 1

---

## Rocky Linux – Apache Web Server (HTTPD)

### Install Apache
```bash
sudo dnf install httpd -y
```
---

### Check Service Status
```bash
systemctl status httpd
```
---

### Start Web Service
```bash
systemctl start httpd
```
(Optional but recommended) 
```bash
systemctl enable httpd
```
---

### Test in Browser
Open Firefox  
Navigate to: http://<HOST_IP>

---

## Rocky Linux – Web Content

### Web Root Location
```text
/var/www/html
```
---

### Create Test Page
```bash
vim /var/www/html/test.html
```
---

### Verify Page Loads
Navigate to: http://<HOST_IP>/test.html

---

## Apache Configuration File (Reference)

Main configuration file:  
/etc/httpd/conf/httpd.conf

Common directives:
- Listen
- ServerRoot
- DocumentRoot

(No changes required for Week 1)

---

## Ubuntu Web Server

- Configuration deferred
- Students experiment independently

---

## Vulnerability Demonstration – Setup

### Install Wireshark
```bash
sudo dnf install wireshark -y
```
---

### Install PHP
```bash
sudo dnf install php php-cli php-common -y  
sudo systemctl restart httpd
```
---

### Create Insecure Login Page
```bash
sudo vim /var/www/html/login.php
```
---

## Firewall Configuration (Rocky)

### Allow HTTP Traffic
```bash
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent  
sudo firewall-cmd --reload
```
---

## Vulnerability Observation (Wireshark)

### Start Wireshark
- Select interface: Loopback (lo)

---

### Open Insecure Login Page
Navigate to: http://<HOST_IP>/login.php

---

### Observe Traffic
- Credentials sent in plaintext
- If packets not visible:
  - Switch capture interface to Loopback (lo)

---