from flask import Flask, request # type: ignore[import-not-found]
from werkzeug import exceptions # type: ignore[import-not-found]

from completions.completion import create_chat_completion
from dataclasses import dataclass
from matching.matching import Matcher

import click # type: ignore[import-not-found]
import logging
import pprint
import yaml


# Globals
app = Flask(__name__)


# Routes
@app.route('/v1/completions', methods=['POST'])
def completions():
    data = request.get_json()
    if not data or 'prompt' not in data:
        raise exceptions.BadRequest("prompt is empty or None")

    prompt_debug_str = data['prompt'][:90] + "..."
    logger.debug(f"{request.method} {request.url} {data['model']} {prompt_debug_str}")

    prompt = data.get('prompt')
    chat_response = strategies.find_match(prompt)  # handle prompt and generate correct response

    response = create_chat_completion(chat_response, model=data.get('model'))
    logger.debug(f"response: {pprint.pformat(response, compact=True)}")
    return response


# config
@dataclass
class Config:
    matches: list[dict]
    port: int = 11434
    debug: bool = False


@click.command()
@click.option("--config", type=click.Path(), required=True, help='path to a YAML config file containing detailed configuration and model response options')
def start_server(config):
    # globals
    global logger
    global strategies

    # get config
    with open(config, 'r', encoding="utf-8") as file:
        yaml_data = yaml.safe_load(file)
    if not isinstance(yaml_data, dict):
        raise ValueError("config file format is invalid")

    conf = Config(**yaml_data)

    # set globals
    strategies = Matcher(conf.matches)
    logger = logging.getLogger(__name__)
    if conf.debug:
        logging.basicConfig(level=logging.DEBUG, format='%(message)s')
    else:
        logging.basicConfig(level=logging.INFO, format='%(message)s')

    # init server
    app.run(debug=conf.debug, port=conf.port)


if __name__ == '__main__':
    start_server()
