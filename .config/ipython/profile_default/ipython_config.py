# IPython Configuration
# Location: ~/.config/ipython/profile_default/ipython_config.py

c = get_config()  # noqa: F821

# ============================================================================
# Dracula theme for IPython (via Pygments)
# ============================================================================
from copy import deepcopy
from IPython.utils.PyColorize import linux_theme, theme_table

dracula = deepcopy(linux_theme)
dracula.base = "dracula"
theme_table["dracula"] = dracula

c.TerminalInteractiveShell.colors = "dracula"

# ============================================================================
# 1. Suppress the "working in a virtualenv" warning
# ============================================================================
c.InteractiveShellApp.exec_lines = [
    "import warnings",
    "warnings.filterwarnings('ignore', message='.*Attempting to work in a virtualenv.*')",
]

# ============================================================================
# 2. Auto-import common libraries on startup
# ============================================================================
c.InteractiveShellApp.exec_lines.extend(
    [
        "import sys",
        "import os",
        "from pathlib import Path",
        "import json",
        "from datetime import datetime, timedelta",
        "from rich import print as rprint",
        "from rich import inspect",
        "from rich.traceback import install; install(show_locals=True)",
    ]
)

# ============================================================================
# 3. Enable autoreload magic (reloads modules automatically)
# ============================================================================
c.InteractiveShellApp.extensions = ["autoreload"]
c.InteractiveShellApp.exec_lines.extend(
    [
        "%autoreload 2",  # Reload all modules before executing code
    ]
)

# ============================================================================
# 4. Better output formatting
# ============================================================================
# c.TerminalInteractiveShell.highlighting_style = 'monokai'  # Deprecated in IPython 9.x
c.TerminalInteractiveShell.true_color = True  # Use 24-bit color
c.TerminalIPythonApp.display_banner = True  # Show the IPython banner

# ============================================================================
# 5. Prompt customization (optional - shows venv name if active)
# ============================================================================
c.TerminalInteractiveShell.prompts_class = "IPython.terminal.prompts.ClassicPrompts"

# ============================================================================
# 6. Enable rich tracebacks (better error messages)
# ============================================================================
c.InteractiveShell.xmode = "Context"  # Options: 'Plain', 'Context', 'Verbose'

# ============================================================================
# 7. Useful IPython magics to remember:
# ============================================================================
# %autoreload 2       - Auto-reload modules before executing code
# %timeit             - Time execution of a single line
# %%timeit            - Time execution of a cell
# %pdb                - Auto-start debugger on exception
# %debug              - Enter debugger after an exception
# %load_ext <module>  - Load an IPython extension
# %who / %whos        - List variables in namespace
# %reset              - Clear all variables
# %history            - Show command history
