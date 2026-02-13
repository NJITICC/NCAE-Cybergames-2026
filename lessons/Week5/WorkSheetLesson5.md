# Login Credentials
Navigate to: https://proxmox.tkg-infra.com/
## Proxmox
- **Username:** `team#` *(replace `#` with your team number)*
- **Password:** `ncaeteam#`
- **Realm:** `Proxmox VE authentication server`

## Ubuntu / Kali / Rocky
- **Username:** `ncae-lab2026`
- **Password:** `NCAE`

## MikroTik Router

### Default login time (if OS not installed)
- **Username:** `admin`
- **Password:** *(leave blank, just press Enter)*

### After password is set (OS Installed)
- **Username:** `admin`
- **Password:** `NCAE`


# SQL GitHub Demo 1

### Switch to PostgreSQL Superuser
Access the postgres system account.
```bash
sudo -i -u postgres
```
### Open PostgreSQL CLI
Launch the psql interface.
```bash
psql
```
<br/>

### Create Database Role
Create a login role with password authentication.
```bash
CREATE ROLE bill_kaplan WITH LOGIN PASSWORD 'b1ackjack!';
```
### Create Database
Create a new database named db.
```bash
CREATE DATABASE db;
```
### Grant Database Privileges
Allow the role full control over the database.
```bash
GRANT ALL PRIVILEGES ON DATABASE db TO bill_kaplan;
```
### Connect to Database
Switch into the newly created database.
```bash
\c db
```
### Create Users Table
Create a table to store user records.
```text
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT,
    email TEXT
);
```
### Grant Sequence Permissions
Allow access to the auto-increment ID sequence.
```bash
GRANT USAGE, SELECT ON SEQUENCE users_id_seq TO bill_kaplan;
```
### Grant Schema Usage
Permit access to the public schema.
```bash
GRANT USAGE ON SCHEMA public TO bill_kaplan;
```
### Grant Table Permissions
Allow full CRUD operations on the users table.
```bash
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE users TO bill_kaplan;
```

<br/>
<br/>
<br/>

### Exit PostgreSQL
Leave the psql interface.
```bash
exit
```
### Exit Postgres User
Return to normal shell user.
```bash
exit
```
### Test Database Login
Verify role can connect to the database.
```bash
psql -h 127.0.0.1 -U bill_kaplan -d db
```


# SQK GitHub Demo 2

### View Table Contents
Display all rows in users table.
```bash
SELECT * FROM users;
```
### Insert First User
Add a sample user record.
```bash
INSERT INTO users (username, email) VALUES ('testuser', 'test@example.com');
```
### Insert Second User
Add another user record.
```bash
INSERT INTO users (username, email) VALUES ('demo_user', 'demo@example.com');
```
### Confirm Inserts
Verify records were added.
```bash
SELECT * FROM users;
```
### Update Username
Change demo_user to your name.
```bash
UPDATE users SET username = 'your_name' WHERE username = 'demo_user';
```
### Confirm Update
Verify the update was successful.
```bash
SELECT * FROM users;
```
### Delete User
Remove a specific user record.
```bash
DELETE FROM users WHERE username = 'your_name';
```
### Confirm Delete
Verify the record was removed.
```bash
SELECT * FROM users;
```
### Exit PostgreSQL
Leave the psql interface.
```bash
exit
```

# SQL GitHub Demo 3

### Edit PostgreSQL Network Settings
Modify listening address configuration.
```bash
sudo nano /etc/postgresql/*/main/postgresql.conf
```
Change `listen_addresses` to:
```192.168.<t>.7```


### Edit Host-Based Authentication
Allow remote access from web server IP.
```bash
sudo nano /etc/postgresql/*/main/pg_hba.conf
```
Scroll to bottom under `IPv4 local connections:`  
Add the following entry (do NOT modify existing lines):

```host  db  bill_kaplan 192.168.<t>.5/32 scram-sha-256```

<br/>
<br/>
<br/>

### Restart Postgres Server 
Applies the updated config
```bash

sudo systemctl restart postgresql
```

### Edit PHP Database Host
Update the database IP in your web file.
```bash
sudo nano /var/www/html/index.php
```
Change:
```192.168.<t>.7```

Example (do NOT type literally unless team 31):
```192.168.31.7```

# SMB / Samba Demo - On the FTP Machine

### Enable Samba Service
Start and enable the SMB daemon immediately.
```bash
sudo systemctl enable smbd --now
```
### Create Shared Directory
Create a directory that will be shared over SMB.
```bash
sudo mkdir -p /mnt/files
```
### Set Directory Permissions
Allow group inheritance and full access permissions.
```bash
sudo chmod 2777 /mnt/files
```
### Create Linux User
Add a system user for SMB authentication.
```bash
sudo useradd benjamin_franklin
```
### Set SMB Password
Create a Samba password for the user.
```bash
sudo smbpasswd -a benjamin_franklin
```
### Edit Samba Configuration
Open Samba config file to define the share.
```bash
sudo nano /etc/samba/smb.conf
```
Add the following share definition:
```text
[files]
    path = /mnt/files
    browseable = yes
    writable = yes
    guest ok = no
```
### Restart Samba Service
Apply configuration changes.
```bash
sudo systemctl restart smbd
```
### Create Test File
Verify share access by adding a file.
```bash
echo "This is TEAM <t> SMB Server" > /mnt/files/TEAM<T>.txt
```
### Test SMB Connection
Connect to the share from a client machine.

NOTE: You can connect to yours or another team's samba share. Just replace the ```<t>``` with their team number
```bash
smbclient //172.18.14.<t>/files -U benjamin_franklin
```
```bash
get TEAM<T>.txt
```
```bash
exit
```
```bash
cat TEAM<T>.txt
```