# Testing and Linting

1.  **`ansible-lint` (Automated CI Check):**
    *   This repository uses `ansible-lint` for static code analysis.
    *   A GitHub Actions workflow (`.github/workflows/ansible-lint.yml`) automatically runs `ansible-lint .` on all pull requests targeting the `main` branch.
    *   **Your changes MUST pass these automated linting checks.** If the CI check fails, you need to address the reported issues and push the corrections.
    *   The [`Dockerfile`](Dockerfile) includes `ansible-lint`, which you can use for local testing.
    *   It is **STRONGLY RECOMMENDED** that you run `ansible-lint .` locally from the repository root (ideally within the Docker container environment or a compatible local setup) before submitting changes. This helps catch issues early.
    *   Address any critical errors or warnings reported by `ansible-lint` that are relevant to your changes. If unsure about a specific linting error in the context of your task, ask the user.
    *   *Note: Specific linting rules and configurations for `ansible-lint` may be added in the future (e.g., via an `.ansible-lint` file).*

2.  **Molecule Testing (Automated CI Check):**
    *   This repository uses Molecule with Docker for automated role testing.
    *   A GitHub Actions workflow (`.github/workflows/molecule-test.yml`) automatically runs Molecule tests for roles on pull requests.
    *   **When creating or modifying roles, you SHOULD add or update Molecule tests** to verify the role's functionality.
    *   **Running Molecule tests locally before submitting changes is STRONGLY RECOMMENDED.**
    *   Molecule test structure for a role:
        *   `roles/<role-name>/molecule/default/` - Default test scenario directory
        *   `molecule.yml` - Molecule configuration (platform, driver, provisioner settings)
        *   `Dockerfile.j2` - Jinja2 template for building the test container
        *   `prepare.yml` - Playbook to prepare the test environment (e.g., install Python)
        *   `converge.yml` - Playbook that applies the role being tested
        *   `verify.yml` - Playbook to verify the role worked correctly
    *   To run Molecule tests for a role:
        ```bash
        cd roles/<role-name>
        molecule test          # Run full test sequence
        molecule converge      # Apply role to test container
        molecule verify        # Run verification tests
        molecule destroy       # Clean up test containers
        ```
    *   Molecule tests should verify:
        *   Package installation
        *   Service states (started/stopped, enabled/disabled)
        *   File creation and content
        *   Configuration correctness
        *   **Idempotency** - The role can be run multiple times without changes
    *   See [`DEVELOPMENT.md`](DEVELOPMENT.md) for detailed Molecule usage instructions.

3.  **Manual Testing:**
    *   Beyond automated testing, always consider the impact of your changes and how they might be manually tested.
    *   Use Docker containers or physical/virtual systems that mirror your target environment for comprehensive testing.
    *   If you have suggestions for manual testing steps for your changes, please include them in your commit message or PR description.
