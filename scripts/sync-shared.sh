#!/usr/bin/env bash
# Copies the shared HTTP contract from this repo (source of truth) to its
# sibling repos on disk. Run after editing packages/types or packages/shared,
# then review + commit the diff in each sibling repo like any dependency bump.
#
# Usage: ./scripts/sync-shared.sh   (run from planazo_backend)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FRONTED="$ROOT/../planazo_fronted"
CMS="$ROOT/../planazo_cms"

for dir in "$FRONTED" "$CMS"; do
  if [ ! -d "$dir" ]; then
    echo "Skipping $dir (not found next to planazo_backend)" >&2
    continue
  fi
done

if [ -d "$FRONTED" ]; then
  cp "$ROOT/packages/types/src/index.ts" "$FRONTED/packages/types/src/index.ts"
  cp "$ROOT/packages/shared/src/index.ts" "$FRONTED/packages/shared/src/index.ts"
  echo "Synced types + shared -> planazo_fronted"
fi

if [ -d "$CMS" ]; then
  cp "$ROOT/packages/types/src/index.ts" "$CMS/packages/types/src/index.ts"
  echo "Synced types -> planazo_cms (cms has no packages/shared — it doesn't use those utils)"
fi

echo ""
echo "Now review each sibling repo's diff before committing:"
echo "  git -C \"$FRONTED\" diff"
echo "  git -C \"$CMS\" diff"
