# Contributing to the InstructLab CI Actions Repository

👍🎉 First off, thank you for taking the time to contribute! 🎉👍

The following is a set of guidelines for contributing. These are just guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request. Please read the [community contribution guide](https://github.com/instructlab/community/blob/main/CONTRIBUTING.md) first for general practices for the 🐶 InstructLab community.

## What Should I Know Before I Get Started?

### About this Repository

This repository is intended to house our reusable, in-house GitHub actions. This means the GitHub actions provided in this repository are designed with the InstructLab GitHub organization in mind and therefore might not be practical for use cases outside of the InstructLab organizaiton.

### Code of Conduct

This project adheres to the [InstructLab - Code of Conduct and Covenant](https://github.com/instructlab/community/blob/main/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

### How Do I Start Contributing?

The below workflow is designed to help you begin your first contribution journey. It will guide you through creating and picking up issues, working through them, having your work reviewed, and then merging.

Help on open source projects is always welcome and there is always something that can be improved. For example, documentation (like the text you are reading now) can always use improvement, code can always be clarified, variables or functions can always be renamed or commented on, and there is always a need for more test coverage. If you see something that you think should be fixed, take ownership! Here is how you get started:

## How Can I Contribute?

When contributing, it's useful to start by looking at [issues](https://github.com/instructlab/ci-actions/issues). After picking up an issue, writing code, or updating a document, make a pull request and your work will be reviewed and merged. If you're adding a new feature or find a bug, it's best to [write an issue](https://github.com/instructlab/ci-actions/issues/new?assignees=&labels=&template=feature_request.md&title=) first to discuss it with maintainers.

To contribute to this repository, you'll use the Fork and Pull model common in many open source repositories. For details on this process, check out [The GitHub Workflow Guide](https://github.com/kubernetes/community/blob/master/contributors/guide/github-workflow.md) from Kubernetes.

When your contribution is ready, you can create a pull request. Pull requests are often referred to as "PR". In general, we follow the standard [GitHub pull request](https://help.github.com/en/articles/about-pull-requests) process. Follow the template to provide details about your pull request to the maintainers.

Before sending pull requests, make sure your changes pass formatting, linting and unit tests.

### Continuous Integration

Pull requests are tested using [Continuous Integration](../docs/ci.md) pipelines implemented by [GitHub Actions](https://docs.github.com/actions). Be sure to correct any issue reported by these pipelines.

### Code Review

Once you've [created a pull request](#how-can-i-contribute), maintainers will review your code and may make suggestions to fix before merging. It will be easier for your pull request to receive reviews if you consider the criteria the reviewers follow while working. Remember to:

- Run the existing tests locally to ensure they pass
- Add tests to cover any new code you write
- Follow the project coding conventions
- Write detailed commit messages
- Break large changes into a logical series of smaller patches, which are easy to understand individually and combine to solve a broader issue

#### How Do I Submit A (Good) Bug Report?

If your bug report pertains to a potential security vulnerability, you can find information on how to report such a vulnerability, as well as where to subscribe to receive security alerts, on the project's [Security Page](https://github.com/instructlab/.github/blob/main/SECURITY.md). Otherwise, bugs are tracked as [GitHub issues using the Bug Report template](https://github.com/instructlab/ci-actions/issues/new?assignees=&labels=&template=bug_report.md&title=). Create an issue on that and provide the information suggested in the bug report issue template.

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion, including completely new features, tools, and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion ✏️ and find related suggestions 🔎

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues using the Feature Request template](https://github.com/instructlab/ci-actions/issues/new?assignees=&labels=&template=feature_request.md&title=). Create an issue and provide the information suggested in the feature requests or user story issue template.

#### How Do I Submit A (Good) Improvement Item?

Improvements to existing functionality are tracked as [GitHub issues using the User Story template](https://github.com/instructlab/ci-actions/issues/new?assignees=&labels=&template=user_story.md&title=). Create an issue and provide the information suggested in the feature requests or user story issue template.

## Development

### Prepare to Update or Add a New In-House Action

In preparation for development, you will need to create a fork from this repository, as explained in the [How Can I Contribute?](#how-can-i-contribute) section. All development and testing will need to be done from your own fork, and the process for testing your changes will be explained later on in this section. However, it is important to first ensure that your dev environment is properly set up. Please review the next sub-section for details setting up your dev environment.

### Set up your dev environment

GitHub actions should be written in either Bash or Python whenever possible. The following tools are required to develop in-house GitHub actions:

- [`git`](https://git-scm.com)
- [`python`](https://www.python.org) (v3.10 or v3.11)
- [`pip`](https://pypi.org/project/pip/) (v23.0+)
- [`bash`](https://www.gnu.org/software/bash/) (v5+)

You can setup your dev environment using [`tox`](https://tox.wiki/en/latest/), an environment orchestrator which allows for setting up environments for and invoking builds, unit tests, formatting, linting, etc. Install tox with:

```shell
pip install -r requirements-dev.txt
```

Install project requirements with:

```shell
pip install -r requirements.txt
```

### Update or Add a New Action

All in-house GitHub actions are located under the [actions](../actions/) directory within this repository. Each action has its own dedicated subdirectory and does not share its resources with other actions. Therefore, if you plan to add a new in-house action or update an existing in-house action, that action should always reside under a unique subdirectory within the [actions](../actions/) directory.

**It is important that each in-house action does not share its resources with other in-house actions, as that can introduce dependencies between actions and potentially result in unexpected behavior from one or more actions.**

### Test your Changes

When you want to update an existing, in-house action or want to create a new one, you should test those proposed changes before requesting a formal pull request review. By successfully testing your changes early on, repository and org maintainers throughout InstructLab will have confidence that your proposed changes behave/perform as intended.

#### 1. Find an InstructLab Repository to Test with

Whenever you plan to create or update an in-house action, you will already have some idea about which InstructLab repositories you want to consume that change. Therefore, you should create a fork of those specific InstructLab repositories and plan to test your proposed changes against them.

#### 2. Create a Pull Request in your Desired "Test" Repositories

Now that you've identified and forked specific InstructLab repositories you want to test against, your next step is to find the specific workflow file(s) that you want to test your action in. (Note: In each InstructLab repository that has CI checks, these workflow files are stored under the `.github` directory in the root of the repository.)

Within those workflow file(s), you will need to instruct GitHub to:

1. Checkout a specific in-house GitHub action *from your fork*.

Example code snippet:

```yaml
# Give the step a useful name for context
- name: Checkout in-house <SOME_ACTION_NAME> action
  uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
  with:
    # Specify your fork here using the form of: {org}/{repo}
    repository: your-org/ci-actions
    # Clone the "ci-actions" repo to a local directory called "ci-actions", instead of
    # overwriting the current dir contents
    path: ci-actions
    # If you created your changes in a branch other than `main`, provide the feature
    # branch name so GitHub knows where to look for it. (`ref` defaults to `main`.)
    ref: your-feature-branch
    # The `instructlab/ci-actions` repository contains a lot of files, most of which
    # likely do not pertain to your action. This tells GitHub to checkout your action
    # only.
    sparse-checkout: |
    actions/SOME_ACTION_NAME
```

2. Call your custom GitHub action.

Example code snippet:

```yaml
- name: <SOME_ACTION_NAME>
  # The "uses" parameter tells GitHub where to find your CI action. Since, in the previous
  # step, you told GitHub to clone your changes and store them in the `./ci-actions`
  # directory, you will need to tell GitHub which path under `./ci-actions` contains the
  # GitHub action you want to run.
  uses: ./ci-actions/actions/SOME_ACTION_NAME
```

Putting it all together in a sample job:

```yaml
# This job launches an EC2 instance in AWS to run some unit tests
jobs:
  start-ec2-runner:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout "free-disk-space" in-house CI action
        uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
        with:
          # "free-disk-space" was added as branch within this "ci-actions" repo, but it
          # also could have been added through a fork instead. Either method will work.
          # We just need to reference the actual repository and actual branch that contains
          # those changes.
          repository: instructlab/ci-actions
          path: ci-actions
          ref: free-disk-space
          sparse-checkout: |
            actions/free-disk-space

      - name: Free disk space
        uses: ./ci-actions/actions/free-disk-space
```

When you want to run your changes, you should reach out to a maintainer to ask them to manually trigger your changes for you. After your tests pass, provide a link to your pull request alongside the job logs.