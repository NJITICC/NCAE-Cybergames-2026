

# VM Setup NCAE Cyber Games - 2026



This document explains, step-by-step, how to install and configure the Linux virtual machines (Ubuntu and Rocky) in VirtualBox for future labs.



---



## ISO Operating System Download



### 1. Download Ubuntu ISO

```bash

https://ubuntu.com/download/desktop/thank-you?version=24.04.3&architecture=amd64&lts=true

```

![Ubuntu ISO](./img/GitHubVM/UbuntuDownload.png)



### 2. Download Rocky 8 ISO

```bash

https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.10-x86_64-boot.iso

```

![Rocky ISO](./img/GitHubVM/RockyISODownload.png)



---



## VirtualBox Installation



### 1. Install VirtualBox from:

```bash

https://www.virtualbox.org/wiki/Downloads

```

![VirtualBox Download](./img/GitHubVM/VirtualBoxDownload.png)



### 2. Install the binary (use default installation path)

![Default Install](./img/GitHubVM/DefaultInstallGiF.gif)



### 3. Open VirtualBox → Select **New**

![Create New VM](./img/GitHubVM/CreateVirtualMachineNew.png)



### 4. Configure the Virtual Machine

If a field is **not** listed, leave the default value.



#### Name and Operating System

- **Name:** `NCAE-RockyVM`

- **ISO Image:** Select your downloaded Ubuntu or Rocky ISO



![Name and OS](./img/GitHubVM/NameAndOperatingSystem.png)



Skip unattended installation:

![Unattended Install](./img/GitHubVM/UnattendedInstall.png)



#### Hardware

- Base Memory: **4096 MB**

- Processors: **2**



![Hardware](./img/GitHubVM/Hardware.png)



#### Hard Disk

- Disk Size: Minimum **20GB**, recommended **50GB**



![Hard Disk](./img/GitHubVM/Harddisk.png)



After completing configuration, select **Finish**.



---



## VM Setup



### 1. Start the VM



### 2. At the GRUB prompt, choose **Install [OS]**

![Grub Prompt](./img/GitHubVM/GrubPrompt.png)



### 3. Follow the installation steps



#### Language Selection

![Language Selection](./img/GitHubVM/LanguageSelection.png)



---



## Installation Summary



### Root Account Setup

![Root Account](./img/GitHubVM/RootAccount.png)



- **Root Password:** `NCAELAB`

![Root Password Config](./img/GitHubVM/RootPasswordConfig.png)



### Create User

![User Creation](./img/GitHubVM/UserCreation.png)



- Full Name: `NCAE Lab2026`

- Username: `nlab2026`

- Password: `NCAE`

- Make this user administrator: Checked



### Installation Destination

![Installation Destination](./img/GitHubVM/InstallationDestination.png)



### Network & Hostname

![Network Hostname](./img/GitHubVM/NetworkAndHostName.png)



Set hostname: **yourname-NCAE**  

Enable network.

![Network Host Config](./img/GitHubVM/NetworkAndHostNameConfig.png)



### Software Selection

![Software Selection](./img/GitHubVM/SoftwareSelectionConfig.png)



### Begin OS Install

![OS Installed](./img/GitHubVM/OSInstalled.png)



---



## VM Guest Utils Installation



This enables clipboard sharing, drag-and-drop, and better VM integration.



### 1. Insert Guest Additions ISO

![Insert Guest](./img/GitHubVM/InsertGuest.png)



### 2. Open Terminal

![Open Terminal](./img/GitHubVM/OpenTerminal.png)



### 3. Install Required Dependencies



**Ubuntu:**

```bash

sudo apt update

sudo apt install -y bzip2 build-essential dkms linux-headers-$(uname -r)

sudo ./VBoxLinuxAdditions.run

reboot

```



**Rocky:**

```bash

sudo dnf update -y

sudo dnf install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r)

```

![Dependency Install](./img/GitHubVM/DependInstall.png)



```bash

sudo ./VBoxLinuxAdditions.run

```

![VBox Additions Install](./img/GitHubVM/VBoxAddInstall.png)



### 4. Enable Shared Clipboard

![Shared Clipboard](./img/GitHubVM/SharedClipboard.png)



### 5. Add Shared Folder

![Shared Folder](./img/GitHubVM/SharedFolder.png)



### 6. Configure Network Adapter

![Network Adapter](./img/GitHubVM/NetworkAdapter.png)



![Network Adapter Config](./img/GitHubVM/NetworkAdapterConfig.png)



### 7. Reboot VM

```bash

reboot

```

![Reboot](./img/GitHubVM/Reboot.png)



### 8. Take a Snapshot

Go to Machine -> Take Snapshot

Snapshot Name: `[OS]_Baseline`

Description: This is the NCAE VM Lab Baseline
