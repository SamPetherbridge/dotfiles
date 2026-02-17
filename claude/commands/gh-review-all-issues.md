name: review-all-issues
description: Review all open issues in the repository to determine if they should remain open or be closed
prompt: |
  Please review all open issues in the repository with the following criteria: $ARGUMENTS

  Follow these steps to systematically review all open issues:

  1. **Fetch All Open Issues**:
     ```bash
     # Get all open issues with relevant metadata
     gh issue list --state open --json number,title,createdAt,updatedAt,author,labels,url --limit 1000
     ```
     
     Parse and categorize issues by:
     - Age (created date)
     - Last activity (updated date)
     - Labels (bug, enhancement, documentation, etc.)
     - Author type (maintainer, contributor, dependabot, etc.)

  2. **Prioritize Review Order**:
     Process issues in this order for efficiency:
     
     **HIGH PRIORITY** (review first):
     - Issues with "fixed" or "resolved" labels
     - Very old issues (>1 year with no activity)
     - Issues with security labels
     - Duplicate-marked issues
     
     **MEDIUM PRIORITY**:
     - Bug reports older than 6 months
     - Enhancement requests older than 1 year
     - Issues with stale labels
     
     **LOW PRIORITY** (review last):
     - Recent issues (<3 months old)
     - Active discussions (recent comments)
     - Issues with "in-progress" labels

  3. **Batch Processing Strategy**:
     For efficiency, process issues in small batches:
     
     ```bash
     # Process 10-20 issues at a time to avoid rate limits
     BATCH_SIZE=15
     TOTAL_ISSUES=$(gh issue list --state open | wc -l)
     
     echo "Found $TOTAL_ISSUES open issues. Processing in batches of $BATCH_SIZE..."
     ```

  4. **Individual Issue Analysis**:
     For each issue, perform the same analysis as the single issue review:

     a) **Get Detailed Issue Information**:
        ```bash
        gh issue view [ISSUE_NUMBER] --json title,body,createdAt,updatedAt,author,labels,comments,state
        ```

     b) **Search for Related Changes**:
        ```bash
        # Look for PRs that might have fixed this issue
        gh pr list --search "fixes #[ISSUE_NUMBER]" --state all --json number,title,state,mergedAt
        gh pr list --search "[ISSUE_NUMBER]" --state all --json number,title,state,mergedAt
        
        # Search commit messages for references
        git log --grep="#[ISSUE_NUMBER]" --oneline --since="$(date -d '2 years ago' '+%Y-%m-%d')"
        ```

     c) **Quick Reproducibility Check**:
        For bug reports, perform basic checks:
        - Look for error messages in current codebase
        - Check if mentioned files/functions still exist
        - Verify if described functionality has changed

  5. **Automated Classification Logic**:
     
     **AUTO-CLOSE CANDIDATES** (high confidence):
     ```bash
     # Issues that can be safely closed automatically
     CLOSE_REASONS=(
       "Referenced in merged PR with 'fixes' keyword"
       "Error/function mentioned no longer exists in codebase"
       "Duplicate of newer issue with same problem"
       "Applies to unsupported version (>2 major versions old)"
       "Feature request implemented (found in code/docs)"
       "Already labeled as 'fixed' or 'resolved' by maintainers"
     )
     ```
     
     **MANUAL REVIEW NEEDED** (medium confidence):
     ```bash
     # Issues requiring human judgment
     MANUAL_REVIEW=(
       "Partial fixes found but unclear if complete"
       "Old but still potentially relevant"
       "Complex feature requests with mixed signals"
       "Bug reports with unclear reproduction steps"
     )
     ```
     
     **KEEP OPEN** (low confidence for closure):
     ```bash
     # Issues that should definitely stay open
     KEEP_OPEN=(
       "Recent activity (comments in last 3 months)"
       "Assigned to active milestone"
       "Marked as high/critical priority"
       "No evidence of fix found"
       "Active discussion ongoing"
     )
     ```

  6. **Bulk Action Execution**:
     
     **For AUTO-CLOSE issues**:
     ```bash
     # Process closures in batches to avoid rate limits
     for issue in "${AUTO_CLOSE_ISSUES[@]}"; do
       gh issue comment "$issue" --body "## Automated Issue Review

     🤖 **This issue was reviewed as part of a repository cleanup.**

     **Status**: RESOLVED - Ready to Close
     **Reason**: $CLOSE_REASON
     **Evidence**: $EVIDENCE_FOUND

     **Analysis Summary**:
     $DETAILED_ANALYSIS

     This issue appears to have been resolved. If you believe this closure was incorrect, please comment and we'll reopen it for further review.

     *This review was performed automatically using claude-code review-all-issues*"

       # Close with appropriate reason
       gh issue close "$issue" --reason completed
       
       # Rate limit protection
       sleep 2
     done
     ```
     
     **For MANUAL REVIEW issues**:
     ```bash
     # Add review comments and labels
     for issue in "${MANUAL_REVIEW_ISSUES[@]}"; do
       gh issue comment "$issue" --body "## Issue Review - Verification Needed

     🔍 **This issue was flagged during repository cleanup and needs manual verification.**

     **Current Status**: $ANALYSIS_SUMMARY
     **Potential Resolution**: $POTENTIAL_FIX_FOUND
     **Confidence Level**: Medium

     **Action Required**:
     - [ ] Verify if the reported issue still exists
     - [ ] Confirm if any related changes resolved the problem
     - [ ] Update issue status or close if resolved

     **Evidence Found**:
     $EVIDENCE_DETAILS

     Adding 'needs-review' label for maintainer attention."

       gh issue edit "$issue" --add-label "needs-review,stale-candidate"
       sleep 1
     done
     ```

  7. **Generate Comprehensive Report**:
     ```bash
     # Create detailed summary of all actions taken
     cat > issue_review_report.md << EOF
     # Repository Issue Review Report
     Generated: $(date)
     
     ## Summary
     - **Total Issues Reviewed**: $TOTAL_REVIEWED
     - **Issues Closed**: $CLOSED_COUNT
     - **Issues Flagged for Review**: $FLAGGED_COUNT
     - **Issues Kept Open**: $KEPT_OPEN_COUNT
     
     ## Closed Issues
     $(for issue in closed_issues; do echo "- #$issue: $reason"; done)
     
     ## Issues Needing Manual Review
     $(for issue in manual_review; do echo "- #$issue: $reason"; done)
     
     ## Statistics by Category
     - **Bugs Fixed**: $BUGS_FIXED
     - **Features Implemented**: $FEATURES_DONE
     - **Duplicates Removed**: $DUPLICATES_CLOSED
     - **Outdated Issues**: $OUTDATED_CLOSED
     
     ## Recommendations
     - Issues marked 'needs-review' should be triaged by maintainers
     - Consider implementing automated issue lifecycle management
     - Review issue templates to improve quality of future reports
     EOF
     ```

  8. **Safety Controls and Options**:
     Support these command-line arguments:
     
     ```bash
     # Safety options
     --dry-run              # Show what would be done without executing
     --max-close N          # Limit number of issues to close (default: 10)
     --min-age DAYS         # Only review issues older than N days (default: 30)
     --exclude-labels LABEL # Skip issues with specific labels
     --include-labels LABEL # Only process issues with specific labels
     --batch-size N         # Number of issues to process per batch (default: 15)
     --no-auto-close        # Only add comments, don't close anything
     --report-only          # Generate report without taking actions
     --confidence-level     # high|medium|low - minimum confidence for auto-close
     ```

  9. **Progressive Disclosure Strategy**:
     ```bash
     # Start with safest actions first
     if [ "$CONFIDENCE_LEVEL" = "high" ]; then
       # Only close issues with very strong evidence
       MIN_EVIDENCE_SCORE=90
     elif [ "$CONFIDENCE_LEVEL" = "medium" ]; then
       # Close issues with good evidence
       MIN_EVIDENCE_SCORE=70
     else
       # Close issues with reasonable evidence
       MIN_EVIDENCE_SCORE=50
     fi
     ```

  10. **Rate Limiting and Politeness**:
      ```bash
      # Respect GitHub API rate limits
      REQUESTS_PER_MINUTE=30
      REQUEST_DELAY=$((60 / REQUESTS_PER_MINUTE))
      
      # Add delays between operations
      function rate_limit_sleep() {
        sleep $REQUEST_DELAY
      }
      
      # Monitor rate limit status
      function check_rate_limit() {
        REMAINING=$(gh api rate_limit --jq '.rate.remaining')
        if [ "$REMAINING" -lt 100 ]; then
          echo "Rate limit low ($REMAINING remaining). Waiting..."
          sleep 300  # Wait 5 minutes
        fi
      }
      ```

  Usage Examples:
  ```bash
  # Safe dry run to see what would happen
  claude-code review-all-issues --dry-run
  
  # Conservative review - only close obvious cases
  claude-code review-all-issues --confidence-level high --max-close 5
  
  # Focus on old issues only
  claude-code review-all-issues --min-age 180 --max-close 20
  
  # Generate report without taking action
  claude-code review-all-issues --report-only
  
  # Process only bug reports
  claude-code review-all-issues --include-labels bug --max-close 10
  ```

  Important Safeguards:
  - Default to conservative approach (fewer false closures)
  - Always provide detailed closure reasons
  - Include evidence and analysis in comments
  - Respect rate limits to avoid API issues
  - Generate comprehensive reports for transparency
  - Allow easy reversal of automated actions