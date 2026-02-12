#############################################
# NCAE Unified Port Forward + Firewall Script
#############################################

:global TEAM

:if ([:typeof $TEAM] = "nothing") do={
    :put "ERROR: TEAM number not set."
    :put "Run: :global TEAM <your_team_number>"
    :error
}

:local t $TEAM

:put "======================================="
:put (" NCAE Firewall + Port Forwards - TEAM " . $t)
:put "======================================="

#############################################
# Remove existing NCAE dst-nat rules (safe)
#############################################

/ip firewall nat remove [find chain=dstnat]

#############################################
# PORT FORWARDS (DST-NAT)
#############################################

# Web (HTTP)
/ip firewall nat add chain=dstnat in-interface=WAN protocol=tcp dst-port=80 \
    action=dst-nat to-addresses=("192.168.".$t.".5") to-ports=80

# Web (HTTPS)
/ip firewall nat add chain=dstnat in-interface=WAN protocol=tcp dst-port=443 \
    action=dst-nat to-addresses=("192.168.".$t.".5") to-ports=443

# DNS (UDP)
/ip firewall nat add chain=dstnat in-interface=WAN protocol=udp dst-port=53 \
    action=dst-nat to-addresses=("192.168.".$t.".12") to-ports=53

# DNS (TCP)
/ip firewall nat add chain=dstnat in-interface=WAN protocol=tcp dst-port=53 \
    action=dst-nat to-addresses=("192.168.".$t.".12") to-ports=53

# Database (MySQL)
/ip firewall nat add chain=dstnat in-interface=WAN protocol=tcp dst-port=3306 \
    action=dst-nat to-addresses=("192.168.".$t.".7") to-ports=3306

# SSH (External Shell)
/ip firewall nat add chain=dstnat in-interface=WAN protocol=tcp dst-port=22 \
    action=dst-nat to-addresses=("172.18.14.".$t) to-ports=22

# FTP (Control)
/ip firewall nat add chain=dstnat in-interface=WAN protocol=tcp dst-port=21 \
    action=dst-nat to-addresses=("172.18.14.".$t) to-ports=21

#############################################
# ENSURE DST-NAT RULES ARE ABOVE MASQUERADE
#############################################

:foreach i in=[/ip firewall nat find chain=dstnat] do={
    /ip firewall nat move $i 0
}

#############################################
# FIREWALL FILTER RULES
#############################################

# Allow established/related
/ip firewall filter remove [find comment="NCAE-ESTABLISHED"]
/ip firewall filter add chain=forward connection-state=established,related \
    action=accept comment="NCAE-ESTABLISHED"

# Allow forwarded TCP services
/ip firewall filter remove [find comment="NCAE-TCP-SERVICES"]
/ip firewall filter add chain=forward in-interface=WAN out-interface=LAN \
    protocol=tcp dst-port=21,22,80,443,3306 \
    action=accept comment="NCAE-TCP-SERVICES"

# Allow DNS (UDP)
/ip firewall filter remove [find comment="NCAE-DNS-UDP"]
/ip firewall filter add chain=forward in-interface=WAN out-interface=LAN \
    protocol=udp dst-port=53 \
    action=accept comment="NCAE-DNS-UDP"

#############################################
# DONE
#############################################

:put "======================================="
:put " Firewall + Port Forwarding Complete"
:put " Exposed Services:"
:put "  - HTTP / HTTPS"
:put "  - DNS (TCP/UDP)"
:put "  - MySQL"
:put "  - SSH / FTP"
:put "======================================="
