name: merge-dependabot
description: Review and safely merge open Dependabot PRs after validation
prompt: |
  Please review and merge open Dependabot PRs with the following criteria: $ARGUMENTS

  Follow these steps to safely merge Dependabot PRs:

  1. **Identify Dependabot PRs**:
     ```bash
     gh pr list --author "app/dependabot" --state open --json number,title,headRefName,url,labels
     ```
     - Filter for PRs created by Dependabot
     - Exclude draft PRs
     - Note any special labels (security, breaking-change, etc.)

  2. **Categorize by Risk Level**:
     For each PR, determine the risk category:
     
     **LOW RISK** (auto-merge candidates):
     - Patch version updates (x.y.Z)
     - Security patches
     - Dev dependencies only
     - Documentation updates
     
     **MEDIUM RISK** (merge with validation):
     - Minor version updates (x.Y.z)
     - Production dependencies
     - Build tool updates
     
     **HIGH RISK** (manual review required):
     - Major version updates (X.y.z)
     - Breaking changes mentioned
     - Core framework updates
     - Database/infrastructure dependencies

  3. **Pre-merge Validation Process**:
     For each PR in LOW and MEDIUM risk categories:

     a) **Check PR Status**:
        ```bash
        gh pr view [PR_NUMBER] --json statusCheckRollup,mergeable,reviews
        ```
        - Ensure all CI checks are passing
        - Verify no merge conflicts exist
        - Check for any required reviews

     b) **Checkout and Test Locally**:
        ```bash
        gh pr checkout [PR_NUMBER]
        ```
        
     c) **Install Dependencies**:
        ```bash
        # Detect package manager and install
        if [ -f "package-lock.json" ]; then npm ci
        elif [ -f "yarn.lock" ]; then yarn install --frozen-lockfile
        elif [ -f "pnpm-lock.yaml" ]; then pnpm install --frozen-lockfile
        elif [ -f "requirements.txt" ]; then pip install -r requirements.txt
        elif [ -f "Pipfile" ]; then pipenv install
        elif [ -f "pyproject.toml" ]; then pip install -e .
        elif [ -f "go.mod" ]; then go mod download
        elif [ -f "Cargo.toml" ]; then cargo build
        elif [ -f "composer.json" ]; then composer install
        elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
          # Android/Gradle project
          ./gradlew dependencies 2>/dev/null || gradle dependencies 2>/dev/null
        elif [ -f "settings.gradle" ] || [ -f "settings.gradle.kts" ]; then
          # Multi-module Android project
          ./gradlew dependencies 2>/dev/null || gradle dependencies 2>/dev/null
        fi
        ```

     d) **Run Build Process**:
        ```bash
        # Attempt common build commands based on project type
        if [ -f "package.json" ]; then
          npm run build 2>/dev/null || yarn build 2>/dev/null || pnpm build 2>/dev/null
        elif [ -f "Makefile" ]; then
          make build 2>/dev/null || make 2>/dev/null
        elif [ -f "go.mod" ]; then
          go build ./... 2>/dev/null
        elif [ -f "Cargo.toml" ]; then
          cargo build 2>/dev/null
        elif [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
          python -m build 2>/dev/null || python setup.py build 2>/dev/null
        elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
          # Android/Gradle project - try multiple build variants
          ./gradlew assembleDebug 2>/dev/null || gradle assembleDebug 2>/dev/null ||
          ./gradlew build 2>/dev/null || gradle build 2>/dev/null ||
          ./gradlew compileDebugKotlin 2>/dev/null || gradle compileDebugKotlin 2>/dev/null
        elif [ -f "settings.gradle" ] || [ -f "settings.gradle.kts" ]; then
          # Multi-module Android project
          ./gradlew assembleDebug 2>/dev/null || gradle assembleDebug 2>/dev/null ||
          ./gradlew build 2>/dev/null || gradle build 2>/dev/null
        fi
        ```

     e) **Run Test Suite**:
        ```bash
        # Run tests based on project type
        if [ -f "package.json" ]; then
          npm test 2>/dev/null || yarn test 2>/dev/null || pnpm test 2>/dev/null
        elif [ -f "go.mod" ]; then
          go test ./... 2>/dev/null
        elif [ -f "Cargo.toml" ]; then
          cargo test 2>/dev/null
        elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
          pytest 2>/dev/null || python -m pytest 2>/dev/null
        elif [ -f "phpunit.xml" ]; then
          ./vendor/bin/phpunit 2>/dev/null
        elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
          # Android/Gradle testing - prioritize unit tests over instrumented tests
          ./gradlew testDebugUnitTest 2>/dev/null || gradle testDebugUnitTest 2>/dev/null ||
          ./gradlew test 2>/dev/null || gradle test 2>/dev/null ||
          ./gradlew check 2>/dev/null || gradle check 2>/dev/null
        elif [ -f "settings.gradle" ] || [ -f "settings.gradle.kts" ]; then
          # Multi-module Android project
          ./gradlew testDebugUnitTest 2>/dev/null || gradle testDebugUnitTest 2>/dev/null ||
          ./gradlew test 2>/dev/null || gradle test 2>/dev/null
        fi
        ```

     f) **Run Linting/Type Checking** (if available):
        ```bash
        # Common linting commands
        npm run lint 2>/dev/null || yarn lint 2>/dev/null || pnpm lint 2>/dev/null
        npm run type-check 2>/dev/null || yarn type-check 2>/dev/null
        go vet ./... 2>/dev/null
        cargo clippy 2>/dev/null
        flake8 . 2>/dev/null || black --check . 2>/dev/null
        
        # Android/Kotlin linting
        if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
          # Kotlin/Android linting
          ./gradlew ktlintCheck 2>/dev/null || gradle ktlintCheck 2>/dev/null ||
          ./gradlew detekt 2>/dev/null || gradle detekt 2>/dev/null ||
          ./gradlew lint 2>/dev/null || gradle lint 2>/dev/null ||
          ./gradlew lintDebug 2>/dev/null || gradle lintDebug 2>/dev/null
        elif [ -f "settings.gradle" ] || [ -f "settings.gradle.kts" ]; then
          # Multi-module project linting
          ./gradlew ktlintCheck 2>/dev/null || gradle ktlintCheck 2>/dev/null ||
          ./gradlew detekt 2>/dev/null || gradle detekt 2>/dev/null ||
          ./gradlew lint 2>/dev/null || gradle lint 2>/dev/null
        fi
        ```

  4. **Merge Decision Logic**:
     
     **AUTO-MERGE** if all conditions met:
     - LOW RISK category
     - All CI checks passing
     - Local build successful
     - Tests pass (or no test failures)
     - No linting errors
     - Security update or patch version
     
     **MERGE WITH CONFIRMATION** for MEDIUM RISK:
     - Manual approval prompt before merging
     - Display change summary and test results
     - Allow skip if user confirms
     
     **SKIP AND REPORT** for HIGH RISK or failures:
     - Add comment explaining why not merged
     - List any test failures or build issues
     - Suggest manual review

  5. **Merge Process**:
     For approved PRs:
     ```bash
     # Switch back to main branch
     git checkout main
     
     # Merge the PR
     gh pr merge [PR_NUMBER] --squash --delete-branch
     
     # Or use merge commit for better traceability
     gh pr merge [PR_NUMBER] --merge --delete-branch
     ```

  6. **Post-merge Actions**:
     - Add comment to merged PR with validation results
     - Update any tracking issues
     - Log successful merges for reporting
     
  7. **Error Handling and Reporting**:
     - Create summary of all actions taken
     - Report any PRs that couldn't be merged and why
     - Suggest manual intervention for failed validations
     - Preserve error logs for debugging

  8. **Safety Options** (accept as arguments):
     - `--dry-run`: Show what would be merged without actually merging
     - `--security-only`: Only merge security updates
     - `--patch-only`: Only merge patch version updates
     - `--max-merges N`: Limit number of PRs to merge in one run
     - `--skip-tests`: Skip test validation (not recommended)
     - `--auto-approve`: Skip manual confirmation for medium risk PRs

  Example usage:
  ```bash
  # Default behavior - merge low risk PRs automatically
  claude-code merge-dependabot
  
  # Dry run to see what would be merged
  claude-code merge-dependabot --dry-run
  
  # Only security updates
  claude-code merge-dependabot --security-only
  
  # Include minor updates with manual approval
  claude-code merge-dependabot --include-minor
  ```

  Remember: Always prioritize project stability over automation. When in doubt, request manual review rather than risk breaking the build.