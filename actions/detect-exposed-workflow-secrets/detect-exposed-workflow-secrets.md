# Detect Exposed Workflow Secrets

## Overview

This action detects potentially-exposed GitHub workflow secrets in workflows that automatically trigger on PR builds. If a contributor creates a pull request that would expose one or more GitHub secrets, this action can be used to abort the contributor's PR build and alert maintainers about the potential security exposure.

## When to Use it?

Use this action when you are concerned that a contributor may expose a workflow secret such as a paid API key or login credentials

## How to Call this Action from a Job within a GitHub Workflow 

It is strongly recommended that you add this action within a new or existing lint workflow, and that you require this action to complete before proceeding with unit testing, functional testing, E2E testing, etc.

To call this action, create this basic job definition and put it in one of your lint workflow files:

```yaml
security-lint:
  runs-on: ubuntu-latest
  steps:

    # Clone the `ci-actions` repo to gain access to this action
    - name: Checkout "detect-exposed-workflow-secrets" in-house CI action
      uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      with:
        # The action is stored in this repository, so we need to tell GitHub to pull from: {org}/{repo}
        repository: instructlab/ci-actions
        # clone the "ci-actions" repo to a local directory called "ci-actions", instead of overwriting the current WORKDIR contents
        path: ci-actions
        # Only checkout the relevant GitHub action
        sparse-checkout: |
          actions/detect-exposed-workflow-secrets

    # Run the secrets detection
    - name: Detect exposed GitHub secrets
      uses: ./.github/actions/detect-exposed-workflow-secrets
```