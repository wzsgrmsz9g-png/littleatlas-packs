#!/usr/bin/env bash
# Refuse private app data, photo binaries, and secret-shaped strings before a push.
# Photos belong on the packs GitHub Release, not in git.
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
while IFS= read -r f; do
  [ -f "$f" ] || continue
  case "$f" in
    *atlas.zip*|*atlas.zip.part*) echo "refused private catalog: $f"; fail=1 ;;
    *.pbf|*.webp|*.tar|*.tar.tmp) echo "refused binary (photos and extracts stay off git): $f"; fail=1 ;;
  esac
  bytes=$(wc -c < "$f" | tr -d ' ')
  if [ "$bytes" -gt 20000000 ]; then
    echo "refused file over 20 MB: $f ($bytes bytes)"
    fail=1
  fi
done < <(git ls-files)
if git grep -I -n -E 'ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|xox[baprs]-|sk_live_' -- . ':!scripts/guard.sh' ':!.github/workflows/guard.yml'; then
  echo "refused: secret-shaped string"
  fail=1
fi
if [ "$fail" -ne 0 ]; then
  exit 1
fi
echo "guard: ok"
