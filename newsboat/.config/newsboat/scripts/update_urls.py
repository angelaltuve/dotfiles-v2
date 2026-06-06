#!/usr/bin/env python3
"""Verifica y actualiza URLs del archivo urls de newsboat.
Sigue redirects, detecta feeds muertos, reporta errores.
Los feeds de YouTube suelen dar 404/500 por rate limiting,
  se reintentan automaticamente.

Uso:
  python3 update_urls.py              # modo seco: solo reporta
  python3 update_urls.py --write      # escribe urls actualizado
  python3 update_urls.py --retry N    # max reintentos por URL (def: 2)
"""

import argparse
import os
import re
import sys
import time
import urllib.error
import urllib.request
from dataclasses import dataclass, field
from pathlib import Path
from typing import Literal

URLS_FILE = Path.home() / ".config/newsboat/urls"
USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"
TIMEOUT = 15
RETRY_DELAY = 3

Status = Literal["ok", "redirect", "error"]


@dataclass
class FeedEntry:
    raw: str
    url: str = ""
    tags: list[str] = field(default_factory=list)
    title: str = ""
    is_comment: bool = False
    is_empty: bool = False


def parse_urls(text: str) -> list[FeedEntry]:
    entries = []
    for line in text.splitlines():
        e = FeedEntry(raw=line)
        stripped = line.strip()
        if not stripped:
            e.is_empty = True
            entries.append(e)
            continue
        if stripped.startswith("#"):
            e.is_comment = True
            entries.append(e)
            continue
        parts = stripped.split('"')
        url = parts[0].strip()
        e.url = url
        if len(parts) >= 3:
            e.title = parts[1]
        if len(parts) >= 5:
            e.tags = [t.strip() for t in parts[3].split() if t.strip()]
        entries.append(e)
    return entries


def format_entry(e: FeedEntry) -> str:
    parts = [e.url]
    if e.title:
        parts.append(f'"{e.title}"')
    if e.tags:
        parts.append(f'"{" ".join(e.tags)}"')
    return " ".join(parts)


def check_url(url: str, retries: int = 2, timeout: int = TIMEOUT) -> tuple[Status, str, str | None]:
    is_youtube = "youtube.com/feeds/videos.xml" in url
    last_error: str | None = None
    last_final: str = url
    last_status: Status = "error"

    for attempt in range(1 + retries):
        if attempt > 0:
            time.sleep(RETRY_DELAY * attempt)
        req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
        try:
            resp = urllib.request.urlopen(req, timeout=timeout)
            final = resp.geturl()
            return ("ok", final, None)
        except urllib.error.HTTPError as e:
            last_final = url
            if e.code in (301, 302, 303, 307, 308):
                new_loc = e.headers.get("Location", "")
                return ("redirect", new_loc, f"HTTP {e.code} -> {new_loc}")
            if is_youtube and attempt < retries and e.code in (404, 429, 500, 502, 503):
                last_status = "error"
                last_error = f"HTTP {e.code} (reintento {attempt+1}/{retries})"
                continue
            return ("error", url, f"HTTP {e.code}: {e.reason}")
        except (urllib.error.URLError, TimeoutError, OSError) as e:
            reason = str(e.reason) if hasattr(e, "reason") else str(e)
            if is_youtube and attempt < retries:
                last_status = "error"
                last_error = f"{type(e).__name__}: {reason} (reintento {attempt+1}/{retries})"
                continue
            return ("error", url, f"{type(e).__name__}: {reason}")

    return (last_status, last_final, last_error)


def main() -> None:
    ap = argparse.ArgumentParser(description="Verifica y actualiza URLs de feeds RSS")
    ap.add_argument("--write", action="store_true", help="Escribir cambios al archivo urls")
    ap.add_argument("--retry", type=int, default=2, help="Max reintentos por URL (def: 2)")
    args = ap.parse_args()

    if not URLS_FILE.exists():
        print(f"Error: no se encuentra {URLS_FILE}", file=sys.stderr)
        sys.exit(1)

    text = URLS_FILE.read_text()
    entries = parse_urls(text)

    changed = False
    stats = {"ok": 0, "redirect": 0, "error": 0, "skipped": 0}
    error_feeds: list[tuple[str, str, str]] = []

    updated_lines = []

    for e in entries:
        if e.is_empty or e.is_comment:
            updated_lines.append(e.raw)
            stats["skipped"] += 1
            continue

        label = (e.tags[0] if e.tags else e.title) or e.url[:60]
        print(f"  {label:60s} ... ", end="", flush=True)
        status, final_url, err_msg = check_url(e.url, retries=args.retry)

        if status == "ok":
            print("\033[92mOK\033[0m")
            if final_url != e.url:
                print(f"    -> redirect encubierto: {final_url}")
            stats["ok"] += 1
            updated_lines.append(e.raw)
        elif status == "redirect":
            print(f"\033[93mREDIRECT\033[0m {err_msg}")
            if args.write:
                e.url = final_url
                updated_lines.append(format_entry(e))
                changed = True
                print(f"    -> actualizado: {final_url}")
            else:
                updated_lines.append(e.raw)
            stats["redirect"] += 1
        else:
            print(f"\033[91mERROR\033[0m {err_msg}")
            updated_lines.append(e.raw)
            stats["error"] += 1
            error_feeds.append((e.url, label or e.url, err_msg or ""))

    print()
    total = len(entries)
    ok = stats["ok"]
    redirs = stats["redirect"]
    errors = stats["error"]
    skipped = stats["skipped"]
    print(f"Resumen: {ok} ok, {redirs} redirects, {errors} errores, {skipped} comentarios/vacías de {total}")

    if error_feeds:
        print(f"\nFeeds con error ({len(error_feeds)}):")
        for url, name, msg in error_feeds:
            print(f"  {name:50s} {msg}")
        print("\nCorre `newsboat -x reload` para recargar o revisa manualmente.")

    if changed and args.write:
        URLS_FILE.write_text("\n".join(updated_lines) + "\n")
        print(f"\nArchivo actualizado: {URLS_FILE}")

    sys.exit(0 if errors == 0 else 1)


if __name__ == "__main__":
    main()
