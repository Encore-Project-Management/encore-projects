#!/usr/bin/env bash
# Copies the publishable site files into an output folder.
#
#   .github/scripts/build-site.sh <output-folder> prod
#   .github/scripts/build-site.sh <output-folder> staging
#
# "staging" also adds a noindex tag and a STAGING banner to every HTML page.
# "prod" fails if either of those is found, so they can never go live.
set -euo pipefail

OUT="${1:?usage: build-site.sh <output-folder> prod|staging}"
MODE="${2:?usage: build-site.sh <output-folder> prod|staging}"

ROBOTS_TAG='<meta name="robots" content="noindex, nofollow">'
BANNER='<div id="staging-banner" style="position:fixed;left:0;bottom:0;z-index:9999;padding:4px 12px;background:#b00020;color:#fff;font:700 12px/1.4 Arial,sans-serif;letter-spacing:.1em;border-top-right-radius:6px;pointer-events:none">STAGING</div>'

# Things that are never published.
EXCLUDES=(
  --exclude './.git'
  --exclude './.github'
  --exclude './_wix-export'
  --exclude '*.md'
  --exclude './.gitignore'
  --exclude '.DS_Store'
  --exclude "./${OUT#./}"
)

case "$MODE" in
  prod) ;;
  staging)
    # Staging has no custom domain and must not advertise itself to search engines.
    EXCLUDES+=(--exclude './CNAME' --exclude './robots.txt' --exclude './sitemap.xml')
    ;;
  *) echo "Unknown mode: $MODE (use prod or staging)" >&2; exit 1 ;;
esac

rm -rf "$OUT"
mkdir -p "$OUT"
tar -c "${EXCLUDES[@]}" . | tar -x -C "$OUT"

mapfile -t PAGES < <(find "$OUT" -name '*.html' | sort)
if [ "${#PAGES[@]}" -eq 0 ]; then
  echo "No HTML pages found in $OUT" >&2
  exit 1
fi

if [ "$MODE" = "staging" ]; then
  touch "$OUT/.nojekyll"
  for page in "${PAGES[@]}"; do
    sed -i "0,/<head>/s||<head>\n  ${ROBOTS_TAG}|" "$page"
    sed -i "0,/<body[^>]*>/s||&\n  ${BANNER}|" "$page"
    grep -q 'name="robots" content="noindex, nofollow"' "$page" || { echo "noindex tag missing from $page" >&2; exit 1; }
    grep -q 'id="staging-banner"' "$page" || { echo "STAGING banner missing from $page" >&2; exit 1; }
  done
else
  # Safety check: production must never contain the staging markers.
  if grep -rIl -e 'noindex' -e 'staging-banner' "$OUT"; then
    echo "Staging markers found in the production build (files listed above)." >&2
    exit 1
  fi
fi

echo "Built $MODE site in $OUT (${#PAGES[@]} HTML pages):"
(cd "$OUT" && find . -type f | sort)
