# Development Conventions

## Overview

This document outlines the development conventions for our project, including Git workflows, commit message formatting, issue management, and labeling standards. All contributors should follow these conventions to maintain consistency and improve project organization.

## Git Conventions

### Commit Messages
- Use concise, descriptive commit messages (50 characters or less for the subject line)
- Write commit messages in the imperative mood (e.g., "Add feature" not "Added feature")
- Use Gitmoji prefixes for visual context (see Gitmoji section below)

### Issue References
- **ALWAYS reference issue numbers** when closing issues (e.g., "Closes #32", "Fixes #15")
- Include issue references in commit messages when working on specific issues
- Use keywords like "Closes", "Fixes", "Resolves" to automatically close issues

### Attribution Guidelines
- DO NOT include "🤖 Generated with [Claude Code](https://claude.ai/code)" or "Co-Authored-By" messages in commit messages
- DO NOT add Claude <noreply@anthropic.com>" as a co-author in commit messages
- Attribute significant contributions through PR descriptions and release notes

## Gitmoji Style

Use Gitmoji prefixes for all commits, issues, and pull requests to provide visual context and improve project navigation.

### Development Lifecycle
- 🎉 `:tada:` - Initial commit
- ✨ `:sparkles:` - New features
- 🐛 `:bug:` - Bug fixes
- ✅ `:white_check_mark:` - Adding/updating tests
- 📝 `:memo:` - Documentation

### Code Quality & Maintenance
- ♻️ `:recycle:` - Refactoring code
- ⚡ `:zap:` - Performance improvements
- 🚨 `:rotating_light:` - Fixing linter warnings
- 🏗️ `:building_construction:` - Architecture changes
- 🔧 `:wrench:` - Configuration changes

### Accessibility & Internationalization
- ♿ `:wheelchair:` - Accessibility improvements
- 🌐 `:globe_with_meridians:` - Internationalization/localization

### Dependencies & CI/CD
- ⬆️ `:arrow_up:` - Upgrading dependencies
- ⬇️ `:arrow_down:` - Downgrading dependencies
- 💚 `:green_heart:` - Fixing CI build
- 👷 `:construction_worker:` - Adding/updating CI build system

### Examples
- Commit: `✨ Add circular slab calculator (Closes #15)`
- Issue: `🐛 Fix imperial conversion accuracy in beam calculations`
- PR: `♻️ Refactor calculation models with base class pattern`

## GitHub Issues and Labels

### Priority Labels
Apply priority labels to help with issue triage and sprint planning:

- `priority: critical` - Blocking issues, security vulnerabilities, production bugs
- `priority: high` - Important features, significant bugs affecting user experience
- `priority: medium` - Enhancements, minor bugs, improvements
- `priority: low` - Nice-to-have features, documentation updates

### Type Labels
Categorize issues by their nature:

- `type: bug` - Something isn't working as expected
- `type: feature` - New feature or enhancement request
- `type: refactor` - Code restructuring without behavior change
- `type: docs` - Documentation improvements
- `type: performance` - Performance optimizations
- `type: accessibility` - Accessibility improvements
- `type: i18n` - Internationalization/localization
- `type: security` - Security-related issues

### Component Labels
Organize issues by project components:

- `component: calculation-models` - Business logic and calculation algorithms
- `component: ui` - User interface components and styling
- `component: testing` - Test suite and testing infrastructure
- `component: docs` - Documentation and user guides
- `component: build` - Build system and package configuration
- `component: api` - API endpoints and data handling

### Status Labels
Track issue progress:

- `status: blocked` - Cannot proceed due to dependencies or external factors
- `status: in-progress` - Currently being worked on
- `status: needs-review` - Ready for code review
- `status: needs-testing` - Requires testing before merge
- `status: duplicate` - Duplicate of another issue

## Label Setup

Create missing labels using GitHub CLI or through the GitHub web interface. Here are example commands for key labels:

```bash
# Priority labels
gh label create "priority: critical" --color "d73a4a" --description "Blocking issues requiring immediate attention"
gh label create "priority: high" --color "ff9500" --description "Important features and significant bugs"
gh label create "priority: medium" --color "fbca04" --description "Enhancements and minor bugs"
gh label create "priority: low" --color "0e8a16" --description "Nice-to-have features and documentation"

# Type labels
gh label create "type: feature" --color "a2eeef" --description "New feature or enhancement"
gh label create "type: bug" --color "d73a4a" --description "Something isn't working"
gh label create "type: refactor" --color "5319e7" --description "Code restructuring"

# Component labels
gh label create "component: calculation-models" --color "fef2c0" --description "Business logic and calculations"
gh label create "component: ui" --color "c2e0c6" --description "User interface components"
```

## Workflow Integration

### Creating Issues
1. Use descriptive Gitmoji prefixes in issue titles
2. Apply appropriate priority, type, and component labels
3. Use issue templates when available
4. Reference related issues or PRs in the description

### Working on Issues
1. Create feature branches with descriptive names
2. Include issue numbers in commit messages
3. Use appropriate Gitmoji prefixes in commits
4. Update issue status labels as work progresses

### Pull Requests
1. Use Gitmoji prefixes in PR titles
2. Reference issues being addressed
3. Apply relevant labels
4. Ensure all checks pass before requesting review

## Enforcement

These conventions are enforced through:
- GitHub issue and PR templates
- Automated label suggestions
- Code review guidelines
- CI/CD pipeline checks

For questions about these conventions or suggestions for improvements, please create an issue with the `type: docs` label.
