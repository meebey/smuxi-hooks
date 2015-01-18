#!/usr/bin/python2

import yaml
from Globals import *

config = None

def load():
    global config
    try:
        with open(CONFIG_FILE_PATH) as rf:
            config = yaml.load(rf)
    except (IOError, OSError):
        raise ConfigError("Could not find `{}'".format(CONFIG_FILE_PATH))

