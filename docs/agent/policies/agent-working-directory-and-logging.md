---
title: "Agent Working Directory and Logging"
summary: "Defines how AI agents must use the .agent/ working directory and how to structure logging for automated activity in this repository."
type: "policy"
scope: "repo"
tags:
  - "agent"
  - "logging"
  - "documentation"
related:
  - "../../policies/working-directory.md"
  - "../../policies/logging.md"
  - "../../policies/log-file-naming-and-location.md"
  - "../../policies/log-content-guidelines.md"
  - "../../policies/log-entry-format.md"
owner: "Gnome Network Ansible maintainers"
last_reviewed: "2025-11-19"
canonical_url: "docs/agent/policies/agent-working-directory-and-logging.md"
---

> Source: This policy was originally migrated from [`docs/policies/agent-working-directory-and-logging.md`](../../policies/agent-working-directory-and-logging.md:1). It is now a high-level entrypoint that delegates to the focused workspace and logging policies under `docs/agent/policies/`.

# Agent Working Directory and Logging

This document provides a short overview and links to the two focused policies that agents must follow:

- Workspace usage: [`agent-workspace.md`](agent-workspace.md:1)
- Logging requirements: [`agent-logging.md`](agent-logging.md:1)

In day-to-day work:

- Use **`agent-workspace.md`** to understand how `.agent/` and `.agent/tmp/` are used for transient artifacts and tooling.
- Use **`agent-logging.md`** to understand when and how to write logs under `.agent/log/`.

For repository-wide policies that underpin these agent-focused docs, continue to use:

- Working directory policy: [`../../policies/working-directory.md`](../../policies/working-directory.md:1)
- Logging file layout: [`../../policies/log-file-naming-and-location.md`](../../policies/log-file-naming-and-location.md:1)
- Logging content rules: [`../../policies/log-content-guidelines.md`](../../policies/log-content-guidelines.md:1)
- Log entry format: [`../../policies/log-entry-format.md`](../../policies/log-entry-format.md:1)

Agents should treat this file as an index and rely on the linked policies for the authoritative, detailed requirements.