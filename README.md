# CI Actions

## Contents
- [📙 Overview of this Repository](#-overview-of-this-repository)
- [👊 Available In-House GitHub Actions](#-available-in-house-github-actions)
- [❓ How to Use One or More In-House GitHub actions](#-how-to-use-one-or-more-in-house-github-actions)
- [📬 Contributing](#-contributing)

## 📙 Overview of this Repository

This repository contains reusable, in-house GitHub actions that are specific to the InstructLab org. None of the GitHub actions provided here will be published to the GitHub Marketplace, but if you would like to use these actions in your own GitHub repo or org, feel free to use them as you see fit.

## 👊 Available In-House GitHub Actions

Below is a list of the in-house GitHub actions stored in this repository:

| Name | Description | Example Use Cases |
| --- | --- | --- |
| [detect-exposed-workflow-secrets](./actions/detect-exposed-workflow-secrets/detect-exposed-workflow-secrets.md) | Used to detect when a contributor's PR would expose a GitHub secret through one or more workflow files that auto-trigger on PRs, and aborts that contributor's PR build before it can start. | <ul><li>Prevent accidental secrets exposure through GitHub workflow files that auto-trigger on PR builds.</li></ul> |
| [free-disk-space](./actions/free-disk-space/free-disk-space.md) | Used to reclaim disk space on either a GitHub or EC2 runner. | <ul><li>If a CI job tends to fail due to "insufficient disk space"</li><li>If you want to reduce cloud costs by reclaiming disk space instead of increasing your writeable cloud storage to compensate for a bloated EC2 image</li></ul> |
| [launch-ec2-runner-with-fallback](./actions/launch-ec2-runner-with-fallback/launch-ec2-runner-with-fallback.md) | Used launch an EC2 instance in AWS, either as a spot instance or a dedicated instance. If your preferred availability zone lacks availability for your instance type, "backup" availability zones will be tried. | <ul><li>Insufficient capacity in AWS (i.e., AWS lacks availablility for your desired EC2 instance type in your preferred availability zone)</li><li>Cost savings (i.e., You want to try launching your EC2 runner as a spot instance first)</li></ul> |
| [validate-notebooks](./actions/launch-ec2-runner-with-fallback/launch-ec2-runner-with-fallback.md) | Used to validate `.ipynb` files | <ul><li>I maintain a collection of `.ipynb` files and run ci jobs to test them. I  would like to quickly verify that the files are formatted correctly before spinning up more complex or expensive CI jobs to test those notebooks.</li></ul>

## ❓ How to Use One or More In-House GitHub Actions

Each GitHub action in this repository contains documentation explaining how to reference and use it in another repo.

## 📬 Contributing

Check out our [contributing](CONTRIBUTING/CONTRIBUTING.md) guide to learn how to contribute.