# Lesson X – Rocky 9 DNS Server Guide

This machine provides both:

- Internal DNS (```team<t>.net```)
- External DNS (```team<t>.cnyhackathon.org```)

<t> = team number

Internal DNS IP: ```192.168.<t>.12```
External DNS IP: ```172.18.13.<t>```

---

# Install Bind

```bash
sudo dnf install bind -y
```

---

# Enable & Start Named

```bash
sudo systemctl enable named
sudo systemctl start named
```

---

# Open Firewall for DNS

```bash
sudo firewall-cmd --permanent --add-service=dns
sudo firewall-cmd --reload
```

---

# Configure named.conf

Open:

```bash
sudo vi /etc/named.conf
```

Ensure the options block looks like this:

```text
options {
    listen-on port 53 { any; };
    listen-on-v6 port 53 { any; };
    directory       "/var/named";
    allow-query     { any; };
    recursion yes;
    dnssec-enable yes;
    dnssec-validation yes;
};
```

Save and exit.

---

# Create Internal Forward Zone

```bash
sudo vi /var/named/forward.team<t>.net
```

```text
$TTL 86400
@   IN  SOA ns1.team<t>.net. root.team<t>.net. (
        2
        604800
        86400
        2419200
        86400 )

@       IN  NS  ns1.team<t>.net.
ns1     IN  A   192.168.<t>.12
www     IN  A   192.168.<t>.5
db      IN  A   192.168.<t>.7
```

---

# Create Internal Reverse Zone

```bash
sudo vi /var/named/reverse.team<t>.net
```

```text
$TTL 86400
@   IN  SOA ns1.team<t>.net. root.team<t>.net. (
        2
        604800
        86400
        2419200
        86400 )

@   IN  NS  ns1.team<t>.net.

5   IN  PTR www.team<t>.net.
7   IN  PTR db.team<t>.net.
12  IN  PTR ns1.team<t>.net.
```

---

# Register Internal Zones

Open:

```bash
sudo vi /etc/named.conf
```

Add at bottom:

```text
zone "team<t>.net" IN {
    type master;
    file "forward.team<t>.net";
    allow-update { none; };
};

zone "<t>.168.192.in-addr.arpa" IN {
    type master;
    file "reverse.team<t>.net";
    allow-update { none; };
};
```

---

# Create External Forward Zone

```bash
sudo vi /var/named/forward.team<t>.cnyhackathon.org
```

```text
$TTL 86400
@   IN  SOA ns1.team<t>.cnyhackathon.org. root.team<t>.cnyhackathon.org. (
        2
        604800
        86400
        2419200
        86400 )

@       IN  NS  ns1.team<t>.cnyhackathon.org.
ns1     IN  A   172.18.13.<t>
www     IN  A   172.18.13.<t>
shell   IN  A   172.18.14.<t>
files   IN  A   172.18.14.<t>
```

---

# Create External Reverse Zone – 13 Network

```bash
sudo vi /var/named/reverse.13.<t>
```

```text
$TTL 86400
@   IN  SOA ns1.team<t>.cnyhackathon.org. root.team<t>.cnyhackathon.org. (
        2
        604800
        86400
        2419200
        86400 )

@   IN  NS  ns1.team<t>.cnyhackathon.org.

<t> IN PTR ns1.team<t>.cnyhackathon.org.
<t> IN PTR www.team<t>.cnyhackathon.org.
```

---

# Create External Reverse Zone – 14 Network

```bash
sudo vi /var/named/reverse.14.<t>
```

```text
$TTL 86400
@   IN  SOA ns1.team<t>.cnyhackathon.org. root.team<t>.cnyhackathon.org. (
        2
        604800
        86400
        2419200
        86400 )

@   IN  NS  ns1.team<t>.cnyhackathon.org.

<t> IN PTR shell.team<t>.cnyhackathon.org.
<t> IN PTR files.team<t>.cnyhackathon.org.
```

---

# Register External Zones

Open:

```bash
sudo vi /etc/named.conf
```

Add:

```text
zone "team<t>.cnyhackathon.org" IN {
    type master;
    file "forward.team<t>.cnyhackathon.org";
    allow-update { none; };
};

zone "13.18.172.in-addr.arpa" IN {
    type master;
    file "reverse.13.<t>";
    allow-update { none; };
};

zone "14.18.172.in-addr.arpa" IN {
    type master;
    file "reverse.14.<t>";
    allow-update { none; };
};
```

---

# Fix Permissions & SELinux

```bash
sudo chown named:named /var/named/*
sudo restorecon -Rv /var/named
```

---

# Restart DNS

```bash
sudo systemctl restart named
```

---

# Validate Configuration

```bash
sudo named-checkconf
sudo named-checkzone team<t>.net /var/named/forward.team<t>.net
```

---

# Confirm Listening

```bash
sudo ss -tulpn | grep :53
```

You must see:

0.0.0.0:53

---

# Test Internal

```bash
dig www.team<t>.net @192.168.<t>.12
```

---

# Test External

```bash
dig www.team<t>.cnyhackathon.org @172.18.13.<t>
```

If both respond, scoring will succeed.