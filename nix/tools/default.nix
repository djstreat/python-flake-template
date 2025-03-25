{ pkgs, ... }: {
  # Define the list of development tools
  devTools = with pkgs; [
    # Python-related tools
    uv         # Fast Python package installer
    ruff       # Python linter and formatter
    poetry     # Python dependency management

    # General development tools
    git
    curl
    wget
    jq
  ];
}