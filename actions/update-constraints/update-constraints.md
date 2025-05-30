# Update constraints-dev.txt file

## Overview

This action is used to attempt an update to constraints-dev.txt file that holds
all pins for all dependencies of a project. If any changes are detected, a new
PR will be posted to the corresponding repository.

This action is aligned with the proposed
[total constraints strategy](https://github.com/instructlab/dev-docs/pull/198)
for InstructLab CI.

## Requirements

The project should define a new `constraints` tox target in `tox.ini` file that
will install a particular version of `uv`. It's advised to pin the
`uv` version in the `tox` environment definition to avoid any potential
breakages due to changes in the `uv` tool itself.

Example `tox.ini` entry:

```ini
[testenv:constraints]
description = Generate new constraints file(s)
basepython = {[testenv:py3]basepython}
skip_install = True
skipsdist = true
deps =
    uv==0.7.8
commands = {posargs}
allowlist_externals = *
```

Each project should also list all input requirements files in the
`requirements-files.in` file, one file name per line.

For example, the `requirements-files.in` file may look like this:

```
requirements.txt
requirements-dev.txt
docs/requirements.txt
```

## How to Call this Action

The action is meant to be executed from a separate workflow file. It's advised
to schedule its weekly execution.

Example:

```yaml
name: Update constraints-dev.txt

on:
  schedule:
    - cron: '0 3 * * 1'  # Every Monday at 03:00 UTC
  workflow_dispatch:

jobs:
  update-constraints:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2

      - name: Checkout "update-constraints" in-house CI action
        uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
        with:
          repository: instructlab/ci-actions
          path: ci-actions
          ref: v0.2.0
          sparse-checkout: |
            actions/update-constraints

      - name: Update constraints
        id: update-constraints
        uses: ./ci-actions/actions/update-constraints
        with:
          gh-token: ${{ secrets.GH_PERSONAL_ACCESS_TOKEN }}
```
