# Standard
from dataclasses import dataclass

# Third Party
import yaml


# config
@dataclass
class Config:
    debug: bool
    port: int
    matches: list[dict]

    def __init__(self, matches: list[dict], port: int = 11434, debug: bool = False):
        if not matches:
            raise ValueError("matches must not be empty")
        self.port = port
        self.debug = debug
        self.matches = matches

    @staticmethod
    def from_file(config_file) -> "Config":
        """
        Create a Server instance from a config file.
        :param config_file: path to the config file
        :return: Server instance
        """
        yaml_data = yaml.safe_load(config_file)
        if not isinstance(yaml_data, dict):
            raise ValueError(
                f"config file {config_file} must be a set of key-value pairs"
            )

        return Config(**yaml_data)
