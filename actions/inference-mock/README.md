# Inference Mock

## Overview

Inference Mock is a tool that creates a flask server that runs as a background process. OpenAI comptabile calls can be made to its completions API.
Based on how the server is configured, it will send a set of programmed resposnes back.

## When to Use it?

Testing notebooks is difficult to do since you often don't write functions or unit tests in them. Instead, if you want to mock an LLM call and response,
this is an easy way to rig that up in your testing environment. This is best used for integration, unit, and smoke tests. This is obviously not a real
inference service, so its best used for testing code that makes occasional calls to an LLM to do a task.

## Usage

This is a reusable workflow, and can be referenced and used in any github actions workflow. First, you will need to make a config file. You can set the following fields:

```yaml
# debug: enable debug logging and debug mode in flask
# optional: this defaults to False
debug: True

# port: the port the server will listen on
# optional: this defaults to 11434
port: 11343

# matches: a list of matching strategies for expected sets of prompt response pairs. The following strategies are available:
#   - contains: accepts a list of substrings. All incoming prompts will need to contain all listed substrings for this match to be positive
#   - response: passing only a response is an `Always` match strategy. If no other strategy has matched yet, this will always be a positive match.
#
# note: the strategies are executed in the order listed, and the first succesful match is accepted. If you start with an `Always` strategy, its 
# response will be the only resposne returned.
matches:

    # this is an example of a `contains` strategy. If the prompt contains the substrings, it returns the response.
  - contains:
      - 'I need you to generate three questions that must be answered only with information contained in this passage, and nothing else.'
    response: '{"fact_single": "What are some common ways to assign rewards to partial answers?", "fact_single_answer": "There are three: prod, which takes the product of rewards across all steps; min, which selects the minimum reward over all steps; and last, which uses the reward from the final step.", "reasoning": "What is the best method for rewarding models?", "reasoning_answer": "That depends on whether the training data is prepared using MC rollout, human annotation, or model annotation.", "summary": "How does QWEN implement model reward?", "summary_answer": "Qwen computes the aggregate reward based on the entire partial reward trajectory. I also uses a method that feeds the performance reference model with partial answers, then only considering the final reward token."}'

    # this is an example of an `Always` strategy. It will always match, and return this response.
  - response: "hi I am the default response"
```

This config must be passed to this action as an input. Here is an example of a workflow that invokes this action to create a mock server.

```yaml
jobs:
  example-job:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout "inference-mock" in-house CI action
        uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
        with:
          repository: instructlab/ci-actions
          path: ci-actions
          sparse-checkout: |
            actions/inference-mock
      - name: Inference Mock
        uses: ./ci-actions/actions/inference-mock
        with:
          config: "example-config.yml"
```
