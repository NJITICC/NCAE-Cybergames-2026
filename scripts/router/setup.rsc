#############################################
# NCAE MikroTik Router Auto Configuration
#############################################

:global TEAM

:if ([:typeof $TEAM] = "nothing") do={
    :put "ERROR: TEAM number not set."
    :put "Run: :global TEAM <team_number>"
    :error
}

:local teamNum $TEAM

:put "======================================="
:put (" NCAE MikroTik Router Setup - TEAM " . $teamNum)
:put "======================================="

#############################################
# Clean existing config
#############################################

/ip address remove [find]
/ip route remove [find]
/ip firewall nat remove [find]
/interface bridge remove [find]
/interface bridge port remove [find]

#############################################
# WAN
#############################################

/interface bridge add name=WAN
/interface bridge port add bridge=WAN interface=ether1

/ip address add \
    address=("172.18.13." . $teamNum . "/16") \
    interface=WAN

/ip route add \
    dst-address=0.0.0.0/0 \
    gateway=172.18.0.1

#############################################
# LAN
#############################################

/interface bridge add name=LAN
/interface bridge port add bridge=LAN interface=ether2

/ip address add \
    address=("192.168." . $teamNum . ".1/24") \
    interface=LAN

#############################################
# NAT (last)
#############################################

/ip firewall nat add \
    chain=srcnat \
    src-address=("192.168." . $teamNum . ".0/24") \
    out-interface=WAN \
    action=masquerade

#############################################
# Done
#############################################

:put "======================================="
:put "Router configuration complete"
:put ("WAN IP: 172.18.13." . $teamNum)
:put ("LAN IP: 192.168." . $teamNum . ".1")
:put "======================================="
