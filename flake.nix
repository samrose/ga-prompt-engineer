{
  description = "Development environment with Ollama and Livebook";

  inputs = {
    # Use the latest stable nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Flake utils provides useful functions for system-specific outputs
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # Allow unfree packages (needed for some dependencies)
          config.allowUnfree = true;
        };

        # Define platform-specific dependencies
        platformDeps = with pkgs; [
          # Basic development tools
          git
          curl

          # Ollama dependencies
          ollama
          nvidia-docker  # For GPU support if available

          # Elixir and Livebook dependencies
          beam.packages.erlangR27.elixir
          livebook
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = platformDeps;

          # Environment variables
          shellHook = ''
            echo "📚 Development environment loaded with Ollama and Livebook"
            echo ""
            echo "🚀 Quick start:"
            echo "  • Start Ollama:  ollama serve"
            echo "  • Start Livebook: livebook server"
            echo ""
            echo "📝 Common Ollama commands:"
            echo "  • Pull a model:   ollama pull <model>"
            echo "  • List models:    ollama list"
            echo "  • Remove a model: ollama rm <model>"
            echo ""
            # Set any necessary environment variables
            export LIVEBOOK_PORT=8080
            export OLLAMA_HOST=localhost:11434
          '';
        };
      }
    );
}