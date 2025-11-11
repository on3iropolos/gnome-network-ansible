# Mermaid Diagram Guidelines

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
    H --> CI{Automated CI Checks (ansible-lint, Molecule)};
    CI -- Pass --> J[Review & Merge];
    CI -- Fail --> G;
    B -- No --> I[Update Code/Configuration];
    I --> G;
    H --> K[Log activities in YYYY-MM-DD.md];
    K --> J;
    B -- No --> L[Update Code/Configuration];
    L --> G;
    D -- No --> F;
    J --> M[End];
```
