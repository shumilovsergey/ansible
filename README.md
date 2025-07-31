# ANSIBLE

# TREE
Every time you run an Ansible command inside the container the folder structure of your project is automatically rendered to a PROJECT_STRUCTURE.txt 

# Docker
for izi env

```bash
docker-compose run ansible
```
```bash
ansible-playbook playbooks/common/users.yml
```

# vault
```bash
ansible-vault create vault/vault.yml
ansible-vault edit vault/vault.yml
ansible-vault decrypt vault/vault.yml
ansible-vault encrypt vault/vault.yml
```

# заметки

- yml а не yaml

- path/to/file а не /path/to/file


