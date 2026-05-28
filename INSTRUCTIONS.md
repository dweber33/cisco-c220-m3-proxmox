# Installation Guide: Cisco C220 M3 to Proxmox

This guide outlines the surgical process used to install Proxmox on legacy Cisco hardware when the WebUI is inaccessible.

## Phase 1: Physical & Logical Networking
1.  **Cabling:** Connect the Ethernet cable to the dedicated **"M" (Management)** port on the rear of the chassis.
2.  **CIMC Config (F8):** 
    *   Reboot and press `F8` to enter the CIMC Configuration Utility.
    *   Set **NIC Mode** to `Dedicated`.
    *   Disable **VLAN Enabled** (unless your network specifically requires tagging).
    *   Set a static IP (e.g., `192.168.0.149`).
3.  **Connectivity Check:** Verify the connection from your management machine:
    ```bash
    ping 192.168.0.149
    ```

## Phase 2: Remote ISO Mounting (NFS Method)
Because the Flash WebUI is often broken, use a local NFS share to "feed" the ISO to the server.

1.  **Prepare the ISO:** Download the Proxmox ISO to your local machine.
2.  **Setup NFS (Linux example):**
    ```bash
    sudo apt install nfs-kernel-server
    echo "/path/to/iso_folder 192.168.0.149(rw,sync,no_root_squash)" | sudo tee -a /etc/exports
    sudo exportfs -ra
    ```
3.  **Mount via SSH:**
    Connect to the CIMC SSH (`ssh admin@192.168.0.149`) and run:
    ```bash
    scope vmedia
    map-nfs proxmox <YOUR_LOCAL_IP>:/path/to/iso_folder proxmox-ve_9.2-1.iso
    ```

## Phase 3: Boot Configuration
1.  **Set Boot Order:**
    ```bash
    scope bios
    set boot-order CDROM,HDD
    commit
    ```
2.  **Force Reboot:**
    ```bash
    scope chassis
    power cycle
    ```

## Phase 4: Graphical Installation
1.  Launch the **KVM Console** via a legacy-friendly browser (e.g., Pale Moon with Java enabled).
2.  Follow the Proxmox Graphical Installer:
    *   **Disk Selection:** Choose the fastest SSD for the OS (e.g., Kingston 120GB).
    *   **Network:** Assign a static IP (e.g., `192.168.0.150`).
3.  **Finish:** Once the installer completes and reboots, unmap the vMedia and set the boot order back to `HDD,CDROM`.

## Phase 5: Cleanup
Access your new dashboard at `https://192.168.0.150:8006`.
