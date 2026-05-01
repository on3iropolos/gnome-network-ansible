---
name: session-learning
description: End-of-session analytical reflection and knowledge extraction to Hindsight memory. Use when a session ends, before context switches, or to capture session insights autonomously.
compatibility: Requires Hindsight plugin (hindsight_retain, hindsight_recall, hindsight_reflect tools)
metadata:
  author: on3iropolos
  version: "1.0"
---

# Session Learning

## When to use this skill

Load this skill when:
- A coding session is ending and insights should be captured
- Preparing for a context switch to another task
- Summarizing lessons learned from a completed feature or fix
- Capturing negative knowledge (dead ends, anti-patterns) before they're forgotten
- Periodically during long sessions to retain incremental insights

## Reflection Prompts

Answer each question by reviewing the conversation history autonomously (no interactive prompting):

1. **What lessons have I learned?**
   - Identify new understanding about the codebase, tools, or workflows gained during this session

2. **What would I do differently if I started over?**
   - Reflect on approach changes that would yield better results next time

3. **What could be optimized in the future?**
   - Note process improvements, tooling gaps, or workflow enhancements for future sessions

4. **Where did my human override me?**
   - Capture user corrections, rejected suggestions, or directive changes — these reveal user preferences and mental models

5. **What negative knowledge should be captured?**
   - Document dead ends, approaches that didn't work, misleading documentation, or anti-patterns to avoid

6. **What would be beneficial to add to hindsight agent memory?**
   - Synthesize insights that would help future sessions: codebase conventions, user preferences, project-specific patterns

## Knowledge Bit Format

Each insight is stored as a natural language `hindsight_retain` call with a `context` parameter.

**Format:**
```
hindsight_retain(
  content: "Natural language sentence describing the insight",
  context: "<context-type>"
)
```

**Context types** (follow Hindsight best practices):
| Context | When to use |
|---------|-------------|
| `lesson learned` | New understanding or insight gained |
| `process improvement` | Workflow or process enhancement identified |
| `optimization opportunity` | Future efficiency gains possible |
| `user preference` | User corrections, overrides, stated preferences |
| `negative knowledge` | Dead ends, anti-patterns, what doesn't work |
| `domain knowledge` | Project-specific facts, conventions, patterns |

**Rules:**
- One insight per `hindsight_retain` call — focused content yields better extraction
- Use natural language sentences, not templated/structured data
- Hindsight auto-extracts facts, entities, and relationships from natural language content

## Reflection Workflow

1. **Review conversation history** — Scan the full session transcript silently
2. **Answer each reflection prompt** — Derive answers autonomously from the conversation
3. **Draft knowledge bits** — Convert each insight into a natural language sentence
4. **Call `hindsight_retain` for each insight** — One call per insight with appropriate `context`
5. **Optional: Call `hindsight_reflect`** — If a synthesized summary would help future sessions, store a reflective summary with context `lesson learned`

## Best Practices

1. **Be specific** — "The `session-learning` skill uses `hindsight_retain` with context `user preference`" is better than "User has preferences"
2. **Capture negative knowledge explicitly** — Dead ends are as valuable as successes; future sessions should avoid repeating mistakes
3. **One insight per call** — Focused content allows Hindsight to extract precise facts and relationships
4. **Use natural language** — Write as if explaining to a colleague; Hindsight handles extraction
5. **Capture user overrides** — When the human corrects or overrides you, that's high-value signal about their preferences
6. **Reflect on process, not just code** — Tool choices, workflow efficiency, and communication patterns are worth capturing

## Common Mistakes to Avoid

- ❌ Batching multiple insights into one `hindsight_retain` call — reduces extraction quality
- ❌ Using templated formats like `{"type": "lesson", "content": "..."}` — Hindsight expects natural language
- ❌ Skipping negative knowledge — dead ends prevent future wasted effort
- ❌ Vague content: "Learned something about Ansible" — be specific about what was learned
- ❌ Forgetting to set `context` parameter — context helps Hindsight categorize and retrieve appropriately
- ❌ Interactive prompting — this skill is analytical; derive answers from conversation history autonomously
