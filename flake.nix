{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # If you need bleeding edge python packages or specific python versions,
    # consider overlaying a newer nixpkgs or using a python-packages input.
    # For simplicity, this template uses the nixpkgs-unstable channel for both system tools and python.
    # You can explore other channels or specific commits if needed.
    # For example:
    # nixpkgs-pinned.url = "github:NixOS/nixpkgs/nixpkgs-23.11"; # Example of a pinned channel

    # You could also add inputs for specific tools if you want to manage their versions separately.
    # For example:
    # poetry-nix.url = "github:python-poetry/poetry-nix";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux"; # Define the target system for the flake.
      pkgs = nixpkgs.legacyPackages.${system};

      # Import the python environment configuration from the ./nix/python.nix file.
      # We pass 'pkgs' so that the python module can access nixpkgs functions.
      pythonConf = import ./nix/python { inherit pkgs; };

      # Import the development tools configuration from the ./nix/tools.nix file.
      # We pass 'pkgs' so that the tools module can access nixpkgs functions.
      devToolsConf = import ./nix/tools { inherit pkgs; };

    in
    {
      # Define the default development shell. This shell will contain:
      #  - The python environment defined in nix/python.nix
      #  - Development tools defined in nix/tools.nix
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pythonConf.pythonEnv # Include the python environment
        ] ++ devToolsConf.devTools; # Include development tools

        # Optional: Define environment variables that should be set in the dev shell.
        # env = {
        #   MY_CUSTOM_VAR = "some_value";
        # };

        # Optional: Define a shellHook to run commands when entering the dev shell.
        #           This is useful for displaying helpful messages or setting up the environment further.
        shellHook = ''
          echo "Welcome to the Nix development shell!"
          echo "Python environment with packages from nix/python.nix is ready."
          echo "Development tools from nix/tools.nix (uv, ruff, poetry) are available."
          echo " "
          echo "To activate the Python environment, you don't need to do anything special."
          echo "Just use 'python' or 'pip' in this shell, and it will use the Nix-provided environment."
          echo " "
          echo "Development Tools:"
          echo " - 'uv': Fast Python package installer and resolver (use 'uv pip install ...')."
          echo " - 'ruff': Extremely fast Python linter, formatter, and more (use 'ruff check .', 'ruff format .')."
          echo " - 'poetry': Python dependency and package manager (use 'poetry install', 'poetry add ...')."
          echo " "
          echo "Project Root: ${self.projectRoot or ./.}" # Shows the project root directory.
        '';
      };
    };
}
