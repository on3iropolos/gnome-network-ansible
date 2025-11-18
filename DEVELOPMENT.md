# Development Environment Setup for Ansible

This document outlines the development and testing environment for Ansible development. The repository uses Molecule + Docker for fast local testing and CI/CD.

## Testing with Molecule + Docker

Molecule with Docker provides a fast, lightweight testing environment ideal for development and CI/CD pipelines. It uses Docker containers with systemd to simulate target systems.

### Prerequisites

1. **Install Docker**:
   - Linux: Follow your distribution's Docker installation guide
   - macOS: Install Docker Desktop from [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
   - Windows: Install Docker Desktop with WSL2 backend

2. **Install Python Dependencies**:
   ```bash
   python -m pip install --upgrade pip
   pip install -r requirements.txt
   ```

   This installs:
   - Ansible
   - Molecule
   - molecule-plugins[docker]
   - ansible-lint
   - Docker Python SDK

### Local Development Environment using Docker

This project includes a Dockerized environment to provide a consistent and isolated space for Ansible development and execution. It simplifies setup and ensures all contributors use the same versions of Ansible and related tools.

#### Setup and Usage

1.  **Build the Docker Image:**
    Open your terminal in the root of this project and run:
    ```bash
    sudo docker compose build
    ```
    This command builds the Docker image based on the `Dockerfile`. You only need to run this initially or when the `Dockerfile` changes. Adding `--no-cache` is recommended if you suspect caching issues or want a fresh build.

2.  **Start the Development Container:**
    To start the container in the background (detached mode):
    ```bash
    sudo docker compose up -d
    ```
    Your project directory is mounted into `/data` inside the container.

3.  **Accessing the Container Shell:**
    To get an interactive shell (bash by default) inside the running container:
    ```bash
    sudo docker compose exec ansible-dev bash
    ```
    You can also use `fish` if you prefer:
    ```bash
    sudo docker compose exec ansible-dev fish
    ```

4.  **Running Ansible Commands:**
    Once inside the container's shell, you can run Ansible commands as usual. The working directory will be `/data`, which is your project root.
    ```bash
    # Example: Lint a playbook
    ansible-lint deploy.yml

    # Example: Run a playbook (ensure your inventory is set up and SSH_PASSWORD etc. are exported if needed)
    # export SSH_PASSWORD="your_ssh_password"
    ansible-playbook -i inventories/workstations/hosts.yml deploy.yml
    ```
    Alternatively, you can run commands directly without entering the shell:
    ```bash
    sudo docker compose exec ansible-dev ansible-lint deploy.yml
    sudo docker compose exec ansible-dev ansible-playbook -i inventories/workstations/hosts.yml deploy.yml
    ```

5.  **Volume Mounts:**
    The `docker-compose.yml` file configures the following important volume mounts:
    *   `.:/data`: Your entire project directory is mapped to `/data` in the container. Changes made locally are reflected inside the container, and vice-versa.
    *   `~/.ssh:/root/.ssh:ro`: Your local SSH keys (from `~/.ssh`) are mounted read-only into the container. This allows Ansible running inside the container to connect to your managed nodes.
    *   `~/.gitconfig:/root/.gitconfig:ro`: Your local Git configuration is mounted read-only.

6.  **Internet Connectivity Check:**
    Playbooks that include roles known to require internet access (like `arch-iso-install` or `network` for package installation) have a pre-flight check. This check attempts to connect to `google.com`. If it fails, the playbook will halt before running internet-dependent tasks. This is to ensure a better experience when working offline or with intermittent connectivity.

7.  **Stopping the Container:**
    When you're done, you can stop the container:
    ```bash
    sudo docker compose down
    ```
    If you just want to stop it without removing it (so it starts faster next time):
    ```bash
    sudo docker compose stop
    ```

#### Offline Usage
Once the Docker image is built (`docker compose build`), the Ansible tools (Ansible, Ansible Lint, Git, etc.) are installed within the image. This means you can use these tools inside the container to work on your playbooks (e.g., editing, linting, running playbooks against locally accessible hosts or VMs) without an active internet connection.

However, any Ansible tasks that inherently require internet access (e.g., downloading packages with `apt`/`yum`/`pacman`, cloning git repositories from the internet, using `uri` to fetch remote files) will naturally fail if the container cannot access the internet. The pre-flight internet check mentioned above aims to catch this early for known roles.

### Running Molecule Tests

Molecule tests are configured per role. The network role includes a complete test scenario.

#### Test the Network Role

```bash
# Navigate to the role directory
cd roles/network

# Run the full test sequence
molecule test

# Or run individual steps:
molecule create      # Create the test container
molecule converge    # Apply the role
molecule verify      # Run verification tests
molecule destroy     # Clean up
```

#### Test Sequence

The default test sequence includes:
1. **Dependency**: Install role dependencies
2. **Cleanup**: Remove any existing test containers
3. **Destroy**: Ensure clean state
4. **Syntax**: Check playbook syntax
5. **Create**: Launch Arch Linux container with systemd
6. **Prepare**: Install Python and update packages
7. **Converge**: Apply the role to the container
8. **Idempotence**: Verify role is idempotent (no changes on second run)
9. **Verify**: Run verification tests to ensure role worked correctly
10. **Cleanup & Destroy**: Remove test container

### Molecule Container Architecture

The test container is based on `archlinux:latest` with:
- systemd as init system (for service management)
- Python 3 for Ansible
- Privileged mode with cgroup access
- Network tools and packages

### Troubleshooting Molecule

- **Docker permission errors**: Add your user to the docker group:
  ```bash
  sudo usermod -aG docker $USER
  # Log out and back in for changes to take effect
  ```

- **Container fails to start**: Ensure Docker service is running:
  ```bash
  sudo systemctl start docker
  # On macOS/Windows, ensure Docker Desktop is running
  ```

- **Tests fail in CI/CD**: Check GitHub Actions logs in the repository's Actions tab

## Testing with Terraform + libvirt

For roles that require full system access (like `arch_iso_install`), Terraform with libvirt provides VM-based testing with graphical access on Ubuntu systems.

### Why Terraform for VM Testing?

Container-based testing (Molecule + Docker) works well for most roles, but some operations require actual hardware or full virtualization:
- Disk partitioning and filesystem creation
- Bootloader installation (GRUB)
- Full system installation workflows
- Hardware-specific configurations

### Setup and Usage

For detailed setup, usage, and troubleshooting, see [terraform/README.md](terraform/README.md).

This includes:
- Automated setup script for Ubuntu
- Creating and destroying test VMs
- Accessing VMs graphically
- Available test scenarios

## CI/CD Integration

This repository includes automated testing via GitHub Actions:

- **ansible-lint**: Runs static code analysis on all pull requests
- **molecule-test**: Runs Molecule tests for roles on pull requests

All tests must pass before changes can be merged.

## Best Practices

1. **Write tests first**: Create or update Molecule tests when developing roles
2. **Test locally**: Run `molecule test` before pushing changes
3. **Keep tests idempotent**: Ensure roles can be run multiple times without errors
4. **Use verify playbooks**: Add verification tasks to ensure role functionality
5. **Document test scenarios**: Update role `README.md` with testing instructions
