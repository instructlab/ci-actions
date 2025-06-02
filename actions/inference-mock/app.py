# Standard
from dataclasses import dataclass
import logging
import pprint

# Third Party
from completions.completion import create_chat_completion
from flask import Flask, request  # type: ignore[import-not-found]
from matching.matching import Matcher
from werkzeug import exceptions  # type: ignore[import-not-found]
import click  # type: ignore[import-not-found]
import yaml

# Globals
app = Flask(__name__)
strategies: Matcher  # a read only list of matching strategies


# Routes
@app.route("/v1/completions", methods=["POST"])
def completions():
    data = request.get_json()
    if not data or "prompt" not in data:
        raise exceptions.BadRequest("prompt is empty or None")

    prompt = data.get('prompt')
    prompt_debug_str = prompt
    if len(prompt) > 90:
        prompt_debug_str = data["prompt"][:90] + "..."

    app.logger.debug(
        f"{request.method} {request.url} {data['model']} {prompt_debug_str}"
    )

    chat_response = strategies.find_match(
        prompt
    )  # handle prompt and generate correct response

    response = create_chat_completion(chat_response, model=data.get("model"))
    app.logger.debug(f"response: {pprint.pformat(response, compact=True)}")
    return response


# config
@dataclass
class Config:
    matches: list[dict]
    port: int = 11434
    debug: bool = False


@click.command()
@click.option("-c", "--config", "config", type=click.File(mode="r", encoding="utf-8"), required=True, help="yaml config file")
def start_server(config):
    # get config
    yaml_data = yaml.safe_load(config)
    if not isinstance(yaml_data, dict):
        raise ValueError(f"config file {config} must be a set of key-value pairs")

    conf = Config(**yaml_data)

    # configure logger
    if conf.debug:
        app.logger.setLevel(logging.DEBUG)
        app.logger.debug("debug mode enabled")
    else:
        app.logger.setLevel(logging.INFO)

    # create match strategy object
    global strategies  # pylint: disable=global-statement
    strategies = Matcher(conf.matches)

    # init server
    app.run(debug=conf.debug, port=conf.port)


if __name__ == "__main__":
    start_server() # pylint: disable=no-value-for-parameter
