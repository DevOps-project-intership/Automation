# Setup Script for Ansible, Java, and Jenkins

## Description
This Bash script automates the installation of **Ansible**, **Java (Temurin JDK 21)**, and **Jenkins** on Ubuntu/Debian systems.  

---

## Features
The script consists of several functions:

### 🔹 `ansible_setup`
- Checks if Ansible is installed (`ansible --version`).
- If missing:
  - Adds the official `ppa:ansible/ansible` repository.
  - Updates package list.
  - Installs Ansible.

### 🔹 `java_setup`
- Checks if Java is installed (`java --version`).
- If missing:
  - Adds the Adoptium GPG key and repository.
  - Updates package list.
  - Installs **Temurin JDK 21**.

### 🔹 `jenkins_setup`
- Checks if Jenkins is installed (`jenkins --version`).
- If missing:
  - Adds the official Jenkins key and repository.
  - Updates package list.
  - Installs Jenkins.

### 🔹 `additional_packages`
- Checks if Python3 is installed.
- If missing:
  - Installs Python3.

### 🔹 `main`
Runs all functions in order:
1. `additional_packages`  
2. `ansible_setup`  
3. `java_setup`  
4. `jenkins_setup`  

---

## 🚀 Usage
1. Ensure that script have execution rights.
2. Run ```./setup_jensible.sh```