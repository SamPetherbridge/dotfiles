name: review-issue
description: Review a GitHub issue to determine if it has been fixed or should remain open
prompt: |
  Please review the GitHub issue: $ARGUMENTS

  Follow these steps to determine the issue status:

  1. **Get Issue Details**: Use `gh issue view $ARGUMENTS` to retrieve the complete issue information including:
     - Issue title and description
     - Current status (open/closed)
     - Labels and assignees
     - Comments and discussion thread
     - Referenced commits or PRs

  2. **Analyze the Problem**: 
     - Understand the core problem described in the issue
     - Identify the expected vs actual behavior
     - Note any error messages, stack traces, or reproduction steps
     - Check if there are any workarounds mentioned

  3. **Search for Related Changes**:
     - Use `gh pr list --search "fixes #$ARGUMENTS"` or similar to find PRs that reference this issue
     - Search the codebase for files mentioned in the issue using appropriate search tools
     - Look for recent commits that might address the problem using `git log --grep` with relevant keywords
     - Check if the issue was mentioned in changelog or release notes

  4. **Verify Current State**:
     - If reproduction steps are provided, attempt to reproduce the issue in the current codebase
     - Check if the described functionality now works as expected
     - Look for any automated tests that cover the reported issue
     - Verify if error conditions mentioned in the issue still occur

  5. **Check Dependencies and Environment**:
     - Review if the issue was related to specific versions of dependencies
     - Check if environment-specific problems have been resolved
     - Look for any configuration changes that might have addressed the issue

  6. **Provide Recommendation and Take Action**:
     Based on your analysis, provide one of these recommendations and take appropriate action:
     
     **FIXED - READY TO CLOSE**:
     - The issue has been resolved by specific commits/PRs
     - The described problem no longer occurs
     - Tests exist to prevent regression
     - **ACTION**: Automatically close the issue with a detailed comment
     
     **PARTIALLY FIXED - NEEDS VERIFICATION**:
     - Changes have been made that likely fix the issue
     - Manual verification is needed to confirm the fix
     - Additional testing might be required
     - **ACTION**: Add comment with findings and apply "needs-verification" label
     
     **STILL OPEN - NEEDS ATTENTION**:
     - The problem persists in the current codebase
     - No evidence of fixes has been found
     - The issue remains reproducible
     - **ACTION**: Add comment with current status and keep open
     
     **OUTDATED - SAFE TO CLOSE**:
     - The issue applies to old versions no longer supported
     - The codebase has changed significantly making the issue irrelevant
     - Dependencies or environment changes have made the issue obsolete
     - **ACTION**: Automatically close the issue with explanation

  7. **Execute Actions Based on Status**:
     
     **For FIXED - READY TO CLOSE**:
     ```bash
     # Add a comprehensive closing comment
     gh issue comment $ARGUMENTS --body "## Issue Resolution Summary

     🎉 **This issue has been resolved and is ready to close.**

     **Root Cause**: [Brief description of what caused the issue]

     **Resolution**: [How it was fixed - specific PRs/commits]
     $(if commits found)
     **Fixed by**:
     - Commit: [commit hash] - [commit message]
     - PR: #[PR number] - [PR title]
     $(endif)

     **Verification**: [How you confirmed it's fixed]
     - ✅ Issue no longer reproducible
     - ✅ Tests added/passing
     - ✅ No related error reports

     **Evidence**: [Specific evidence of the fix]

     Closing as resolved. Thanks for reporting this issue!"

     # Close the issue
     gh issue close $ARGUMENTS --reason completed
     ```

     **For OUTDATED - SAFE TO CLOSE**:
     ```bash
     # Add closing comment for outdated issues
     gh issue comment $ARGUMENTS --body "## Issue Outdated

     🔄 **This issue appears to be outdated and no longer relevant.**

     **Reason for closure**:
     [Specific reason - version changes, architecture changes, etc.]

     **Analysis**:
     - Original issue reported against: [version/environment]
     - Current state: [current version/environment]
     - Impact: [why it's no longer relevant]

     **Recommendation**: If you're still experiencing this issue with the current version, please open a new issue with updated reproduction steps and environment details.

     Closing as outdated."

     # Close the issue
     gh issue close $ARGUMENTS --reason "not planned"
     ```

     **For PARTIALLY FIXED - NEEDS VERIFICATION**:
     ```bash
     # Add status comment and label
     gh issue comment $ARGUMENTS --body "## Verification Needed

     🔍 **This issue appears to be fixed but needs verification.**

     **Potential Fix Found**:
     $(if commits/PRs found)
     - Commit: [commit hash] - [commit message]
     - PR: #[PR number] - [PR title]
     $(endif)

     **Current Status**:
     [Summary of what was found]

     **Next Steps**:
     - [ ] Verify the fix resolves the original issue
     - [ ] Test the reproduction steps still fail/pass as expected
     - [ ] Confirm no regressions introduced

     **Original Reporter**: @[username] - Could you please verify this fix resolves your issue?

     Adding 'needs-verification' label."

     # Add needs-verification label
     gh issue edit $ARGUMENTS --add-label "needs-verification"
     ```

     **For STILL OPEN - NEEDS ATTENTION**:
     ```bash
     # Add status update comment
     gh issue comment $ARGUMENTS --body "## Issue Status Update

     ⚠️ **This issue appears to still be active and needs attention.**

     **Current Analysis**:
     [Summary of current state]

     **Findings**:
     - Issue is still reproducible: [Yes/No/Unknown]
     - Related work found: [Any PRs/commits that partially address it]
     - Workarounds available: [Any mentioned workarounds]

     **Recommended Actions**:
     - [ ] Reproduce the issue with current codebase
     - [ ] Implement fix for the reported problem
     - [ ] Add tests to prevent regression

     This issue remains open and ready for contribution."

     # Add labels if appropriate
     gh issue edit $ARGUMENTS --add-label "confirmed,help wanted"
     ```

  8. **Safety Options and Confirmation**:
     Accept these optional arguments to control behavior:
     - `--dry-run`: Show what actions would be taken without executing them
     - `--no-auto-close`: Only add comments, don't automatically close issues
     - `--force-close`: Close issues even with minimal evidence (use carefully)
     - `--label-only`: Only add labels, don't close or comment extensively

  9. **Post-Action Summary**:
     After processing, provide a summary:
     ```
     ## Review Summary for Issue #[NUMBER]
     
     **Status**: [FIXED/PARTIALLY FIXED/STILL OPEN/OUTDATED]
     **Action Taken**: [Closed/Commented/Labeled]
     **Evidence Found**: [Brief summary]
     **Recommendation**: [Next steps if any]
     ```

  Important: 
  - Always provide detailed, evidence-based comments when closing issues
  - Use appropriate GitHub close reasons ("completed" for fixed, "not planned" for outdated)
  - Tag original reporters when requesting verification
  - Include specific commit hashes, PR numbers, and evidence in comments
  - Respect the `--dry-run` and `--no-auto-close` flags for safety