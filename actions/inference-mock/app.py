# Standard
import logging
import pprint

# Third Party
from completions.completion import create_chat_completion
from config import Config
from flask import Flask, request  # type: ignore[import-not-found]
from matching.matching import Matcher
from werkzeug import exceptions  # type: ignore[import-not-found]
import click  # type: ignore[import-not-found]

# Globals
app = Flask(__name__)
strategies: Matcher  # a read only list of matching strategies


# Routes
@app.route("/v1/completions", methods=["POST"])
def completions():
    data = request.get_json()
    if not data or "prompt" not in data:
        raise exceptions.BadRequest("prompt is empty or None")

    prompt = data.get("prompt")
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


def start_server(config: Config):
    # configure logger
    if config.debug:
        app.logger.setLevel(logging.DEBUG)
        app.logger.debug("debug mode enabled")
    else:
        app.logger.setLevel(logging.INFO)

    # create match strategy object
    global strategies  # pylint: disable=global-statement
    strategies = Matcher(config.matches)

    # init server
    app.run(debug=config.debug, port=config.port)


@click.command()
@click.option(
    "-c",
    "--config",
    "config_file",
    type=click.File(mode="r", encoding="utf-8"),
    required=True,
    help="yaml config file",
)
def start_server_cli(config_file):
    config = Config.from_file(config_file)
    start_server(config)


if __name__ == "__main__":
    start_server_cli()  # pylint: disable=no-value-for-parameter
