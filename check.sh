#!/usr/bin/env bash
# Pre-publish gate for the jdsaa.com site.
# Usage: ./check.sh <site-dir>
# Verifies the things an Apple Developer Program reviewer checks, plus that no
# unfilled template placeholder is about to go live.

set -u

SITE="${1:-}"
if [ -z "$SITE" ] || [ ! -d "$SITE" ]; then
  echo "usage: $0 <site-dir>" >&2
  exit 2
fi

SITE="$(cd "$SITE" && pwd)"
echo "Checking site at: $SITE"
echo

PAGES="index.html services.html products.html about.html contact.html"
LEGAL="JD Software Architecture Analytics AB"
EMAIL="joakim.dahlstedt@jdsaa.com"
fail=0

for p in $PAGES; do
  if [ ! -f "$SITE/$p" ]; then
    echo "FAIL  missing page: $p"
    fail=1
  fi
done

# 1. No unfilled placeholders anywhere.
hits="$(grep -rl '{{' "$SITE" --include='*.html' 2>/dev/null || true)"
if [ -n "$hits" ]; then
  echo "FAIL  unfilled {{PLACEHOLDER}} tokens in:"
  echo "$hits" | sed 's/^/        /'
  echo "      -> fill in org number and registered address before publishing"
  fail=1
else
  echo "ok    no unfilled placeholders"
fi

# 2. Legal entity name on every page (Apple matches this against D&B).
missing=""
for p in $PAGES; do
  [ -f "$SITE/$p" ] || continue
  grep -qF "$LEGAL" "$SITE/$p" || missing="$missing $p"
done
if [ -n "$missing" ]; then
  echo "FAIL  legal name '$LEGAL' missing from:$missing"
  fail=1
else
  echo "ok    legal name present on all $(echo $PAGES | wc -w) pages"
fi

# 3. Contact email on the company domain, on every page.
missing=""
for p in $PAGES; do
  [ -f "$SITE/$p" ] || continue
  grep -qF "$EMAIL" "$SITE/$p" || missing="$missing $p"
done
if [ -n "$missing" ]; then
  echo "FAIL  contact email missing from:$missing"
  fail=1
else
  echo "ok    contact email ($EMAIL) present on all pages"
fi

# 4. CNAME must name the apex domain GitHub Pages will serve.
if [ -f "$SITE/CNAME" ] && [ "$(tr -d '[:space:]' < "$SITE/CNAME")" = "jdsaa.com" ]; then
  echo "ok    CNAME = jdsaa.com"
else
  echo "FAIL  CNAME missing or does not contain exactly 'jdsaa.com'"
  fail=1
fi

# 5. Rough content-volume guard against Apple's "minimal content" rejection.
words="$(cat "$SITE"/*.html 2>/dev/null | sed 's/<[^>]*>//g' | wc -w)"
echo "info  approx. ${words} words of visible copy across the site"
if [ "$words" -lt 400 ]; then
  echo "FAIL  too thin -- Apple rejects 'websites that contain minimal content'"
  fail=1
fi

echo
if [ "$fail" -eq 0 ]; then
  echo "PASS  $SITE is ready to publish"
else
  echo "FAILED  $SITE is NOT ready to publish"
fi
exit "$fail"
