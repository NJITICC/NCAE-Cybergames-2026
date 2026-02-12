# Week 5 Cheatsheet – Database & File Services (PostgreSQL / SMB)

---

## Prerequisites (Quick Check)

- MikroTik Router VM
- Ubuntu 24.04 VM – Database Server
- Ubuntu 24.04 VM – Shell / File Server
- Two networks: LAN / WAN
- Review Week2.md if routing is broken

t = team number

---

## PostgreSQL – Scoring Requirements (DO NOT CHANGE)

User: bill_kaplan  
Password: b1ackjack!  
Database: db  
Table: users  
Internal IP: 192.168.t.7  
Port: 5432  

---

## PostgreSQL – Install & Start

```bash
sudo apt update && sudo apt install postgresql postgresql-contrib -y
sudo systemctl start postgresql
sudo systemctl status postgresql
```
---

## PostgreSQL – Initial Setup

```bash
sudo -i -u postgres
psql
```

```text
CREATE ROLE bill_kaplan WITH LOGIN PASSWORD 'b1ackjack!';
CREATE DATABASE db;
GRANT ALL PRIVILEGES ON DATABASE db TO bill_kaplan;
```
---

## PostgreSQL – Create Required Table

```bash
\c db
```
```text
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT,
    email TEXT
);

```text
GRANT USAGE, SELECT ON SEQUENCE users_id_seq TO bill_kaplan;
```
---

## PostgreSQL – Verify Scoring Access

```bash
psql -h 127.0.0.1 -U bill_kaplan -d db
```
```text
INSERT INTO users (username, email) VALUES ('testuser', 'test@example.com');
SELECT * FROM users;
```
---

## PostgreSQL – Enable Network Access (REQUIRED)

```bash
sudo nano /etc/postgresql/*/main/postgresql.conf
```
```text
listen_addresses = '*'
```
```bash
sudo nano /etc/postgresql/*/main/pg_hba.conf
```
```text
host    db    bill_kaplan    172.18.0.0/16    scram-sha-256
```
```bash
sudo systemctl restart postgresql
```
---

## PostgreSQL – Router Port Forward (WAN → LAN)

DST-NAT:
- Chain: dstnat
- Protocol: tcp
- Dst Port: 5432
- In Interface: WAN
- To Address: 192.168.t.7
- To Port: 5432

Filter Rule:
- Chain: forward
- Protocol: tcp
- Dst Port: 5432
- In Interface: WAN
- Out Interface: LAN
- Action: accept

---

## SMB – Scoring Requirements

Shared Directory: /mnt/files  
Samba Password: cnyrocks  
Users: scoring users only  
Router Port Forwarding: NOT REQUIRED  

---

## SMB – Install & Start

```bash
sudo apt update && sudo apt install samba samba-common -y
sudo systemctl enable smbd --now
```
---

## SMB – Create Share Directory

```bash
sudo mkdir -p /mnt/files
sudo chmod 2777 /mnt/files
```
---

## SMB – Create Users

```bash
sudo useradd benjamin_franklin
sudo useradd alexander_hamilton
```
---

## SMB – Add Samba Users

```bash
sudo smbpasswd -a benjamin_franklin
sudo smbpasswd -a alexander_hamilton
```
Password: cnyrocks

---

## SMB – Configure Share

```bash
sudo nano /etc/samba/smb.conf
```

```text
[files]
    path = /mnt/files
    browseable = yes
    writable = yes
    guest ok = no
```
```bash
sudo systemctl restart smbd
```
---

## SMB – Validation Checklist

- Login works
- Can download a file
- Can upload a file
- Filenames unchanged
- Permissions intact

---

## Common Failure Points

- PostgreSQL not listening on network
- pg_hba.conf rule missing or wrong CIDR
- NAT rule below masquerade
- Firewall filter rule missing
- Samba running but permissions wrong

---

## Scoring-Ready Check

Postgres:
- INSERT works
- SELECT works
- External scoring reaches DB

SMB:
- Auth succeeds
- Read/write succeeds

---
