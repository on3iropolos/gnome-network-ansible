# Guidelines for AI Agents

This document provides specific instructions and reminders for AI agents working with the Gnome Network Ansible repository. Please adhere to these guidelines to ensure consistency and maintainability.

## General Instructions

1.  **Understand the Goal:** Before making changes, ensure you understand the overall goals of the project as outlined in the main `README.md`.
2.  **Follow `README.md`:** Adhere to all guidelines mentioned in the main `README.md`, including "Contributing Guidelines" and "Best Practices," unless explicitly overridden by user instructions for a specific task.
3.  **Idempotency is Key:** All Ansible roles and tasks you create or modify must be idempotent.
4.  **Clarity in Commits:** When submitting changes, use clear and descriptive commit messages. If your work spans multiple steps of a plan, consider if multiple smaller commits are more appropriate than one large one.

## Documentation

1.  **Role `README.md`:**
    *   When creating a new Ansible role, you **MUST** create a `README.md` file within the role's directory.
    *   This role `README.md` should be based on the template found in `roles/role.template/README.md`.
    *   Fill in all relevant sections of the template, including Role Name, Description, Role Variables (with defaults), Dependencies, and an Example Playbook.
2.  **Updating Repository Structure:**
    *   If you add a new role, a new top-level directory, or make other significant changes to the repository's structure, you **MUST** update the "Repository Structure" section in the main `README.md` file to reflect these changes.
3.  **Clarity in Code:**
    *   Use descriptive names for tasks in Ansible plays.
    *   Add comments within playbooks or task files if the logic is complex or not immediately obvious.

## Testing and Linting

1.  **`ansible-lint`:**
    *   The `ansible-ctrl.dockerfile` includes `ansible-lint`.
    *   Before submitting changes to Ansible playbooks, roles, or related YAML files, you **SHOULD** make a best effort to run `ansible-lint .` from the repository root within the Docker container environment (or a compatible local environment).
    *   Address any critical errors or warnings reported by `ansible-lint` that are relevant to your changes. If unsure, ask the user.
    *   *Note: Specific linting rules and configurations for `ansible-lint` may be added in the future (e.g., via an `.ansible-lint` file).*
2.  **Manual Testing:**
    *   While automated testing infrastructure is not yet in place, consider the impact of your changes and how they might be manually tested. If you have suggestions for manual testing steps for your changes, please include them in your commit message or PR description.

## Interaction

*   If any instruction in this `AGENTS.md` or the main `README.md` conflicts with a direct instruction from the user for a specific task, the user's direct instruction takes precedence.
*   If you are unsure about any aspect of your task or how these guidelines apply, please ask for clarification using `request_user_input`.

Thank you for your assistance in maintaining and improving this project!
