# Documentation

1.  **Role `README.md`:**
    *   When creating a new Ansible role, you **MUST** create a `README.md` file within the role's directory.
    *   This role `README.md` should be based on the template found in `roles/role.template/README.md`.
    *   Fill in all relevant sections of the template, including Role Name, Description, Role Variables (with defaults), Dependencies, and an Example Playbook.
2.  **Updating Repository Structure:**
    *   If you add a new role, a new top-level directory, or make other significant changes to the repository's structure, you **MUST** update the "Repository Structure" section in the main `README.md` file to reflect these changes.
3.  **Clarity in Code:**
    *   Use descriptive names for tasks in Ansible plays.
    *   Add comments within playbooks or task files if the logic is complex or not immediately obvious.
