# Machine-Specific ZSH Configuration

This directory contains configuration files that are specific to individual machines in your homelab. These files are designed to be excluded from version control (via `.gitignore`) so that each machine can have its own tailored settings without affecting other systems.

## Available Configuration Files

### `before.zsh`

This file is sourced **before** the main ZSH configuration loads. Use it for:

- Setting machine-specific environment variables
- Adding directories to PATH
- Setting proxy configurations
- Defining hardware-specific settings
- Any configuration that needs to be available to the core ZSH configuration

### `after.zsh`

This file is sourced **after** all other ZSH configurations have loaded. Use it for:

- Overriding aliases, functions, or settings from the main configuration
- Loading machine-specific plugins
- Setting up completions specific to this machine
- Adding custom welcome messages
- Any configuration that should take precedence over the default settings

## Usage Instructions

1. Copy the template files to create your machine-specific configurations:
   ```bash
   cp before.zsh.template before.zsh
   cp after.zsh.template after.zsh
   ```

2. Edit these files to add your machine-specific settings.

3. These files are automatically loaded by the `.zshrc` file if they exist.

## Best Practices

- Keep machine-specific configurations minimal and focused
- Comment your configurations thoroughly
- Group related settings together
- Use conditional logic to test for the existence of tools before configuring them
- Consider creating subdirectories for complex machine-specific settings

## Example: Role-Based Configuration

For machines with specific roles in your homelab, you might want to create role-specific files:

```
$XDG_CONFIG_HOME/zsh/local/
├── before.zsh                # Common machine-specific settings
├── after.zsh                 # Common machine-specific overrides
├── roles/                    # Role-specific settings
│   ├── server.zsh            # For server machines
│   ├── workstation.zsh       # For workstation/desktop machines
│   └── raspberry-pi.zsh      # For Raspberry Pi devices
```

Then in your `after.zsh`, you can source the appropriate role file:

```bash
# Load role-specific configuration
if [[ "$HOSTNAME" == *server* ]]; then
  source "${XDG_CONFIG_HOME}/zsh/local/roles/server.zsh"
elif [[ "$HOSTNAME" == *pi* ]]; then
  source "${XDG_CONFIG_HOME}/zsh/local/roles/raspberry-pi.zsh"
else
  source "${XDG_CONFIG_HOME}/zsh/local/roles/workstation.zsh"
fi
```

This approach allows for flexible configuration based on the machine's role in your homelab environment.

## Note About Version Control

The `before.zsh` and `after.zsh` files should be added to your `.gitignore` file to prevent them from being committed to your repository. Instead, the template files serve as documentation and starting points for machine-specific configuration.
