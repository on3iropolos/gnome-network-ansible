---
title: "Agent Workflow: Orchestrator Agent Policies"
summary: "Workflow for orchestrator agents to apply the agent policy manifest when creating and managing subtasks."
type: "how-to"
scope: "repo"
tags:
  - "agent"
  - "orchestrator"
  - "workflow"
  - "policy"
related:
  - "../INDEX.md"
  - "../policies/INDEX.md"
  - "../commands/INDEX.md"
  - "../policies/general-instructions.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-26"
canonical_url: "docs/agent/workflows/orchestrator-agent-policies.md"
---

# Agent Workflow: Orchestrator Agent Policies

This workflow describes how the orchestrator agent should use the machine-readable manifest in `docs/agent/policies/agent-policy-manifest.yaml` to attach policy references to every subtask it spawns. It assumes you already follow the general instructions in [`docs/agent/policies/general-instructions.md`](../policies/general-instructions.md:1) and the documentation model in [`docs/agent/policies/always-link.md`](../policies/always-link.md:1).

The orchestrator **does not restate policy content**. Instead, it reads the manifest, selects the relevant entries, and passes their IDs and canonical links into subtask prompts. Each subtask agent is responsible for reading the canonical policy documents when needed.

## 1. Read the agent policy manifest

Before building or updating a task tree, the orchestrator should load the YAML manifest:

- Manifest file: `docs/agent/policies/agent-policy-manifest.yaml`
- Structure: a top-level `terms` array, where each item includes:
  - `id` and `name` (short identifier such as `always_link`, `agent_general_instructions`)
  - `category` (for example `docs`, `workspace`, `logging`, `behavior`)
  - `level` (`must` or `should`)
  - `applies_to` (for this manifest, always includes `all-agents`)
  - `canonical_doc` (relative path to the canonical policy doc under `docs/agent/policies/`)

Treat the manifest as the **single source of truth** for which policies apply to all agents. The orchestrator should not hard-code policy paths or names; it should rely on the manifest instead.

## 2. Classify the parent task

When the orchestrator receives a top-level request, it should classify it into a simple task category. Examples:

- `docs-edit` – editing or adding documentation only
- `code-edit` – changing application, role, or Terraform code
- `infra-edit` – updating infrastructure configuration or Terraform state
- `tests-lint` – adding or fixing tests, lint rules, or CI configuration
- `analysis-only` – reading, auditing, or summarizing without making changes

This classification helps the orchestrator decide which **additional** policies or workflow docs to reference (for example, documentation workflows for `docs-edit`). However, **all** categories must still include the all-agent entries from the manifest.

## 3. Build subtask policy context

For each subtask the orchestrator creates (for example, a code-mode or docs-mode subtask), it should:

1. Include all manifest terms where `applies_to` contains `all-agents`.
2. Optionally filter or highlight entries by `level` (for example, call out `must` policies explicitly).
3. Add any extra, task-specific references (such as role- or environment-specific docs) as separate links, not as new policy definitions.

The orchestrator should pass policy context as **IDs plus links only**, leaving all normative text inside the canonical docs.

## 4. Subtask prompt template (example)

When creating a subtask, the orchestrator can inject a policy section similar to the following. The concrete wording may vary; the important part is that only IDs and links are provided, not restated policy content.

```text
Policy constraints
------------------
You MUST follow all policies in the agent policy manifest that apply to all agents. Relevant entries include (see canonical docs for details):
- always_link → docs/agent/policies/always-link.md
- agent_operational_policies → docs/agent/policies/agent-operational-policies.md
- agent_workspace → docs/agent/policies/agent-workspace.md
- agent_logging → docs/agent/policies/agent-logging.md
- agent_general_instructions → docs/agent/policies/general-instructions.md
- working_directory → docs/agent/policies/working-directory.md

Consult the linked canonical documents for the full policy text. Do not copy those explanations into this task; link to them instead.
```

The orchestrator should derive this list from the manifest’s `terms` array, not from hard-coded constants, so that adding or updating policies only requires editing the manifest and canonical docs.

## 5. Keep workflows and policies separate

This workflow document explains **how** the orchestrator should use the manifest; it is **not** itself a policy definition. The canonical policy content continues to live under:

- [`docs/agent/policies/always-link.md`](../policies/always-link.md:1)
- [`docs/agent/policies/agent-operational-policies.md`](../policies/agent-operational-policies.md:1)
- [`docs/agent/policies/agent-workspace.md`](../policies/agent-workspace.md:1)
- [`docs/agent/policies/agent-logging.md`](../policies/agent-logging.md:1)
- [`docs/agent/policies/general-instructions.md`](../policies/general-instructions.md:1)
- [`docs/agent/policies/working-directory.md`](../policies/working-directory.md:1)

When in doubt, the orchestrator should link back to these canonical docs rather than paraphrasing them in prompts or new workflow files.