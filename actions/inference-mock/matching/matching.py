# Standard
from abc import abstractmethod
from typing import Protocol
import pprint


class Match(Protocol):
    """
    Match represnts a single prompt matching
    strategy. When a match is successful,
    the response is what should be returned.
    """

    response: str

    @abstractmethod
    def match(self, prompt: str) -> str | None:
        raise NotImplementedError


class Always:
    """
    Always is a matching strategy that always
    is a positive match on a given prompt.

    This is best used when only one prompt response
    is expected.
    """

    def __init__(self, response: str):
        self.response = response

    def match(self, prompt: str) -> str | None:
        if prompt:
            return self.response
        return None


class Contains:
    """
    Contains is a matching strategy that checks
    if the prompt string contains all of
    the substrings in the `contains` attribute.
    """

    contains: list[str]

    def __init__(self, contains: list[str], response: str):
        if not contains or len(contains) == 0:
            raise ValueError("contains must not be empty")
        self.response = response
        self.contains = contains

    def match(self, prompt: str) -> str | None:
        if not prompt:
            return None
        for context in self.contains:
            if context not in prompt:
                return None

        return self.response

# helper function pulled out for easier testing
def to_match(pattern: dict) -> Match:
    response = pattern.get("response")
    if not response:
        raise ValueError(
            f"matching strategy must have a response: {pprint.pformat(pattern, compact=True)}"
        )
    if "contains" in pattern:
        return Contains(**pattern)
    else:
        return Always(**pattern)


class Matcher:
    """
    Matcher matches prompt context and then
    selects a user provided reply.
    """

    strategies: list[Match]

    def __init__(self, matching_patterns: list[dict]):
        if not matching_patterns:
            raise ValueError(
                "matching strategies must contain at least one Match strategy"
            )

        self.strategies: list[Match] = []
        for matching_pattern in matching_patterns:
            self.strategies.append(to_match(matching_pattern))

    def find_match(self, prompt: str) -> str:
        for strategy in self.strategies:
            response = strategy.match(prompt)
            if response:
                return response
        return ""
