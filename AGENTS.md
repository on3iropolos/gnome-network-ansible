# Guidelines for AI Agents

This document provides specific instructions and reminders for AI agents working with the Gnome Network Ansible repository. Please adhere to these guidelines to ensure consistency and maintainability.

## General Instructions

1.  **Understand the Goal:** Before making changes, ensure you understand the overall goals of the project as outlined in the main `README.md`.
2.  **Follow `README.md`:** Adhere to all guidelines mentioned in the main `README.md`, including "Contributing Guidelines" and "Best Practices," unless explicitly overridden by user instructions for a specific task.
3.  **Idempotency is Key:** All Ansible roles and tasks you create or modify must be idempotent.
4.  **Clarity in Commits:** When submitting changes, use clear and descriptive commit messages. If your work spans multiple steps of a plan, consider if multiple smaller commits are more appropriate than one large one.

## Agent Working Directory

All agents **MUST** use the `./.agent/` directory for storing transient working files, logs, and summaries. This directory is excluded from version control via `.gitignore`.

### Summaries

Upon completion of a task, each agent **MUST** create a `summary.md` file in the `./.agent/` directory. This file should provide a concise summary of the actions taken, including:

-   A brief description of the task.
-   A list of the files that were created, modified, or deleted.
-   Any important notes or observations.

### Decision Logs

Each agent **MUST** also create a `decision_log.md` file in the `./.agent/` directory. This file should contain a log of the decisions made by the agent during the task, including:

-   The rationale for choosing a particular approach or solution.
-   Any alternative approaches that were considered and why they were not chosen.
-   Any assumptions that were made.

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

1.  **`ansible-lint` (Automated CI Check):**
    *   This repository uses `ansible-lint` for static code analysis.
    *   A GitHub Actions workflow (`.github/workflows/ansible-lint.yml`) automatically runs `ansible-lint .` on all pull requests targeting the `main` branch.
    *   **Your changes MUST pass these automated linting checks.** If the CI check fails, you need to address the reported issues and push the corrections.
    *   The `ansible-ctrl.dockerfile` includes `ansible-lint`, which you can use for local testing.
    *   It is **STRONGLY RECOMMENDED** that you run `ansible-lint .` locally from the repository root (ideally within the Docker container environment or a compatible local setup) before submitting changes. This helps catch issues early.
    *   Address any critical errors or warnings reported by `ansible-lint` that are relevant to your changes. If unsure about a specific linting error in the context of your task, ask the user.
    *   *Note: Specific linting rules and configurations for `ansible-lint` may be added in the future (e.g., via an `.ansible-lint` file).*
2.  **Manual Testing:**
    *   Automated linting is in place. However, full playbook execution or integration testing is not yet automated.
    *   Always consider the impact of your changes and how they might be manually tested. If you have suggestions for manual testing steps for your changes, please include them in your commit message or PR description.

## Interaction

*   If any instruction in this `AGENTS.md` or the main `README.md` conflicts with a direct instruction from the user for a specific task, the user's direct instruction takes precedence.
*   If you are unsure about any aspect of your task or how these guidelines apply, please ask for clarification using `request_user_input`.

## Mermaid Diagram Guidelines

This repository uses Mermaid diagrams to visually represent workflows, architectures, and processes in Markdown documentation.

- **Purpose**: To enhance understanding and clarity of documented systems and procedures.
- **Creation**:
    - Use the ````mermaid ... ```` code block syntax in Markdown files.
    - Choose appropriate diagram types (flowchart, sequence, etc.) that best represent the information.
    - Keep diagrams concise and focused on the specific aspect being documented.
- **Maintenance**:
    - When documentation is updated, review relevant diagrams to ensure they remain accurate.
    - If you modify a process or structure that is diagrammed, **you MUST update the Mermaid diagram accordingly**.
- **Style**:
    - Aim for readability. Use clear and concise labels for nodes and edges.
    - While Mermaid offers styling options, prioritize clarity over complex styling unless it significantly aids understanding.

The general workflow for contributing, including updating diagrams, is as follows:

```mermaid
graph TD
    A[Start: Identify Need for Change/Feature] --> B{Is Documentation Affected?};
    B -- Yes --> C[Update Code/Configuration];
    C --> D{Is a Diagram Present/Needed?};
    D -- Yes --> E[Create/Update Mermaid Diagram];
    E --> F[Update Textual Documentation];
    F --> G[Commit Changes];
    G --> H[Submit Pull Request];
    H --> I[Create summary.md and decision_log.md];
    I --> J[Submit for review];
    J --> CI{Automated CI Checks (e.g., ansible-lint)};
    CI -- Pass --> K[Review & Merge];
    CI -- Fail --> J; // Developer addresses feedback & commits fixes
    B -- No --> L[Update Code/Configuration];
    L --> G;
    D -- No --> F;
    K --> M[End];
```

Thank you for your assistance in maintaining and improving this project!
