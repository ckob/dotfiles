#!/bin/bash

# A global script for Zed to find the nearest .csproj or .sln file and run dotnet test.
# It reads Zed-specific variables ($ZED_DIRNAME, $ZED_SYMBOL) directly from the environment.
#
# Usage:
#   run_dotnet_tests.sh <mode>
#   Modes: symbol, project, solution

# --- Reusable Function ---
# Searches upwards from a starting directory for a file matching a pattern.
find_upwards() {
  local dir="$1"
  local pattern="$2"
  while [ "$dir" != "/" ]; do
    local found_file
    found_file=$(find "$dir" -maxdepth 1 -name "$pattern" -print -quit)
    if [ -n "$found_file" ]; then
      echo "$found_file"
      return 0
    fi
    dir=$(dirname "$dir")
  done
  return 1
}

# --- Mode-specific Functions ---

run_test_symbol() {
  local project_file
  project_file=$(find_upwards "$ZED_DIRNAME" "*.csproj")
  if [ -z "$project_file" ]; then
    echo "❌ Error: Could not find a .csproj file in any parent directory." >&2
    exit 1
  fi

  # Extract namespace from the current file.
  local namespace
  namespace=$(grep -E '^\s*namespace\s+.*' "$ZED_FILE" | head -n 1 | awk '{print $2}' | sed 's/;//')

  local filter
  if [ -z "$ZED_SYMBOL" ]; then
    # If ZED_SYMBOL is not set, fall back to testing the entire namespace.
    if [ -n "$namespace" ]; then
      filter="FullyQualifiedName~$namespace"
    else
      echo "❌ Error: Cursor is not on a symbol and no namespace could be found in the file." >&2
      exit 1
    fi
  else
    # ZED_SYMBOL is set, proceed with the more specific filter.
    if [ -n "$namespace" ]; then
      filter="(FullyQualifiedName~${namespace}) & (FullyQualifiedName~$ZED_SYMBOL)"
    else
      # Fallback to only using the symbol if namespace isn't found.
      filter="FullyQualifiedName~$ZED_SYMBOL"
    fi
  fi

  echo "▶️ Running: dotnet test \"$project_file\" --filter \"$filter\""
  dotnet test "$project_file" --filter "$filter"
}

run_test_project() {
  local project_file
  project_file=$(find_upwards "$ZED_DIRNAME" "*.csproj")
  if [ -n "$project_file" ]; then
    echo "▶️ Running: dotnet test \"$project_file\""
    dotnet test "$project_file"
  else
    echo "❌ Error: Could not find a .csproj file in any parent directory." >&2
    exit 1
  fi
}

run_test_solution() {
  local solution_file
  solution_file=$(find_upwards "$ZED_DIRNAME" "*.sln")
  if [ -n "$solution_file" ]; then
    echo "▶️ Running: dotnet test \"$solution_file\""
    dotnet test "$solution_file"
  else
    echo "❌ Error: Could not find a .sln file in any parent directory." >&2
    exit 1
  fi
}


# --- Main Logic ---
MODE="$1"

# Check that Zed variables are available in the environment.
if [ "$MODE" = "symbol" ] && ([ -z "$ZED_DIRNAME" ] || [ -z "$ZED_FILE" ]); then
  echo "❌ Error: ZED_DIRNAME and ZED_FILE are required for 'symbol' mode." >&2
  exit 1
elif [ -z "$ZED_DIRNAME" ]; then
   echo "❌ Error: ZED_DIRNAME not found. This script must be run from a Zed task." >&2
   exit 1
fi

case "$MODE" in
  symbol)
    run_test_symbol
    ;;
  project)
    run_test_project
    ;;
  solution)
    run_test_solution
    ;;
  *)
    echo "❌ Error: Invalid mode '$MODE'. Use 'symbol', 'project', or 'solution'." >&2
    exit 1
    ;;
esac
