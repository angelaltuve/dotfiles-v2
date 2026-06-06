#!/bin/sh
url="$1"
[ -z "$url" ] && exit 1

html="$(curl -sfLk "$url" 2>/dev/null)"
[ -z "$html" ] && exit 1

title="$(echo "$html" | sed -n 's/.*<title>[[:space:]]*\(.*\)[[:space:]]*<\/title>.*/\1/p' | head -1)"
[ -z "$title" ] && title="$url"

slug="$(echo "$title" | sed 's/[^a-zA-Z0-9 ]//g; s/  */ /g; s/^ *//; s/ *$//')"
[ -z "$slug" ] && slug="bookmark-$(date +%s)"

file="$HOME/Docs/work/2_source_material/clippings/${slug}.md"
date="$(date '+%Y-%m-%d')"
content="$(echo "$html" | html2text --no-wrap-links --ignore-links --body-width 0 2>/dev/null | head -100)"

printf '%s\n' "# $title" > "$file"
printf '%s\n' "" >> "$file"
printf '%s\n' "URL: $url" >> "$file"
printf '%s\n' "Added: $date" >> "$file"
printf '%s\n' "" >> "$file"
printf '%s\n' "---" >> "$file"
printf '%s\n' "" >> "$file"
printf '%s' "$content" >> "$file"
