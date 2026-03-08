# Reset Root Password and Configure GRUB Timeout
This guide shows how to extend the GRUB timeout and reset the root password on Ubuntu and Rocky Linux systems using single user mode.

---

# Ubuntu

## Extend GRUB Menu Timeout

Open the GRUB configuration file.

```bash
sudo nano /etc/default/grub
```

Modify or add the following lines.

```bash
GRUB_TIMEOUT=-1
GRUB_TIMEOUT_STYLE=menu
```

Explanation:

- `GRUB_TIMEOUT=-1` makes GRUB wait indefinitely so the boot menu always appears.
- `GRUB_TIMEOUT_STYLE=menu` forces the menu to display instead of hiding it.

Save and exit the file.

```
Ctrl + X
```

Regenerate the GRUB configuration so the changes take effect.

```bash
sudo update-grub
```

Reboot the system.

```bash
sudo reboot
```

---

# Reset Root Password (Ubuntu)

## Step 1 — Enter GRUB

Reboot the machine.

During boot, hold **Shift** or press **Esc repeatedly** until the GRUB menu appears.

You should see something similar to:

```
Ubuntu
Advanced options for Ubuntu
```

---

## Step 2 — Edit the Boot Entry

Highlight the normal Ubuntu boot entry and press:

```
e
```

This opens the GRUB boot editor where kernel parameters can be modified.

---

## Step 3 — Modify the Kernel Line

Find the line beginning with:

```
linux
```

Example:

```
linux /boot/vmlinuz-... root=UUID=... ro quiet splash
```

Change:

```
ro
```

to:

```
rw
```

Then append the following to the end of the line:

```
init=/bin/bash
```

Example final line:

```
linux /boot/vmlinuz-... root=UUID=... rw quiet splash init=/bin/bash
```

Explanation:

- `rw` mounts the root filesystem as read/write.
- `init=/bin/bash` boots directly into a root shell instead of the normal login system.

---

## Step 4 — Boot the Modified Entry

Press:

```
Ctrl + X
```

The system will boot directly into a root shell.

---

## Step 5 — Reset the Root Password

Run:

```bash
passwd root
```

This command sets a new password for the root account.

---

## Step 6 — Write Changes to Disk

Run:

```bash
sync
```

This ensures the filesystem writes all pending changes to disk.

---

## Step 7 — Reboot

Run:

```bash
reboot -f
```

This forces the system to reboot immediately.

---

# Rocky Linux

## Extend GRUB Menu Timeout

Open the GRUB configuration file.

```bash
sudo nano /etc/default/grub
```

Set the following values.

```bash
GRUB_TIMEOUT_STYLE=menu
GRUB_TIMEOUT=-1
```

Explanation:

- `GRUB_TIMEOUT=-1` causes GRUB to wait indefinitely.
- `GRUB_TIMEOUT_STYLE=menu` ensures the boot menu is always shown.

Save the file.

```
Ctrl + X
```

Regenerate the GRUB configuration.

```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

This rebuilds the boot configuration so the timeout change takes effect.

Reboot the system.

```bash
sudo reboot
```

---

# Reset Root Password (Rocky Linux)

## Step 1 — Enter GRUB

Reboot the machine and wait for the GRUB menu.

Highlight the Rocky Linux boot entry and press:

```
e
```

This opens the GRUB editor.

---

## Step 2 — Modify the Kernel Line

Find the line beginning with:

```
linux
```

Example:

```
linux ($root)/vmlinuz-... root=/dev/mapper/rl-root ro crashkernel=auto rhgb quiet
```

Append the following to the end of the line:

```
rd.break
```

Example final line:

```
linux ($root)/vmlinuz-... root=/dev/mapper/rl-root ro crashkernel=auto rhgb quiet rd.break
```

Explanation:

- `rd.break` interrupts the boot process and drops the system into an early emergency shell.

---

## Step 3 — Boot the Modified Entry

Press:

```
Ctrl + X
```

The system will boot into a **dracut emergency shell**.

You should see a prompt similar to:

```
switch_root:/#
```

---

## Step 4 — Remount the Filesystem

Run:

```bash
mount -o remount,rw /sysroot
```

Explanation:

- The root filesystem is mounted as read-only during the early boot environment.
- This command remounts it as read/write so changes can be made.

---

## Step 5 — Enter the System Environment

Run:

```bash
chroot /sysroot
```

Explanation:

- `chroot` changes the root directory of the shell to the real system filesystem.
- This allows commands like `passwd` to operate on the installed system.

---

## Step 6 — Reset the Root Password

Run:

```bash
passwd root
```

This sets a new password for the root user.

---

## Step 7 — Fix SELinux Labels

Run:

```bash
touch /.autorelabel
```

Explanation:

- This creates a flag file telling SELinux to relabel the filesystem on the next boot.
- Without this step, login may fail due to incorrect security contexts.

---

## Step 8 — Exit the Environment

Run:

```bash
exit
```

Then run:

```bash
exit
```

This leaves the chroot environment and the emergency shell.

---

## Step 9 — Reboot

```bash
reboot
```

During boot, the system will perform a filesystem relabel if SELinux is enabled.

After reboot, log in as:

```
root
```

using the new password.