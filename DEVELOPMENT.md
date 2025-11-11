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
