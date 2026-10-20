#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR/test"

if [ ! -d "$TEST_DIR" ]; then
  echo "Error: test directory not found at $TEST_DIR"
  exit 1
fi

echo "Running 'shalom generate -f' across test directories in $TEST_DIR..."

failed_dirs=()

for dir in "$TEST_DIR"/*/; do
  [ -d "$dir" ] || continue
  dir_name="$(basename "$dir")"

  # Only run if directory has schema file(s)
  if [ -f "$dir/schema.graphql" ] || [ -f "$dir/schema.gql" ]; then
    echo "==> Running in $dir_name..."
    if ! (cd "$dir" && shalom generate -f); then
      echo "❌ Failed in $dir_name"
      failed_dirs+=("$dir_name")
    fi
  else
    echo "⏭️  Skipping $dir_name (no schema.graphql or schema.gql found)"
  fi
done

echo ""
if [ ${#failed_dirs[@]} -eq 0 ]; then
  echo "✅ All directories generated successfully!"
else
  echo "❌ Errors occurred in the following directories:"
  for d in "${failed_dirs[@]}"; do
    echo "  - $d"
  done
  exit 1
fi
