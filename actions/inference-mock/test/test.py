# Third Party
from matching.matching import Always, Contains, Matcher, to_match
import pytest


class TestAlways:
    # match on any prompt
    def test_always(self):
        expect_response = "expected response"
        prompt = "example prompt"
        always = Always(expect_response)
        actual_response = always.match(prompt)
        assert actual_response == expect_response

    # reject empty prompts
    def test_always_empty_prompt(self):
        response = "expected response"
        prompt = ""
        always = Always(response)
        actual_response = always.match(prompt)
        assert actual_response is None


class TestContains:
    def test_contains(self):
        expect_response = "expected response"
        prompt = "example prompt"
        match_on = ["example"]
        contains = Contains(match_on, expect_response)
        actual_response = contains.match(prompt)
        assert actual_response == expect_response

    def test_contains_many(self):
        expect_response = "expected response"
        prompt = "a much longer example prompt so we can match on many substring elements of this string"
        match_on = ["example", "many substring elements", "match on"]
        contains = Contains(match_on, expect_response)
        actual_response = contains.match(prompt)
        assert actual_response == expect_response

    # if any substrings don't match, return None
    def test_contains_mismatch(self):
        response = "expected response"
        prompt = "a much longer example prompt so we can match on many substring elements of this string"
        match_on = ["example", "many substring elements", "match on", "banana"]
        contains = Contains(match_on, response)
        actual_response = contains.match(prompt)
        assert actual_response is None

    # reject empty prompts
    def test_contains_empty(self):
        response = "expected response"
        prompt = ""
        match_on = ["example"]
        contains = Contains(match_on, response)
        actual_response = contains.match(prompt)
        assert actual_response is None


class TestMatcher:
    def test_to_contains(self):
        response = "I am a response"
        substr = ["a", "b", "c"]
        pattern = {"contains": substr, "response": response}
        contains = to_match(pattern)
        assert isinstance(contains, Contains)
        assert contains.response == response

    def test_to_always(self):
        response = "I am a response"
        always_pattern = {"response": response}
        always = to_match(always_pattern)
        assert isinstance(always, Always)
        assert always.response == response

    def test_to_invalid(self):
        response = "I am a response"
        invalid_pattern = {"banana": "foo", "response": response}
        with pytest.raises(TypeError):
            to_match(invalid_pattern)

    def test_find_match_contains(self):
        expect_response = "I am a response"
        substr = ["example", "p"]
        patterns = [{"contains": substr, "response": expect_response}]
        matcher = Matcher(patterns)

        prompt = "example prompt"
        actual_response = matcher.find_match(prompt)
        assert actual_response == expect_response

    def test_find_match_always(self):
        expect_response = "I am a response"
        patterns = [{"response": expect_response}]
        matcher = Matcher(patterns)

        prompt = "example prompt"
        actual_response = matcher.find_match(prompt)
        assert actual_response == expect_response

    # test that order is preserved and responses fall back until a match or end of strategies
    def test_find_match_fallback(self):
        patterns = [
            {
                "contains": ["this is the fallback response"],
                "response": "a response you will not get",
            },
            {"response": "this is the fallback response"},
        ]
        matcher = Matcher(patterns)
        always_response = matcher.find_match(prompt="example prompt")
        assert always_response == "this is the fallback response"
        contains_response = matcher.find_match(prompt="this is the fallback response")
        assert contains_response == "a response you will not get"
