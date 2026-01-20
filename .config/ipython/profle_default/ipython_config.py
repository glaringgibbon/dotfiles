# IPython Config – HomeLab – 2026-01-18
import warnings

warnings.filterwarnings(
    "ignore", message=".*deprecated.*ipython.*", category=UserWarning
)

c = get_config()

# Pretty colors & formatting
c.TerminalInteractiveShell.highlighting_style = "monokai"
c.TerminalInteractiveShell.true_color = True

# Rich tracebacks
c.Application.verbose_crash = True

# Auto imports
c.InteractiveShellApp.exec_lines = [
    "import os, sys, json, math, pathlib",
    "from rich import print",
    "from rich.pretty import pprint",
]

# Editor
c.TerminalInteractiveShell.editor = "nvim"

# History
c.HistoryManager.enabled = True
c.HistoryManager.hist_file = "~/.local/state/ipython/history.sqlite"

# Automatically reload modules
c.InteractiveShellApp.extensions = ["autoreload"]
c.InteractiveShellApp.exec_lines.append("%autoreload 2")
