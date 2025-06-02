# mock openAI completion responses
# credit: https://github.com/openai/openai-python/issues/715#issuecomment-1809203346
# License: MIT

# Standard
import random


# TODO: use a library to return and validate completions so this doesn't need to be maintained
def create_chat_completion(content: str, model: str = "gpt-3.5") -> dict:
    response = {
        "id": "chatcmpl-2nYZXNHxx1PeK1u8xXcE1Fqr1U6Ve",
        "object": "chat.completion",
        "created": "12345678",
        "model": model,
        "system_fingerprint": "fp_44709d6fcb",
        "choices": [
            {
                "text": content,
                "content": content,
                "index": 0,
                "logprobs": None,
                "finish_reason": "length",
            },
        ],
        "usage": {
            "prompt_tokens": random.randint(10, 500),
            "completion_tokens": random.randint(10, 500),
            "total_tokens": random.randint(10, 500),
        },
    }

    return response
