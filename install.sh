#!/bin/bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$OSTYPE" == "darwin"* ]]; then
  exec "$DIR/install-macos.sh" "$@"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  exec "$DIR/install-ubuntu-headless.sh" "$@"
else
  echo "❌ Unsupported OS: $OSTYPE"
  echo "   Run ./install-macos.sh or ./install-ubuntu-headless.sh directly."
  exit 1
fi
