# Conventional Commits Specification

## Summary

The Conventional Commits specification is a lightweight convention on top of commit messages. It provides an easy set of rules for creating an explicit commit history, which makes it easier to write automated tools on top of.

**Version**: 1.0.0

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119.

1. Commits MUST be prefixed with a type, which consists of a noun, `feat`, `fix`, etc., followed by the OPTIONAL scope, OPTIONAL `!`, and REQUIRED terminal colon and space.

2. The type `feat` MUST be used when a commit adds a new feature to your application or library.

3. The type `fix` MUST be used when a commit represents a bug fix for your application.

4. A scope MAY be provided after a type. A scope MUST consist of a noun describing a section of the codebase surrounded by parenthesis, e.g., `fix(parser):`.

5. A description MUST immediately follow the colon and space after the type/scope prefix. The description is a short summary of the code changes, e.g., `fix: array parsing issue when multiple spaces were contained in string`.

6. A longer commit body MAY be provided after the short description, providing additional contextual information about the code changes. The body MUST begin one blank line after the description.

7. A commit body is free-form and MAY consist of any number of newline separated paragraphs.

8. One or more footers MAY be provided one blank line after the body. Each footer MUST consist of a word token, followed by either a `:<space>` or `<space>#` separator, followed by a string value (this is inspired by the git trailer convention).

9. A footer's token MUST use `-` in place of whitespace characters, e.g., `Acked-by` (this helps differentiate the footer section from a multi-paragraph body). An exception is made for `BREAKING CHANGE`, which MAY also be used as a token.

10. A footer's value MAY contain spaces and newlines, and parsing MUST terminate when the next valid footer token/separator pair is observed.

11. Breaking changes MUST be indicated in the type/scope prefix of a commit, or as an entry in the footer.

12. If included as a footer, a breaking change MUST consist of the uppercase text BREAKING CHANGE, followed by a colon, space, and description, e.g., `BREAKING CHANGE: environment variables now take precedence over config files`.

13. If included in the type/scope prefix, breaking changes MUST be indicated by a `!` immediately before the `:`. If `!` is used, `BREAKING CHANGE:` MAY be omitted from the footer section, and the commit description SHALL be used to describe the breaking change.

14. Types other than `feat` and `fix` MAY be used in your commit messages, e.g., `docs: update ref docs`.

15. The units of information that make up Conventional Commits MUST NOT be treated as case sensitive by implementors, with the exception of BREAKING CHANGE which MUST be uppercase.

16. BREAKING-CHANGE MUST be synonymous with BREAKING CHANGE, when used as a token in a footer.

## Why Use Conventional Commits

- Automatically generating CHANGELOGs
- Automatically determining a semantic version bump (based on the types of commits landed)
- Communicating the nature of changes to teammates, the public, and other stakeholders
- Triggering build and publish processes
- Making it easier for people to contribute to your projects, by allowing them to explore a more structured commit history

## Commit Types

### Primary Types

- **feat**: A new feature for the user
- **fix**: A bug fix for the user

### Additional Types

The following types are commonly used but not required by the specification:

- **build**: Changes that affect the build system or external dependencies
- **chore**: Changes to the build process or auxiliary tools
- **ci**: Changes to CI configuration files and scripts
- **docs**: Documentation only changes
- **perf**: A code change that improves performance
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **revert**: Reverts a previous commit
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, etc)
- **test**: Adding missing tests or correcting existing tests

## Examples

### Commit message with description and breaking change footer

```
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` key in config file is now used for extending other config files
```

### Commit message with `!` to draw attention to breaking change

```
feat!: send an email to the customer when a product is shipped
```

### Commit message with scope and `!` to draw attention to breaking change

```
feat(api)!: send an email to the customer when a product is shipped
```

### Commit message with both `!` and BREAKING CHANGE footer

```
chore!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.
```

### Commit message with no body

```
docs: correct spelling of CHANGELOG
```

### Commit message with scope

```
feat(lang): add Polish language
```

### Commit message with multi-paragraph body and multiple footers

```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123
```

## Scope

A scope is an optional part of the commit message that provides additional contextual information. It should be a noun describing a section of the codebase.

### Common Scopes by Project Type

**Web Application**:
- `api`: Backend API changes
- `ui`: User interface changes
- `auth`: Authentication/authorization
- `db`: Database changes
- `config`: Configuration changes

**Library/Package**:
- `core`: Core functionality
- `utils`: Utility functions
- `types`: Type definitions
- `deps`: Dependencies

**Microservices**:
- `user-service`: User service changes
- `payment-service`: Payment service changes
- `gateway`: API gateway changes

## Breaking Changes

Breaking changes MUST be indicated by:

1. Adding `!` after the type/scope: `feat(api)!: remove deprecated endpoint`
2. Adding `BREAKING CHANGE:` footer with description

### When to Mark as Breaking Change

- Removing or renaming public APIs
- Changing function signatures
- Removing configuration options
- Changing default behavior
- Requiring new dependencies
- Changing data formats
- Removing features

## Best Practices

1. **Be Atomic**: Each commit should represent a single logical change
2. **Be Descriptive**: Write clear, concise descriptions
3. **Use Imperative Mood**: "add feature" not "added feature"
4. **Limit Subject Line**: Keep under 72 characters
5. **Separate Subject from Body**: Use blank line
6. **Wrap Body**: Wrap at 72 characters
7. **Explain Why**: Body should explain why, not what
8. **Reference Issues**: Use footers to reference issues/tickets

## Tools and Automation

### Commitizen

Interactive CLI for creating conventional commits:

```bash
npm install -g commitizen
commitizen init cz-conventional-changelog --save-dev --save-exact
```

### Commitlint

Lint commit messages:

```bash
npm install --save-dev @commitlint/cli @commitlint/config-conventional
```

### Standard Version

Automate versioning and CHANGELOG generation:

```bash
npm install --save-dev standard-version
```

### Semantic Release

Fully automated version management and package publishing:

```bash
npm install --save-dev semantic-release
```

## FAQ

### Should I use conventional commits for all commits?

Yes, especially for public projects. For private projects, teams should agree on adoption.

### What if a commit fits multiple types?

Choose the most significant type. If truly multiple changes, consider splitting into multiple commits.

### How do I handle reverts?

Use `revert:` type and reference the reverted commit:

```
revert: feat(api): add new endpoint

This reverts commit 1234567.
```

### Can I use custom types?

Yes, but document them for your team. Common custom types include `wip`, `hotfix`, `release`.

### How do I handle merge commits?

Merge commits typically don't follow conventional format. Use squash merging to maintain conventional history.

## References

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)
