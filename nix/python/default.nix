{ pkgs, ... }: {
  # Create a Python environment with specific packages
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    # Core Python packages
    pip
    setuptools
    wheel

    # Add your project's Python dependencies here
    requests
    numpy
    pandas
    polars
    
    # Development and testing tools
    pytest
    black
    mypy
  ]);
}