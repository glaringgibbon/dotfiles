# $XDG_CONFIG_HOME/zsh/functions/poetry.zsh
# # TODO: Future Enhancements
# - Add project template support
# - implement dependency analysis functions
# - consider uv migration path
# - add pyenv integration

# helper function to setup direnv
_poetry_setup_direnv() {
    if [[ ! -f ".envrc" ]]; then
        echo "use pyenv" > .envrc
        echo "layout poetry" >> .envrc
        direnv allow .
    fi
}

# create new poetry project
poetry_new() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: poetry_new <project-name>"
        return 1
    fi
    
    poetry new "$1" && cd "$1" && _poetry_setup_direnv
}

# Initialize existing project with Poetry
poetry_init() {
    if [[ ! -f "pyproject.toml" ]]; then
        poetry init && _poetry_setup_direnv
    else
        echo "Project already initialized with Poetry"
    fi
}

# Manage virtual environments
poetry_venv() {
    local venv_base="${HOME}/projects/venvs/poetry"
    local cmd="$1"
    shift

    case "$cmd" in
        list)
            # List all poetry venvs with their associated projects
            echo "Poetry Virtual Environments:"
            echo "----------------------------"
            for venv in ${venv_base}/*/; do
                if [[ -f "${venv}/poetry.toml" ]]; then
                    local project_name=$(grep "name" "${venv}/poetry.toml" | cut -d'"' -f2)
                    echo "${venv##*/} -> $project_name"
                else
                    echo "${venv##*/} (no project info)"
                fi
            done
            ;;
        clean)
            # Remove orphaned venvs (no associated active project)
            local count=0
            for venv in ${venv_base}/*/; do
                if [[ ! -f "${venv}/poetry.toml" ]]; then
                    echo "Removing orphaned venv: ${venv##*/}"
                    rm -rf "$venv"
                    ((count++))
                fi
            done
            echo "Cleaned $count orphaned virtual environment(s)"
            ;;
          prune)
            # Remove venvs unused for X days, but ask for confirmation
            local days=${1:-30}
            local to_remove=()
            
            echo "Checking for virtual environments unused for $days days..."
            for venv in ${venv_base}/*/; do
                if [[ -d "$venv" ]] && [[ ! -f "${venv}/poetry.toml" ]] && \
                  [[ $(find "$venv" -maxdepth 0 -type d -mtime +$days) ]]; then
                    to_remove+=("$venv")
                    echo "Found inactive venv: ${venv##*/} (not used in $days days)"
                fi
            done
            
            if (( ${#to_remove[@]} )); then
                echo "\nFound ${#to_remove[@]} inactive environment(s)"
                read -q "REPLY?Do you want to remove these environments? (y/N) "
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    for venv in "${to_remove[@]}"; do
                        echo "Removing: ${venv##*/}"
                        rm -rf "$venv"
                    done
                    echo "Pruned ${#to_remove[@]} virtual environment(s)"
                else
                    echo "Operation cancelled"
                fi
            else
                echo "No inactive environments found"
            fi
            ;;
    esac
}

# Update all Poetry projects
poetry_update_all() {
    local projects_dir="${HOME}/projects"
    local count=0
    
    echo "Searching for Poetry projects..."
    for project in $(find "$projects_dir" -name "pyproject.toml"); do
        local project_dir=$(dirname "$project")
        echo "\nUpdating project in: $project_dir"
        (cd "$project_dir" && poetry update)
        ((count++))
    done
    echo "\nUpdated $count project(s)"
}
