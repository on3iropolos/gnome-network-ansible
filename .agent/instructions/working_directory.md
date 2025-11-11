# Agent Working Directory and Logging

## Working Directory

All agents **MUST** use the `./.agent/` directory for storing transient working files and instructions. While the instruction files are tracked by Git, other files you create here may not be. Refer to the `.gitignore` file for details.

## Logging

To maintain a clear and persistent record of activities, all agents **MUST** log their actions in a structured and concise manner.

### Log File Naming and Location

-   Logs **MUST** be stored in the `./.agent/log/` directory.
-   Log files **MUST** be named using the date of the activity in `YYYY-MM-DD.md` format (e.g., `2023-10-28.md`).
-   A single log file should contain all entries for a given day.

### Log Content Guidelines

-   **Be Brief and Concise:** Log only critical information. Avoid verbose descriptions. The goal is to create a high-signal log that is easy to review.
-   **Categorize Entries:** Every log entry **MUST** be categorized to provide context.
-   **Timestamp Entries:** Every log entry **MUST** be timestamped using the `HH:MM:SS` format.

### Log Entry Format

Use the following format for all log entries:

`[TIMESTAMP] [CATEGORY] - Message`

**Example Categories:**
-   `[Decision]` - The rationale for a specific technical choice.
-   `[Action Summary]` - A summary of a completed action or plan step.
-   `[Finding]` - An observation or discovery made while exploring the codebase.
-   `[Learning]` - A lesson learned that could be useful for future tasks.

**Example Log Entries:**

```
[14:35:10] [Decision] - Refactoring AGENTS.md into smaller, linked files is the best approach for long-term maintainability, as requested by the user.
[14:40:05] [Action Summary] - Created new directory structure: .agent/instructions/ and .agent/log/.
[14:55:23] [Finding] - The ansible-lint command is not available in the default environment and must be run via the 'ansible-dev' docker-compose service.
[15:01:00] [Learning] - When encountering a permission error with the Docker socket, it's important to notify the user before proceeding, even if the changes seem low-risk.
```
