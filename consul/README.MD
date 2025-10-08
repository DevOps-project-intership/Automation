
# Consul Setup Guide

## 1. Verify Consul Installation

Make sure Consul is installed and accessible by running:

```bash
consul -v
```

If the command is not found, install Consul before proceeding.

---

## 2. Configure Consul

Choose the appropriate `consul.hcl` configuration file for your environment, then place it in:

```
/etc/consul.d/consul.hcl
```

Make sure the file permissions are set correctly so Consul can read it.

---

## 3. Start Consul

If you're deploying a service, ensure that the **Consul server** is already running.

Once everything is configured, enable and start the Consul service:

```bash
sudo systemctl enable --now consul
```

You can check the service status with:

```bash
sudo systemctl status consul
```

---

**Done!** Consul should now be running with your configuration.
