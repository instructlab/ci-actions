# Validate Notebooks

## Overview

Validate Notebooks is a simple action that reads a file with the `.ipynb` extension, and verifies that body of that file is a valid jupyter notebook.

## When to Use it?

This tool is best used as a preliminary step for any CI workflows involving jupyter notebooks. This script is best used as a first test for any workflows testing
jupyter notebooks. If any of the notebooks passed to it are not valid, it will fail at the end of the job, and report out all of the errors it encountered. This will prevent jobs that may be more complicated from getting started, then failing unexpectedly.

## Usage

This is a reusable workflow, and can be referenced and used in any github actions workflow. Here is an example of how to import this into a workflow that needs to test a notebook file named `my_notebook.ipynb` and all the notebooks contained in the directory `./directory_containing_notebooks/`:

```yaml
jobs:
  example-job:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout "validate-notebooks" in-house CI action
        uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
        with:
          repository: instructlab/ci-actions
          path: ci-actions
          sparse-checkout: |
            actions/validate-notebooks
      - name: Validate Jupyter Notebooks
        uses: ./ci-actions/actions/validate-notebooks
        with:
          notebook_paths: "notebooks/"
```
