---
description: Automatically merge safe Dependabot PRs after reviewing changes and verifying they won't break anything
---

# Automated Dependabot PR Merging with Code Review

You are autonomously managing Dependabot dependency update PRs. For each PR, you must REVIEW the changes yourself - do not blindly trust CI. Merge only PRs that you've verified are safe.

## Step 1: Pre-flight Checks

Ensure clean state and fetch latest:
```bash
git fetch origin
git status --porcelain
```

If working directory is dirty, stash changes:
```bash
git stash push -m "dependabot-merge-$(date +%s)"
```

Record current branch:
```bash
git branch --show-current
```

## Step 2: Get All Open Dependabot PRs

```bash
gh pr list --author "app/dependabot" --state open --json number,title,headRefName,mergeable,mergeStateStatus,statusCheckRollup,labels,body
```

If no PRs found, report "No open Dependabot PRs" and exit.

## Step 3: Review and Process Each PR

For each PR, perform ALL of these steps. Do not skip the review.

### 3.1: Check Basic Merge Requirements

Skip immediately if:
- `mergeable` is `CONFLICTING` (has merge conflicts)
- `mergeStateStatus` is `BLOCKED` (needs approval)

### 3.2: Review the PR Diff

**CRITICAL: You must review the actual changes, not just check CI status.**

```bash
gh pr diff <PR_NUMBER>
```

Analyze the diff and check:

1. **What dependency is being updated?** (e.g., retrofit, kotlin, okhttp)
2. **What version change is it?** (patch/minor/major)
3. **What files are modified?** (usually just build.gradle.kts or version catalogs)

### 3.3: Assess the Dependency Update

Based on the dependency being updated, assess the risk:

**LOW RISK - Generally safe to merge:**
- Patch version bumps (x.y.Z → x.y.Z+1)
- Well-known stable libraries (androidx, kotlin stdlib, etc.)
- Security patches
- Dependencies with good backwards compatibility (retrofit, okhttp, etc.)

**MEDIUM RISK - Review more carefully:**
- Minor version bumps (x.Y.z → x.Y+1.0)
- Libraries that touch core functionality
- Testing libraries (could affect CI)

**HIGH RISK - Skip unless certain:**
- Major version bumps (X.y.z → X+1.0.0)
- Build tooling (gradle, AGP, kotlin compiler)
- Libraries known for breaking changes

### 3.4: Check How the Dependency is Used

Search the codebase to understand usage:

```bash
# Find where the dependency is imported/used
grep -r "import <package>" --include="*.kt" app/src/ || true
```

Consider:
- Is this dependency heavily used or barely used?
- Does it touch critical paths (payments, auth, analytics)?
- Are there any deprecated API calls that might be removed?

### 3.5: Review Dependabot's Release Notes

The PR body usually contains release notes. Read them and check for:
- Breaking changes mentioned
- Deprecation notices
- Migration guides required
- Known issues

If the PR body mentions breaking changes or migration required, **SKIP** the PR.

### 3.6: Check CI Status (Secondary Check)

```bash
gh pr checks <PR_NUMBER>
```

CI is a secondary signal, not primary. Even if CI passes:
- The test suite might not cover the affected code paths
- Breaking changes might only surface at runtime
- Type changes might cause issues not caught by tests

### 3.7: Local Verification

For PRs that pass your review, verify locally:

```bash
# Checkout the PR
gh pr checkout <PR_NUMBER>

# Build the project
./gradlew assembleDebug --quiet

# Run safety tests
./gradlew testDebugUnitTest --tests "*InitializationTest" --quiet

# Run full unit tests
./gradlew testDebugUnitTest --quiet
```

If any step fails, record the error and skip this PR.

### 3.8: Make Merge Decision

Only merge if ALL of these are true:
- [ ] You reviewed the diff and understand the change
- [ ] The version bump is appropriate (patch/minor for auto-merge)
- [ ] No breaking changes mentioned in release notes
- [ ] The dependency usage in codebase looks compatible
- [ ] Local build succeeds
- [ ] Local tests pass

```bash
gh pr merge <PR_NUMBER> --squash --delete-branch
```

## Step 4: Return to Original State

```bash
git checkout <ORIGINAL_BRANCH>
git pull origin <ORIGINAL_BRANCH>
```

If changes were stashed:
```bash
git stash pop
```

## Step 5: Final Integration Verification

After merging multiple PRs, verify they all work together:

```bash
./gradlew clean assembleDebug --quiet
./gradlew testDebugUnitTest --quiet
```

If this fails, one of the merged dependencies may conflict with another.

## Step 6: Report Results

Provide a detailed summary:

```
## Dependabot Merge Report

### ✅ Merged (X PRs)
- PR #123: Bump retrofit from 2.9.0 to 2.10.0
  - Risk: Low (patch bump, stable library)
  - Review: No breaking changes in release notes

### ⏭️ Skipped (Y PRs)
- PR #125: Bump gradle from 8.0 to 8.5
  - Reason: Major version bump, high risk for build tooling
  - Recommendation: Manual review required

- PR #126: Bump okhttp from 4.x to 5.0.0
  - Reason: Major version with breaking API changes noted in release
  - Recommendation: Check migration guide before updating

### 🧪 Verification Status
- Build: ✅ PASSED
- Tests: ✅ PASSED
```

## Review Guidelines by Dependency Type

### Always Safe (Auto-merge if patch/minor):
- `androidx.*` - Google's compatibility libraries
- `com.squareup.retrofit2` - Stable, backwards compatible
- `com.squareup.okhttp3` - Stable within major version
- `org.jetbrains.kotlin:kotlin-stdlib` - Stable
- `com.google.firebase:firebase-*` - Usually safe minor bumps

### Review Carefully:
- `com.android.tools.build:gradle` (AGP) - Can break builds
- `org.jetbrains.kotlin:kotlin-gradle-plugin` - Version must match stdlib
- `com.google.dagger:hilt-*` - Can have subtle breaking changes
- Testing libraries (JUnit, Mockito, etc.) - Can fail CI

### Skip Major Bumps (Require manual review):
- Any X.0.0 version bump
- Build plugins
- Core framework dependencies

## Key Principle

**Do not trust CI blindly.** Your job is to:
1. Understand what's changing
2. Assess the risk
3. Verify it won't break things
4. Only then merge

If in doubt, skip the PR and note why in the report.
