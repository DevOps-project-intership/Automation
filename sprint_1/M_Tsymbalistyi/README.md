# VM's Setup Script

This Bash script automates the setup of a servers virtual machines by installing required dependencies, cloning the repository from GitHub, and configuring **Nginx**.

## Features
- Updates system packages using `apt`.
- Installs required dependencies if missing:
  - **nginx**
  - **python3**
  - **flask**
  - **git**
- Clones repository from GitHub using a specified branch and Personal Access Token (PAT).
- Backs up existing configuration and project files:
  - `nginx.conf` → `/etc/nginx/nginx.conf`
  - `index.html` → `/var/www/html/index.html`
- Reloads Nginx after configuration.

## Usage

```bash
./setup.sh <branch> <pat_token>
```
