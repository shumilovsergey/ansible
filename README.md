# Ansible

A stateless, portable Ansible setup running in Docker. Clone this repo on any machine (home, work, laptop) and configure it for your environment.

## Quick Start

1. **Copy the configuration templates:**
   ```bash
   cp .env.example .env
   cp inventory.example.yml inventory.yml
   ```

2. **Edit `.env` with your settings:**
   ```bash
   ANSIBLE_USER=your_ssh_user
   SSH_PRIVATE_KEY_PATH=~/.ssh/id_rsa
   SSH_PUBLIC_KEY_PATH=~/.ssh/id_rsa.pub
   ```

3. **Edit `inventory.yml` with your hosts:**
   ```yaml
   all:
     hosts:
       server1:
         ansible_host: 192.168.1.100
   ```

4. **Run Ansible in Docker:**
   ```bash
   docker-compose run ansible
   ```

5. **Execute playbooks with interactive targeting:**

   All playbooks use `hosts: all` - you choose where to run them using `--limit`:

   ```bash
   # Run on a single host
   ansible-playbook playbooks/docker-install.yml --limit k8s-master-1

   # Run on an entire group
   ansible-playbook playbooks/docker-install.yml --limit k8s_cluster

   # Run on multiple hosts
   ansible-playbook playbooks/nginx-install.yml --limit web-prod-1,web-prod-2

   # Run on multiple groups
   ansible-playbook playbooks/user-setup.yml --limit k8s_cluster,web_servers
   ```

   **List available hosts/groups:**
   ```bash
   ansible-inventory --list
   ansible-inventory --graph
   ```

## Features

- **Stateless**: No environment-specific files committed to git
- **Portable**: Works on any machine with Docker
- **No rebuild needed**: Changes to playbooks are immediately available (volume mounted)
- **Auto tree**: File structure is printed and saved to `PROJECT_STRUCTURE.txt` on startup

## Structure

```
├── playbooks/           # Task-focused playbooks (add more as needed)
│   ├── docker-install.yml
│   ├── nginx-install.yml
│   └── user-setup.yml
├── .env                 # Your environment config (gitignored)
├── inventory.yml        # Your hosts with groups (gitignored)
├── ansible.cfg          # Ansible configuration
├── docker-compose.yml   # Docker setup
└── Dockerfile           # Ansible container image
```

## Inventory Organization

Organize hosts into logical groups in `inventory.yml`:

```yaml
all:
  children:
    k8s_cluster:
      hosts:
        k8s-master-1:
          ansible_host: 192.168.1.10
        k8s-worker-1:
          ansible_host: 192.168.1.11

    web_servers:
      hosts:
        web-prod-1:
          ansible_host: 192.168.1.20
```

Then target groups or individual hosts when running playbooks.

## Adding Playbooks

Create focused, task-specific playbooks in `playbooks/`:

```yaml
---
- name: Install something
  hosts: all
  become: yes

  tasks:
    - name: Do the thing
      # ... your tasks
```

No need for roles or complex structure. Keep it simple and direct.

## Nginx Reverse Proxy Workflow

The `playbooks/nginx/` directory contains everything for nginx setups:

```
playbooks/nginx/
├── install.yml              # Install nginx (run once per server)
├── ports.yml                # Port registry - track all your projects
├── templates/
│   └── proxy.conf.j2        # Nginx config template
├── wgetbash.yml             # Example: project-specific setup
└── yourproject.yml          # Create one per project
```

### Setup a new project with SSL:

1. **Add your project to `ports.yml`:**
   ```yaml
   projects:
     myproject:
       domain: myapp.example.com
       port: 8080
       description: My application
   ```

2. **Create a playbook** (copy `wgetbash.yml` as template):
   ```bash
   cp playbooks/nginx/wgetbash.yml playbooks/nginx/myproject.yml
   # Edit: change project_name variable to match your project in ports.yml
   ```

3. **Run the playbook:**
   ```bash
   # First time: install nginx
   ansible-playbook playbooks/nginx/install.yml --limit web-server

   # Setup project with SSL
   ansible-playbook playbooks/nginx/myproject.yml --limit web-server
   ```

This will:
- Create nginx config in `/etc/nginx/conf.d/`
- Obtain SSL certificate with Certbot
- Redirect HTTP → HTTPS
- Set up auto-renewal cron job

**Optional:** Set `CERTBOT_EMAIL` in `.env` for SSL cert notifications.

## Notes

- `.env` and `inventory.yml` are gitignored - safe to store real IPs and settings
- Use `.yml` extension (not `.yaml`)
- The container mounts your local SSH keys for authentication
- All playbooks use the `ANSIBLE_USER` from your `.env`
