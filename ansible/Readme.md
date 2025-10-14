# Ansible Configuration – Automated Provisioning on AWS

## 📘 Overview
This part of the project automates **server provisioning and configuration** using Ansible.  
Each component — **Consul**, **PostgreSQL Database**, **Flask Web App**, and **Load Balancer** — is managed through its own playbook.  
The configuration ensures consistency, repeatability, and integration within the CI/CD pipeline (triggered via Jenkins).

---

## Project Structure
ansible/
├── collections/          # Installed roles and Ansible Galaxy collections
├── group_vars/           # Global and environment-specific variables
├── templates/            # Jinja2 templates for configs, .env, and systemd units
├── consul.yml            # Consul server, Prometheus, Grafana setup
├── db.yml                # PostgreSQL installation and database initialization
├── flask.yml             # Flask app deployment with Nginx and Consul integration
├── lb.yml                # Load Balancer setup with Nginx + consul-template
├── inventory.ini         # Hosts inventory (EC2 instances)
└── ssh_config            # SSH configuration for remote access
---

## ⚙️ Playbook Overview

### **1. Consul**
- Installs and configures Consul server  
- Sets up **Prometheus** and **Grafana** for monitoring  
- Enables automatic service discovery  

```bash
ansible-playbook consul.yml -i inventory.ini
```

2. Database
	•	Installs and configures PostgreSQL 16
	•	Initializes database, creates users and tables
	•	Enables Consul service registration for DB monitoring
    
    ```bash
    ansible-playbook db.yml -i inventory.ini
    ```

3. Flask Web Server
	•	Deploys Flask app from private GitHub repository
	•	Creates Python virtual environment and installs dependencies
	•	Configures Nginx reverse proxy and Consul integration
    
    ```bash
    ansible-playbook flask.yml -i inventory.ini
    ```

4. Load Balancer
	•	Installs and configures Nginx + consul-template
	•	Integrates with Consul for dynamic backend discovery
	•	Auto-updates Nginx when backend services change
    ```bash
    ansible-playbook lb.yml -i inventory.ini
    ```

    Requirements
	•	Ansible 2.15+
	•	SSH access configured (ssh_config file)
	•	EC2 instances accessible with correct security group rules (ports 22, 80, 8300–8500)
	•	Python + boto3 installed on control node