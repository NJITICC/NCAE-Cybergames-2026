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



## Configure Network Topology 

Each member of your team, follow the NCAE diagram on the screen to configure your environment correctly

### 1. Router Setup

#### Set the global
< t > = team number (example :global TEAM 1)
```bash
:global TEAM <t>
```

#### Run the script
This is a custom script I made to expedite the lab setup. Will not be there by default on competition day. 
```bash
/system script run router-setup-script
```

### 2. Configure the machines in your environment

The commands across the machines is similar, configure enough machines for each member on your team. The topology shows that:

- **Web = 192.168.t.5**
- **Database (DB) = 192.168.t.7**
- **DNS = 192.168.t.12**

**x** = the last octet (number) in the IP address

The following nmcli commands must be run on each machine

### Assign IPv4 Address
```bash
sudo nmcli connection modify "Wired connection 1" ipv4.address "192.168.<t>.x/24"
```
### Assign Default Gateway
```bash
sudo nmcli connection modify "Wired connection 1" ipv4.gateway "192.168.<t>.1"
```
### Set IPv4 Method
```bash
sudo nmcli connection modify "Wired connection 1" ipv4.method manual
```
### Set DNS IP
```bash
sudo nmcli connection modify "Wired connection 1" ipv4.dns "172.18.0.12"
```
### Restart Connection
```bash
sudo nmcli connection down "Wired connection 1"  
sudo nmcli connection up "Wired connection 1"
```
### Test Connectivity
```bash
ping -c 3 192.168.<t>.1  
ping -c 3 172.18.0.1
```
## SSH Lab 

### 3. Install and configure the SSH

Some machines have an SSH server, some do not. The following will ensure it's installed and configured:

```bash
sudo apt update && sudo apt install ssh -y
```

```bash
sudo systemctl start ssh
```

```bash
sudo systemctl status ssh
```

Should have a green light

### 4. Remote into your partners machine and perform the lab

Where **x** is your partners IP. You can do ```ip a``` to see what your IP is if you're unsure
#### Login in to partner's machine
```bash
ssh ncae-lab2026@192.168.<t>.x
```
- Enter Yes at the prompt

- Enter your password, which is ```NCAE```. 

**IMPORTANT:** You won't see your password when you type, that is fine. It is typing the credentials you just can't see it 

#### Commands to show you logged in

#### Change to the user's desktop
The ```~``` (tilda), is an alias to reference the user's home directory
```bash
cd ~/Desktop
```
#### Create the text file
```bash
nano i_was_here.txt
```
#### Add the text
```text
your_name was here
```
#### To save file
```bash
CTRL + X -> Y -> Enter
```
#### Exit the SSH session 

```bash
exit
```

On your machine, you should see a file from your partner with their name in it.


## SSH Lab Pt2

On your host machine (the one you started on), run the following commands:

### Generate public and private SSH keys
```bash
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/your_name -C "This is your_name SSH keypair"
```
##### Flag field info:
- ssh-keygen – Generates SSH keys
- t – Algorithm type
- a – Key derivation rounds
- f – Output file location
- C – Comment/label for identification

**IMPORTANT**: Do not set a password for this lab, just press Enter on the prompts. 
### Copy the public ssh key
```bash
cat ~/.ssh/your_name.pub
```
Then with your mouse highlight / double click the output and copy

### Login in to partner's machine
Where **x** is your partners IP. You can do ```ip a``` to see what your IP is if you're unsure
```bash
ssh ncae-lab2026@192.168.<t>.x
```

### Add the key to the authorized_keys file
```bash
echo "PASTE FULL PUBLIC KEY HERE" >> ~/.ssh/authorized_keys
```
### EXAMPLE: DO NOT COPY THIS
```bash
echo "AAAAC3NzaC1lZDI1NTE5AAAAIBxQNisO6y5CvMAGcYUM4peaOMQW8TPYB7HKunKEJn62" >> ~/.ssh/authorized_keys
```

#### Exit the SSH Session 
```bash
exit
```

### Login in to partner's machine
This shouldn't prompt you a password
```bash
ssh ncae-lab2026@192.168.<t>.x
```

## HTTPS Lab

Navigate to: ```http://192.168.<t>.1```

### Open HTTP Port (80) HTTPS Port (443)

Go to **Advanced** → **IP** → **Firewall** → **NAT** → **New**

**General Tab**
```text
- Chain: dstnat
- Protocol: tcp
- Dst. Port: 443
- In. Interface: WAN
```

**Action Tab**
```text
- Action: dst-nat
- To Addresses: 192.168.<t>.5
- To Ports: 443
```

To allow forwarded HTTPS traffic to pass through the router, add a firewall
filter rule.

Go to **Advanced** → **IP** → **Firewall** → **Filter Rules** → **New**

**General Tab**
```text
- Chain: forward
- Protocol: tcp
- Dst. Port: 443
- In. Interface: WAN
- Out. Interface: LAN
```

---

### Open HTTP Port (80)
Go to **Advanced** → **IP** → **Firewall** → **NAT** → **New**

**General Tab:**
```text
- Chain: dstnat
- Protocol: tcp
- Dst. Port: 80
- In. Interface: WAN
```

**Action Tab:**
```text
- Action: dst-nat
- To Addresses: 192.168.<t>.5
- To Ports: 80
```

Go to **Advanced** → **IP** → **Firewall** → **Filter Rules** → **New**

**General Tab**
```text
- Chain: forward
- Protocol: tcp
- Dst. Port: 80
- In. Interface: WAN
- Out. Interface: LAN
```

## Certbot certificate install

NOTE: Only the Webserver person can do this. So, others can just watch

Download the root CA certificate:

```bash
wget https://ca.ncaecybergames.org/roots.pem --no-check-certificate
```
Copy the certificate into the system trust store:

```bash
sudo cp roots.pem /usr/local/share/ca-certificates/ncae-root-ca.crt
```
Update trusted certificates:

```bash
sudo update-ca-certificates
```
---

### Install the Cert for the webserver

```bash
sudo certbot --apache --server https://ca.ncaecybergames.org/acme/acme/directory -d www.team<t>.ncaecybergames.org
```
Prompts as follows:

email address: ```example@example.com```

Enter ```no```


### Install the Cert for your browser

1. Open ```firefox```

2. Click the hamburger (three lines) in the top right hand corner of the browser

3. Scroll down to ```Settings```

4. In the search bar, search ```certificates```

5. Click ```View Certificates```

6. Click on the ```Authorities``` tab

7. Click ```Import...```

8. Go to the directory you downloaded the certificate (should be in home) and select ```roots.pem```

9. In the next box called ```Downloading Certificate```, select all the check boxes and then select ```ok```

10. Navigate to another team's website ```https://www.team<t>.ncaecybergames.org```