# Cisco IMC (CIMC) SSH Reference Sheet

A collection of essential commands for managing Cisco C-Series servers via the Command Line Interface (CLI).

## 🌍 Global Navigation
- `top`: Return to the root directory.
- `exit`: Go up one level.
- `show detail`: Detailed status of the current scope.
- `show commands`: List available actions in the current scope.

## 💿 Virtual Media (vMedia)
```bash
scope vmedia
# View status
show mappings
# Map an ISO via HTTP (Note the space between path and filename)
map-www <vol_name> http://<ip>/path/ <filename>.iso
# Map an ISO via NFS
map-nfs <vol_name> <ip>:/path <filename>.iso
# Remove a mapping
unmap <vol_name>
```

## ⚙️ BIOS & Boot Order
```bash
scope bios
# Set boot sequence (Case sensitive: CDROM, HDD, FDD, PXE)
set boot-order CDROM,HDD
commit
```

## ⚡ Chassis & Power
```bash
scope chassis
# Power controls
power on
power off
power cycle
# Check health
show sel        # System Event Log
show sensors    # Temperatures and Voltages
```

## ❄️ Fan Policy (Noise Reduction)
```bash
scope fan-policy
# Set to balanced for home lab use
set availability-balanced-fan-policy enabled
commit
```

## 🌐 Network Settings
```bash
scope network
show detail
# Change management IP (Careful: will drop connection)
set addr 192.168.0.149
set mask 255.255.255.0
set gw 192.168.0.1
commit
```
