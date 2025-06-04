# e2e CI dashboard

This dashboard shows the status of our CI jobs across our four primary repositories. 

💡 Note: GitHub only schedules jobs with cron for our `main` branches. The `release-*` branches' jobs do not run in a cron schedule. (see [docs](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#schedule)).
  * As a workaround, we have begun writing secondary jobs that run against `main` and execute with the contents of a release branch. To do this, we hard-code default `pr_or_branch` input values (eg. `release-v0.26`) to `workflow_dispatch`, and then the scheduled job runs against that branch's contents. ([code](https://github.com/instructlab/instructlab/pull/3435)).

| Repository | Branch | Job |
|------------|--------|-----|
| Core | `main` | [![E2E (NVIDIA L4 x1)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-l4-x1.yml/badge.svg?branch=main)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-l4-x1.yml) |
| | | [![E2E (NVIDIA L40S x4)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-l40s-x4.yml/badge.svg?branch=main)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-l40s-x4.yml) |
| | | [![E2E (NVIDIA Tesla T4 x1)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-t4-x1.yml/badge.svg?branch=main)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-t4-x1.yml) |
| | `release-v0.26` | [![E2E (NVIDIA L4 x1)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-l4-x1.yml/badge.svg?branch=release-v0.26)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-l4-x1.yml) |
| | | [![E2E (NVIDIA L40S x4)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-l40s-x4.yml/badge.svg?branch=release-v0.26)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-l40s-x4.yml) |
| | | [![E2E (NVIDIA Tesla T4 x1)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-t4-x1.yml/badge.svg?branch=release-v0.26)](https://github.com/instructlab/instructlab/actions/workflows/e2e-nvidia-t4-x1.yml) |

| Repository | Branch | Job |
|------------|--------|-----|
| Eval | `main` | [![E2E (NVIDIA L4 x1)](https://github.com/instructlab/eval/actions/workflows/e2e-nvidia-l4-x1.yml/badge.svg?branch=main)](https://github.com/instructlab/eval/actions/workflows/e2e-nvidia-l4-x1.yml) |
| | | [![E2E (NVIDIA L40S x4)](https://github.com/instructlab/eval/actions/workflows/e2e-nvidia-l40s-x4.yml/badge.svg?branch=main)](https://github.com/instructlab/eval/actions/workflows/e2e-nvidia-l40s-x4.yml) |

| Repository | Branch | Job |
|------------|--------|-----|
| SDG | `main` | [![E2E (NVIDIA L4 x1)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-l4-x1.yml/badge.svg?branch=main)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-l4-x1.yml) |
| | | [![E2E (NVIDIA L40S x4)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-l40s-x4.yml/badge.svg?branch=main)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-l40s-x4.yml) |
| | | [![E2E (NVIDIA Tesla T4 x1)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-t4-x1.yml/badge.svg?branch=main)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-t4-x1.yml) |
| | | [![Functional GPU (NVIDIA Tesla T4 x1)](https://github.com/instructlab/sdg/actions/workflows/functional-gpu-nvidia-t4-x1.yml/badge.svg?branch=main)](https://github.com/instructlab/sdg/actions/workflows/functional-gpu-nvidia-t4-x1.yml)|
| | `release-v0.8` | [![E2E (NVIDIA L4 x1)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-l4-x1.yml/badge.svg?branch=release-v0.8)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-l4-x1.yml) |
| | | [![E2E (NVIDIA L40S x4)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-l40s-x4.yml/badge.svg?branch=release-v0.8)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-l40s-x4.yml) |
| | | [![E2E (NVIDIA Tesla T4 x1)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-t4-x1.yml/badge.svg?branch=release-v0.8)](https://github.com/instructlab/sdg/actions/workflows/e2e-nvidia-t4-x1.yml) |
| | | [![Functional GPU (NVIDIA Tesla T4 x1)](https://github.com/instructlab/sdg/actions/workflows/functional-gpu-nvidia-t4-x1.yml/badge.svg?branch=release-v0.8)](https://github.com/instructlab/sdg/actions/workflows/functional-gpu-nvidia-t4-x1.yml)|

| Repository | Branch | Job |
|------------|--------|-----|
| Training | `main` | [![E2E (NVIDIA L40S x4)](https://github.com/instructlab/training/actions/workflows/e2e-nvidia-l40s-x4.yml/badge.svg?branch=main)](https://github.com/instructlab/training/actions/workflows/e2e-nvidia-l40s-x4.yml) |
| | `release-v0.11` | [![E2E (NVIDIA L40S x4)](https://github.com/instructlab/training/actions/workflows/e2e-nvidia-l40s-x4.yml/badge.svg?branch=release-v0.11)](https://github.com/instructlab/training/actions/workflows/e2e-nvidia-l40s-x4.yml)|
| | `release-v0.10` | [![E2E (NVIDIA L40S x4)](https://github.com/instructlab/training/actions/workflows/e2e-nvidia-l40s-x4.yml/badge.svg?branch=release-v0.10)](https://github.com/instructlab/training/actions/workflows/e2e-nvidia-l40s-x4.yml)|