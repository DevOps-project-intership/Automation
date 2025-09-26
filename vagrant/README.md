# Vagrant Infrastructure Setup

## Project Overview
This project provisions an infrastructure of **three virtual machines** using **Vagrant** and **VirtualBox**.  
The goal is to provide a ready-to-use environment for testing, development, and automation with **Ansible**.

The infrastructure consists of:

- **Flask Server (Web Server)**  
  Runs a Python Flask application and acts as the main entry point for client requests.  
  It simulates a production-like web service environment.

- **PostgreSQL Server (Database)**  
  Provides a PostgreSQL database backend for the Flask application.  
  It is preconfigured to be accessible from the web server and optimized for local development.

- **Load Balancer Server**  
  Balances traffic between multiple web servers (currently a single Flask server, but can be scaled).  
  Useful for simulating high availability and scaling scenarios.
---

## Structure
- `Vagrantfile` — main configuration file for setting up the infrastructure.  
- `inventory.ini` — automatically generated Ansible inventory file for managing virtual machines.  
- `build_installer.sh` — script that creates a self-extracting installer (executed during `vagrant up`).  

---


### Start the Infrastructure
```bash
vagrant up
```

### Check VM Status
```bash
vagrant status
```

### Connection to VB usig SSH
```bash
vagrant ssh server
```

```bash
vagrant ssh database
```

```bash
vagrant ssh load_balancer
```


### Stop all machines

```bash
vagrant halt
```

### Destroy all machines

```-bash
vagrant destroy -f
```