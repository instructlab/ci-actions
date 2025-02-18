# CI for InstructLab CI Actions

## Unit tests

Unit tests are designed to test specific GitHub action components or features in isolation. In CI, these tests are run on Python 3.11 and Python 3.10 on CPU-only Ubuntu runners. New code should always add to or update the existing unit tests. If adding/updating unit tests is not applicable, then a justification should be provided.