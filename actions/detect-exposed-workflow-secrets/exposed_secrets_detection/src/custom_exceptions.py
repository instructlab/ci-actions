# SPDX-License-Identifier: Apache-2.0
# pylint: disable=W0107  # Disables the pylint check for 'unnecessary pass'


class MissingTriggerConditionsError(Exception):
    "Raised when trigger conditions are not defined in a Git workflow file"

    pass


class GitWorkflowFilesNotFoundError(Exception):
    "Raised when no Git Workflow files are found"

    pass


class GitWorkflowFilesSearchError(Exception):
    "Raised when there was an issue when traversing a directory for git workflow files"

    pass


class ExposedSecretsError(Exception):
    "Raised when exposed secrets are found within a Git workflow file"

    pass
