# ⚙️ cloud-1

This project uses **Ansible** to automate the deployment of a full web stack using **Docker Compose**.
It includes roles for setting up Docker, MariaDB, WordPress, Nginx, and orchestration logic.

## 📁 Directory Structure
```
├── roles/
│ ├── docker/
│ ├── mariadb/
│ ├── wordpress/
│ ├── nginx/
│ └── orchestration/
├── vars/
│ ├── commun.yml
│ └── vault.yml
├── roles.yml
├── invintory.ini
└── README.md
```

## 🚀 How It Works

- **Ansible Roles** are used to modularize the setup.
- **Docker Compose** is used to run services.
- Variables are defined in `commun.yml` (shared variables) and `vault.yml` (encrypted secrets).
- `roles.yml` is the main playbook.

## 📦 Roles Overview

| Role           | Purpose                            |
|----------------|-------------------------------------|
| `docker`       | Install Docker & Docker Compose     |
| `mariadb`      | Deploy MariaDB container            |
| `wordpress`    | Deploy WordPress container          |
| `nginx`        | Set up Nginx reverse proxy          |
| `orchestration`| Manage container coordination/tasks |


## 📚 Ansible Quick Start Tutorial

This tutorial will help you understand the basics of Ansible and guide you through running this project.

---

### 🔹 Basic Concepts

**1. Playbooks**

* A playbook is a YAML file containing one or more **plays**.
* Each play defines **which hosts** to run on, **what tasks** to perform, and optionally which **roles** to apply.
* Example: Your `roles.yml` file that runs roles like `docker`, `mariadb`, `wordpress`, etc.

**2. Roles**

* Roles are reusable, self-contained collections of tasks, files, templates, and variables.
* They organize your automation logically and make it easier to maintain.
* This project uses roles for Docker setup, database, WordPress, Nginx, and orchestration.

**3. Inventory**

* The inventory file (`inventory.ini`) lists the hosts or groups of hosts where Ansible will run tasks.
* You specify connection details here like host IPs, usernames, and SSH keys.

**4. CLI Basics**

* `ansible-playbook` is the command used to run playbooks.
* Common options:

  * `-i` to specify the inventory file
  * `-k` to ask for SSH password
  * `-K` to ask for sudo (become) password
  * `--ask-vault-pass` to decrypt encrypted variable files

---

### 🔹 Step-by-Step Guide

**Step 1: Install Ansible**

If you don’t have Ansible installed, install it with:

```bash
brew install ansible
```

---

**Step 2: Prepare Your Inventory**

Create or edit `inventory.ini` with your target server(s):

```ini
[deploy]
192.168.1.100 ansible_user=root ansible_ssh_private_key_file=/home/rgatnaou/.ssh/id_rsa
```
```ini
[deploy]
192.168.1.100 ansible_user=root ansible_ssh_private_key_file=/home/rgatnaou/.ssh/id_rsa
```
Replace `192.168.1.100` with your server IP and `root` with your SSH user and your public ssh  `ansible_ssh_private_key_file=/home/rgatnaou/.ssh/id_rsa`.

---

**Step 3: Edit Variables**

* Shared variables go into `vars/commun.yml`.
* Sensitive data like passwords go into `vars/vault.yml` (encrypted).
* To edit the vault file securely:

```bash
ansible-vault edit vars/vault.yml
```

---

**Step 4: Test Connectivity**

Make sure Ansible can connect to your servers:

```bash
ansible -i inventory.ini deploy -m ping
```

You should see a "pong" response if deploy is well.

---

**Step 5: Run the Playbook**

Run the full deployment playbook with:

```bash
ansible-playbook -i inventory.ini roles.yml -kK --ask-vault-pass
```

* `-k` asks for SSH password if you don’t use key authentication.
* `-K` asks for sudo password to run tasks with privileges.
* `--ask-vault-pass` prompts for the vault password to decrypt secrets.

---

**Step 6: Verify Deployment**

Check your services (Docker containers, WordPress site, Nginx, etc.) on the deployed host to verify everything is working as expected.

---

* To view help and more options, run:

```bash
ansible-playbook --help
```

---

This tutorial is designed to get you started quickly and understand the core parts of your Ansible project. Feel free to expand or customize it based on your audience!


