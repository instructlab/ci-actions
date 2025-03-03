# Launch EC2 Runner with Fallback

## Overview

This action is used to launch an EC2 instance (EC2 runner) in AWS -- either as a spot instance or a dedicated instance. It essentially leverages the [machulav/ec2-github-runner](https://github.com/machulav/ec2-github-runner) GitHub action under the hood to launch EC2 instance in AWS, but implements "fallback logic" if one or more attempts to launch an EC2 instance fail.

## When to Use it?

### Insufficient Capacity: AWS Lacks Availablility for your Desired EC2 Instance Type in a Given Availability Zone

If one of your CI workflows attempts to launch an EC2 instance in AWS but fails due to an `InsufficientInstanceCapacity` error (aka AWS doesn't have any instances available for that instance type), you can leverage this action to try other regions as a backup.

### Cost Savings: You want to Try Launching Your EC2 Runner as a Spot Instance First

Spot instances are generally cheaper and can be sufficient for certain sitautions. Just be mindful of the implications of a spot instance. The official AWS documentation emphasizes that spot instances ["can be interrupted by Amazon EC2 when EC2 needs the capacity back."](https://docs.aws.amazon.com/whitepapers/latest/cost-optimization-leveraging-ec2-spot-instances/how-spot-instances-work.html) Thus, if your instance type is "very popular" amongst other AWS users and you can't afford to have interruptions on your EC2 instances, you should actively avoid launching your EC2 instances as spot instances.

## Which AWS Regions and Availability Zones are Supported?

The pricing for EC2 instances depends on the region, with some regions charging more money for the same instance type compared to other regions. Given that information, the currently "supported" AWS regions and availability zones for launching an EC2 instance are:

* US East 1 (Virginia) - `us-east-1`
  * `us-east-1a`
  * `us-east-1b`
  * `us-east-1c`
  * `us-east-1d`
  * `us-east-1e`
  * `us-east-1f`
* US East 2 (Ohio) - `us-east-2`
  * `us-east-2a`
  * `us-east-2b`
  * `us-east-2c`


## How to Call this Action from a Job within a GitHub Workflow 

Consider a simple job definition within a GitHub workflow file that is used to launch an EC2 instance in AWS. You would first call the GitHub `actions/checkout` action to "checkout" this action and store it locally. A list of supported inputs is provided in the next subsection, followed by an example in the following subsection.

### Supported Inputs

#### Required inputs:

| Name | Description | Example Value |
| --- | --- | --- |
| `aws-access-key-id` | AWS access key ID that will be used to launch your desired instance. | `AKIAIOSFODNN7EXAMPLE` |
| `aws-resource-tags` | Resource tags to apply to the desired AWS instance, upon successful launch. | `[{"Key": "Name", "Value": "my-runner"}]`|
| `aws-secret-access-key` | AWS secret access key that will be used to launch your desired instance. | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `ec2-instance-type` | The desired AWS instance type to use, regardless of region. (Note that some instance types are not available in certain regions.) | `g4dn.2xlarge` |
| `github-token` | GitHub Personal Access Token with the `repo` scope assigned. | `ghp_xxxxxxxxx` |
| `regions-config` | A JSON string that defines which regions and subnets to try, along with the AMIs and security groups to use within those regions. | See example in next sub-section |

#### Optional inputs:

| Name | Description | Example value |
| --- | --- | --- |
| `try-spot-instance-first` | If set to "true", then the EC2 instance will be launched as a spot instance rather than a dedicated EC2 instance. If a spot instance cannot be launched in any of the desired availability zones (e.g., due to insufficient capacity on AWS), then a dedicated instance will be tried next. (Note: This option is not always desirable for certain instance types.) | `true` |

#### `regions-config` Formatting

This input must be a valid JSON string. It is essentially a list of configuration items, where each configuration item corresponds to the configuration for launching an EC2 instance a specific AWS region. The required fields are:

| Name | Description | Example Value |
| --- | --- | --- |
| `region` | the AWS region code. (You can view [the official "Available AWS Regions" table](https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html#available-regions) to see the supported, available codes.) | `us-east-2` |
| `subnets` | a map which tells the GitHub action | - |
| `ec2-ami` | the AMI ID to use in that specific region. (Note that AMI IDs are unique to each region.) | `ami-0123456789` |
| `security-group-id` | security group ID to use when launching the EC2 instance. (Note that security group IDs are unique to each region.) | `sg-02ce123456e7893c7` |

<details>

<summary>Example individual configuration item for launching an EC2 instance in `us-east-1`</summary>

```json
{
    "region": "us-east-1",
    "subnets": {
        "us-east-1a": "${{ secrets.SUBNET_US_EAST_1A }}",
        "us-east-1b": "${{ secrets.SUBNET_US_EAST_1B }}",
        "us-east-1c": "${{ secrets.SUBNET_US_EAST_1C }}",
    },
    "ec2-ami": "${{ secrets.EC2_AMI_US_EAST_1 }}",
    "security-group-id": "${{ secrets.SECURITY_GROUP_ID_US_EAST_1 }}"
}
```
</details>

Whether you have one or more region configurations, you will need to place them in a list. For example, if you only want to launch in `us-east-1`, your `regions-config` input would be formatted like so:


<details>

<summary>Example format for `regions-config` for only 1 region</summary>

```json
[
    {
        "region": "us-east-1",
        "subnets": {
            "us-east-1a": "${{ secrets.SUBNET_US_EAST_1A }}",
            "us-east-1b": "${{ secrets.SUBNET_US_EAST_1B }}",
            "us-east-1c": "${{ secrets.SUBNET_US_EAST_1C }}",
        },
        "ec2-ami": "${{ secrets.EC2_AMI_US_EAST_1 }}",
        "security-group-id": "${{ secrets.SECURITY_GROUP_ID_US_EAST_1 }}"
    }
]
```

</details>

<details>

<summary>Example format for `regions-config` for multiple regions</summary>

```json
[
    {
        "region": "us-east-1",
        "subnets": {
            "us-east-1a": "${{ secrets.SUBNET_US_EAST_1A }}",
            "us-east-1b": "${{ secrets.SUBNET_US_EAST_1B }}",
            "us-east-1c": "${{ secrets.SUBNET_US_EAST_1C }}",
        },
        "ec2-ami": "${{ secrets.EC2_AMI_US_EAST_1 }}",
        "security-group-id": "${{ secrets.SECURITY_GROUP_ID_US_EAST_1 }}"
    },
    {
        "region": "us-east-2",
        "subnets": {
            "us-east-2a": "${{ secrets.SUBNET_US_EAST_2A }}",
            "us-east-2b": "${{ secrets.SUBNET_US_EAST_2B }}",
            "us-east-2c": "${{ secrets.SUBNET_US_EAST_2C }}",
            "us-east-2d": "${{ secrets.SUBNET_US_EAST_2D }}",
            "us-east-2e": "${{ secrets.SUBNET_US_EAST_2E }}",
        },
        "ec2-ami": "${{ secrets.EC2_AMI_US_EAST_2 }}",
        "security-group-id": "${{ secrets.SECURITY_GROUP_ID_US_EAST_2 }}"
    }
]
```

</details>

### Example Usage

```yaml
jobs:
  start-ec2-runner:
    runs-on: ubuntu-latest
    steps:

      - name: Checkout "launch-ec2-runner-with-fallback" in-house CI action
        uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
        with:
          # The action is stored in this repository, so we need to tell GitHub to pull from: {org}/{repo}
          repository: instructlab/ci-actions
          # clone the "ci-actions" repo to a local directory called "ci-actions", instead of overwriting the current WORKDIR contents
          path: ci-actions
          # Only checkout the relevant GitHub action
          sparse-checkout: |
            actions/launch-ec2-runner-with-fallback

      - name: Launch EC2 Runner with Fallback
        # Make sure to provide the relative path to `launch-ec2-runner-with-fallback`
        uses: ./ci-actions/actions/launch-ec2-runner-with-fallback
        with:
            # (OPTIONAL) Cost-savings inputs
            try-spot-instance-first: "true"
            # (REQUIRED) Authentication inputs 
            aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
            aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
            github-token: ${{ secrets.GITHUB_TOKEN }} 
            # (REQUIRED) Common EC2 instance configuration inputs
            ec2-instance-type: g4dn.2xlarge
            aws-resource-tags: >
                [
                    {"Key": "Name", "Value": "instructlab-ci-github-xlarge-runner"},
                    {"Key": "GitHubRepository", "Value": "${{ github.repository }}"},
                    {"Key": "GitHubRef", "Value": "${{ github.ref }}"},
                    {"Key": "GitHubPR", "Value": "${{ github.event.number }}"}
                ]
            # (REQUIRED) AWS regions to try launching your EC2 instance in. (If desired, you can
            #            omit one of the supported regions below. You can also omit specific
            #            subnets within those regions.)
            regions-config: >
                [
                    {
                        "region": "us-east-1",
                        "subnets": {
                            "us-east-1a": "${{ secrets.SUBNET_US_EAST_1A }}",
                            "us-east-1b": "${{ secrets.SUBNET_US_EAST_1B }}",
                            "us-east-1c": "${{ secrets.SUBNET_US_EAST_1C }}",
                        },
                        "ec2-ami": "${{ secrets.EC2_AMI_US_EAST_1 }}",
                        "security-group-id": "${{ secrets.SECURITY_GROUP_ID_US_EAST_1 }}"
                    },
                    {
                        "region": "us-east-2",
                        "subnets": {
                            "us-east-2a": "${{ secrets.SUBNET_US_EAST_2A }}",
                            "us-east-2b": "${{ secrets.SUBNET_US_EAST_2B }}",
                            "us-east-2c": "${{ secrets.SUBNET_US_EAST_2C }}",
                            "us-east-2d": "${{ secrets.SUBNET_US_EAST_2D }}",
                            "us-east-2e": "${{ secrets.SUBNET_US_EAST_2E }}",
                        },
                        "ec2-ami": "${{ secrets.EC2_AMI_US_EAST_2 }}",
                        "security-group-id": "${{ secrets.SECURITY_GROUP_ID_US_EAST_2 }}"
                    }
                ]
```

