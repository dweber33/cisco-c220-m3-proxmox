# Lessons Learned: Cisco C220 M3 Lab Deployment

Managing legacy enterprise hardware in a modern environment provides several critical engineering insights.

## 1. The "Flash/Java Wall"
Legacy CIMC (pre-version 3.1) is heavily dependent on Adobe Flash for the WebUI and Java for the KVM console. 
- **Solution:** Use **Pale Moon** browser with `plugin.load_flash_only` set to `false`. 
- **Insight:** Always keep an "Administration VM" or a portable browser environment with legacy plugins for managing older infrastructure.

## 2. NIC Mode Nuances
The Cisco C220 has three distinct NIC modes: `Dedicated`, `Shared LOM`, and `Shared LOM Ext`. 
- **Dedicated:** Only uses the physical "M" port.
- **Shared LOM:** Tunnels management traffic through the built-in 1GbE data ports.
- **Shared LOM Ext:** Uses a PCIe VIC (Virtual Interface Card).
- **Lesson:** Physical link lights do not guarantee logical connectivity if the software is listening on a different "NIC Mode."

## 3. Virtual Media Stability
Mounting an ISO through a browser (vMedia) is prone to timing out and crashing. 
- **Better Approach:** Using **NFS (Network File System)** to map the ISO directly to the CIMC via SSH is significantly more stable and bypasses browser-layer failures.

## 4. SSH vs. WebUI Logic
The CIMC CLI (SSH) is often more robust than the WebUI, but it has its own quirks.
- Commands like `map-www` or `map-nfs` require specific URL splitting (Path vs. File) depending on the firmware version.
- **Lesson:** When the WebUI fails, the CLI is the "Source of Truth," but always use `show commands` to verify syntax for your specific firmware revision.

## 5. Proxmox on M3
- **ZFS Integration:** Proxmox's native ZFS support is a perfect match for the M3's hardware, but only if the RAID controller is in "JBOD" or "HBA" mode. 
- **Performance:** Using an SSD for the Proxmox root partition is mandatory for a responsive experience on this generation of hardware.
