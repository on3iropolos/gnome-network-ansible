# About

This is the Gnome Network Ansible project in order to manage and deploy systems within Gnome Network infrastructure.

# Installation

## Pre-requisites

In order to deploy the Ansible controller container, you need to install [Docker](https://www.docker.com/).

### Linux networking

For your containers to make egress from the docker network, you need `net.ipv4.ip_forward = 1`

You can check the current status by running:
```
$ sysctl net.ipv4.ip_forward
```

If the return is `0`, edit `/etc/sysctl.conf`, and add this line:
```
net.ipv4.ip_forward=1
```

Then, load the changes by running:
```
$ sudo sysctl -p
```

Ensure Docker's bridge IP (`bip`) does not overlap with subnets of the host's other network interfaces. You can define the subnet docker uses by creating or editing `/etc/docker/daemon.json` and adding a `bip` entry like:
```
}
  "bip": "10.240.0.1/24"
}
```


## Installation

1. Run the appropriate script based on your operating system.

    - Mac/Lin: `bash install.sh`
    - Win: `powershell .\install.ps1`

2. Connect to your docker: `docker exec -it $(docker ps -f name=ansible-ctrl -q) fish`
3. Run the init ansible playbook: `ansible-playbook deploy.yml --ask-vault-pass` and enter the vault password to decrypt certficates.
4. To add the environment ssh key to your session: `eval (ssh-agent -c)` then `ssh-add /root/.ssh/key_name` (use tab-tab to list all), etc.

Notes:
- The contents of your `~/.aws` directory will be mounted within the container as `/root/.aws`.
- Variables contained within the `ansible-ctrl.dockerfile` may need to be updated for your specific Mac M1 architecture.