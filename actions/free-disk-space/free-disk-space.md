# Free Disk Space

## Overview

This action is used to reclaim disk space on either a GitHub runner or on an EC2 instance (EC2 runner) in AWS. When called at the beginning of a GitHub workflow job, it will attempt to remove default OS packages that are not used by InstructLab. For example: the Android, .NET, and Haksell runtimes, as well as OS packages for databases like MySQL and MongoDB. For more details on what packages are cleaned up, please review the `free-disk-space` [action.yml](./action.yml) file.

## How Much Space Can be Reclaimed?

Your mileage may vary, but historically, this action has reclaimed about 21G of space on Ubuntu 22.04 GitHub runners. See: https://github.com/instructlab/instructlab/pull/2914

## When to Use it?

Example use cases below:

### "Insufficient Disk Space"

On occasion, one or more GitHub workflow jobs in your CI may encounter an "insufficient disk space" error, either on the GitHub runner side or on the EC2 runner side.

If you elect to use a GitHub-hosted runner, then [the available OS images offered through GitHub are very limited](https://github.com/actions/runner-images?tab=readme-ov-file#available-images), and unfortunately, none of those OS images are "minimal". As an example, if you want your runner to use Ubuntu as its OS, there is no such `ubuntu-minimal` image available through GitHub. You must choose either their `ubuntu-latest` offering or a specific version of Ubuntu (like `ubuntu-22.04`) that they offer, and those images tend to contain bloat in the form of OS packages like Android runtimes and databases that InstructLab does not use. Therefore, the GitHub-hosted runner image tends to have 20G of "bloat" from the InstructLab perspective.

### Reduce Cloud Expenses

Whenever an InstructLab CI job is launched in the cloud, it almost always needs to have writeable storage. If a CI job is running on an EC2 instance that launches in the cloud with a significant amount of disk space consumed by unneeded OS packages, then the total _usable_, writeable storage tends to be much less than anticipated. Rather than increasing the amount of writeable storage to compensate for this "pre-consumed" storage, you can leverage this action in your GitHub workflows to reclaim disk space.

## How to Call this Action from a Job within a GitHub Workflow 

Consider a simple job definition within a GitHub workflow file that is used to launch an EC2 instance in AWS. You would first call the GitHub `actions/checkout` action to "checkout" this action and store it locally.

Example:

```yaml
jobs:
  start-ec2-runner:
    runs-on: ubuntu-latest
    steps:

      - name: Checkout "free-disk-space" in-house CI action
        uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
        with:
          # The action is stored in this repository, so we need to tell GitHub to pull from: {org}/{repo}
          repository: instructlab/ci-actions
          # clone the "ci-actions" repo to a local directory called "ci-actions", instead of overwriting the current WORKDIR contents
          path: ci-actions
          # Only checkout the relevant GitHub action
          sparse-checkout: |
            actions/free-disk-space

      - name: Free disk space
        # Make sure to provide the relative path to `free-disk-space`
        uses: ./ci-actions/actions/free-disk-space
```