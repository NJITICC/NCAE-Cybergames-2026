---

## Understanding Key Commands Used in Backup & Recovery

This section explains:

- What each command does  
- What important flags mean  
- Why we are running it  

---

### 1. Distributing SSH Keys

```bash
ssh-copy-id -i /home/backupuser/.ssh/backup_pull_key.pub backupuser@192.168.<t>.5
ssh-copy-id -i /home/backupuser/.ssh/backup_pull_key.pub backupuser@192.168.<t>.12
ssh-copy-id -i /home/backupuser/.ssh/backup_pull_key.pub backupuser@192.168.<t>.7
ssh-copy-id -i /home/backupuser/.ssh/backup_pull_key.pub backupuser@172.18.14.<t>
```

#### What This Command Does

Copies the public SSH key to the remote machine and appends it to:

```
/home/backupuser/.ssh/authorized_keys
```

#### Flag Explanation

- `-i` → Specifies which public key file to install

#### Why We Do This

This allows the backup server to log into each service machine without a password, enabling automated backups.

---

### 2. Locking the backupuser Password

```bash
sudo passwd -l backupuser
```

#### What This Command Does

Locks the password for the user `backupuser`.

#### Flag Explanation

- `-l` → Lock the password (disable password login)

#### Why We Do This

After SSH keys are verified, we disable password login to reduce brute-force attack risk.

---

### 3. Creating Backup Storage Structure

```bash
sudo mkdir -p /backups/web
sudo mkdir -p /backups/dns
sudo mkdir -p /backups/db
sudo mkdir -p /backups/smb
sudo chown -R backupuser:backupuser /backups
```

#### What These Commands Do

- `mkdir -p` → Creates directories (including parents if needed)
- `chown -R` → Changes ownership recursively

#### Flag Explanation

- `-p` → Create parent directories if they do not exist
- `-R` → Apply changes recursively to all files and subdirectories

#### Why We Do This

We organize backups by service and ensure `backupuser` has proper ownership to write files.

---

### 4. Pulling Files with rsync (Backup Operation)

```bash
rsync -avz -e "ssh -i /home/backupuser/.ssh/backup_pull_key" \
backupuser@192.168.<t>.5:/var/www/html/ /backups/web/
```

#### What This Command Does

Pulls files from the remote machine into the backup server.

#### Flag Explanation

- `-a` → Archive mode (preserves permissions, timestamps, ownership)
- `-v` → Verbose (shows file transfer details)
- `-z` → Compress data during transfer
- `-e` → Specify remote shell to use
- `ssh -i` → Use a specific private key for authentication

#### Why We Do This

We create an exact copy of required service files in case they are deleted or modified.

---

# Part 4 – Manual Service Recovery

All restore operations begin from:

```
192.168.<t>.15
```

Login as:

```
backupuser
```

Use key:

```
/home/backupuser/.ssh/backup_pull_key
```

---

## Web Recovery

### From Backup Server

```bash
rsync -avz -e "ssh -i /home/backupuser/.ssh/backup_pull_key" \
/backups/web/ backupuser@192.168.<t>.5:/tmp/web_restore/
```

#### What This Does

Pushes backed-up web files to a temporary directory on the web server.

#### Why We Do This

We stage files safely before replacing the live website directory.

---

### On Web Server

```bash
sudo rsync -av /tmp/web_restore/ /var/www/html/
sudo systemctl restart apache2
```

#### What This Does

- Restores website files
- Restarts Apache to reload content

#### Why We Do This

Restoring files alone is not enough; services must be restarted to reflect changes.

---

## DNS Recovery

### From Backup Server

```bash
rsync -avz -e "ssh -i /home/backupuser/.ssh/backup_pull_key" \
/backups/dns/ backupuser@192.168.<t>.12:/tmp/dns_restore/
```

#### What This Does

Transfers backed-up DNS configuration to the DNS server.

---

### On DNS Server

```bash
sudo rsync -av /tmp/dns_restore/ /etc/bind/
sudo systemctl restart bind9
```

#### Why We Do This

DNS requires correct zone files; restarting ensures new configurations are loaded.

Optional validation:

```bash
sudo named-checkconf
```

---

## PostgreSQL Recovery

### From Backup Server

```bash
rsync -avz -e "ssh -i /home/backupuser/.ssh/backup_pull_key" \
/backups/db/ backupuser@192.168.<t>.7:/tmp/db_restore/
```

#### What This Does

Transfers the logical database dump to the database server.

---

### On Database Server

If database does not exist:

```bash
sudo -u postgres createdb db
```

Restore:

```bash
sudo -u postgres psql db < /tmp/db_restore/db_backup.sql
sudo systemctl restart postgresql
```

#### Why We Do This

Logical dumps recreate database structure and data exactly as they existed at backup time.

Verify:

```bash
sudo -u postgres psql -c "\l"
```

---

## SMB Recovery

### From Backup Server

```bash
rsync -avz -e "ssh -i /home/backupuser/.ssh/backup_pull_key" \
/backups/smb/ backupuser@172.18.14.<t>:/tmp/smb_restore/
```

#### What This Does

Transfers backed-up share files to SMB server.

---

### On SMB Server

```bash
sudo rsync -av /tmp/smb_restore/ /mnt/files/
sudo systemctl restart smbd
```

#### Why We Do This

Required competition artifacts must exist in the SMB share directory.

Verify:

```bash
ls /mnt/files/
```

---

## SSH Recovery

### From Backup Server

```bash
rsync -avz -e "ssh -i /home/backupuser/.ssh/backup_pull_key" \
/backups/ssh_backup/ backupuser@192.168.<t>.5:/tmp/ssh_restore/
```

#### What This Does

Restores user SSH configurations.

---

### On Target Server

```bash
sudo rsync -av /tmp/ssh_restore/ /home/
sudo systemctl restart ssh
```

#### Why We Do This

If `authorized_keys` is deleted, SSH login fails and scoring will fail.

---