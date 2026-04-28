---
title: Mermaid diagram guidelines
summary: Guidelines for when and how to use Mermaid diagrams in this repository, including style, maintenance, and example workflow.
type: how-to
scope: repo
tags:
  - mermaid
  - diagrams
  - documentation
  - architecture
related:
  - always-link.md
  - ../contributing.md
owner: docs-maintainers
last_reviewed: 2025-11-19
canonical_url: docs/architecture/mermaid-diagram-guidelines.md
source: .agent/instructions/mermaid_diagram_guidelines.md
---

# Mermaid diagram guidelines

This repository uses Mermaid diagrams to visually represent workflows, architectures, and processes in Markdown documentation. This guide explains when and how to use Mermaid so diagrams stay consistent, readable, and easy to maintain.

## Purpose

Mermaid diagrams exist to enhance understanding and clarity of documented systems and procedures. Use them when a sequence of steps, branching flow, or component relationship would be harder to understand as plain text.

## Creation

- Use the fenced code block syntax with the `mermaid` language:

  ````
  ```mermaid
  graph TD
    A[Example] --> B[Next step]
  ```
  ````
- Choose diagram types that best represent the information (for example, flowchart, sequence diagram, class diagram).
- Keep each diagram concise and focused on a single concept or workflow. Prefer multiple small diagrams over one oversized, hard-to-read diagram.

## Maintenance

- When documentation is updated, review any related diagrams to ensure they remain accurate.
- If you modify a process or structure that is diagrammed, you MUST update the Mermaid diagram in the same change set.
- If a diagram becomes outdated and no longer adds value, either fix it or remove it and update the surrounding text accordingly.

## Style

- Prioritize readability over visual complexity.
- Use clear and concise labels for nodes and edges.
- Avoid heavy styling unless it significantly improves understanding; default Mermaid styles are usually sufficient.

## Example contribution workflow

The following diagram shows a typical contribution workflow, including when to update documentation and diagrams:

```mermaid
graph TD
    A[Start: Identify Need for Change/Feature] --> B{Is Documentation Affected?};
    B -- Yes --> C[Update Code/Configuration];
    C --> D{Is a Diagram Present/Needed?};
    D -- Yes --> E[Create/Update Mermaid Diagram];
    E --> F[Update Textual Documentation];
    F --> G[Commit Changes];
    G --> H[Submit Pull Request];
    H --> CI[Automated CI Checks (ansible-lint, Molecule)];
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

## Source

This document was derived from historical guidance in `.agent/instructions/mermaid_diagram_guidelines.md`.