# MikroTik RouterOS Script Usage Guide

This document provides a **generic reference** for creating, editing, running, and deleting scripts on a MikroTik Router using **RouterOS CLI**.

It is intended for training environments, competitions, and repeatable infrastructure setup.

---

## Prerequisites

- MikroTik RouterOS installed
- CLI access to the router
- User logged in as `admin` (or another privileged user)

---

## Creating a Script

To create a new script on the router:

```bash
/system script add name=example-script source=""
```
This creates an empty script named `example-script`.

---

## Editing a Script

To edit an existing script:

```bash
/system script edit example-script
```

For value-name: source
This opens the built-in RouterOS text editor.

---

## Saving and Exiting the Editor

Inside the MikroTik script editor:

- **Save file**  
  Press: `CTRL + O`  
  Then press: `ENTER`

- **Exit editor**  
  Press: `CTRL + X`

If you exit without saving, your changes will be lost.

---

## Deleting Script Contents (Clear File)

To remove **all content inside a script** without deleting the script itself:

```bash
/system script set example-script source=""
```
This clears the file while keeping the script entry.

---

## Deleting a Script Entirely

To completely delete a script from the router:

```bash
/system script remove example-script
```
Use this if you want to start over or remove unused scripts.

---

## Setting Global Variables (If Required)

Some scripts require global variables to be set before execution.

Example:

```bash
:global TEAM 2
```
This makes the variable available to the script at runtime.

---

## Running a Script

To execute a script:

```bash
/system script run example-script
```
If the script depends on variables, ensure they are set **before** running it.

---

## Verifying Scripts

List all scripts on the router:

```bash
/system script print
```
Check script source:

```bash
/system script print detail
```
---

## Common Workflow Example

```bash
/system script add name=router-setup source=""
/system script edit router-setup
:global TEAM 2
/system script run router-setup
```
---

## Common Issues

- Script fails immediately  
  - Required global variables not set

- Script partially runs  
  - Syntax error in RouterOS scripting language

- Nothing happens  
  - Script contains no executable commands

---

## Notes

- RouterOS scripting is **order-sensitive**
- Variables must exist **before** execution
- Scripts run with the permissions of the user executing them
- Avoid editing production routers without backups

---

This README is intentionally generic and can be reused across:
- Router setup scripts
- Firewall configuration scripts
- Competition environments
- Lab automation

---
