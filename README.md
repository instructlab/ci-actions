# CI Actions

## Contents
- [📙 Overview of this Repository](#-overview-of-this-repository)
- [👊 Available In-House GitHub Actions](#-available-in-house-github-actions)
- [📬 Contributing](#-contributing)

## 📙 Overview of this Repository

This repository contains reusable, in-house GitHub actions that are specific to the InstructLab org. None of the GitHub actions provided here will be published to the GitHub Marketplace, but if you would like to use these actions in your own GitHub repo or org, feel free to use them as you see fit.

## 👊 Available In-House GitHub Actions

Below is a list of the in-house GitHub actions stored in this repository:

| Name | Description | Example Use Cases |
| --- | --- | --- |
| [free-disk-space](./actions/free-disk-space/free-disk-space.md) | Used to reclaim disk space on either a GitHub or EC2 runner. | <ul><li>If a CI job tends to fail due to "insufficient disk space"</li><li>If you want to reduce cloud costs by reclaiming disk space instead of increasing your writeable cloud storage to compensate for a bloated EC2 image</li></ul> |

## How to Use One or More In-House GitHub Actions

Each GitHub action in this repository contains documentation explaining how to reference and use it in another repo.

## Contributing

Check out our [contributing](CONTRIBUTING/CONTRIBUTING.md) guide to learn how to contribute.