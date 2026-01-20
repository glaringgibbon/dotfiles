# HomeLab Python REPL Enhancements – 2026-01-18

import sys
import readline
import rlcompleter
import atexit
from rich.console import Console
from rich.traceback import install as rich_traceback

# Pretty tracebacks
rich_traceback(show_locals=True)

# Console for pretty printing
console = Console()


def pp(value):
    console.print(value)


# Tab completion
readline.parse_and_bind("tab: complete")

# History file
import os

histfile = os.path.expanduser("~/.local/state/python/history")
os.makedirs(os.path.dirname(histfile), exist_ok=True)

try:
    readline.read_history_file(histfile)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)

# Prompt
sys.ps1 = "\033[38;5;81m>>> \033[0m"
sys.ps2 = "\033[38;5;39m... \033[0m"

# Autocomplete globals
import builtins

builtins.pp = pp
