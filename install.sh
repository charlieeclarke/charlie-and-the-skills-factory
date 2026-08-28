#!/bin/sh
# Charlie & the Skills Factory — installer
# Usage: curl -fsSL https://raw.githubusercontent.com/charlieeclarke/charlie-and-the-skills-factory/main/install.sh | sh

set -e

REPO="charlieeclarke/charlie-and-the-skills-factory"
BRANCH="${SKILLS_FACTORY_REF:-main}"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
SKILLS="grill-me componentise"

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  B=$(printf '\033[1m'); D=$(printf '\033[2m'); Z=$(printf '\033[0m')
  RED=$(printf '\033[38;5;203m');  CREAM=$(printf '\033[38;5;223m')
  GOLD=$(printf '\033[38;5;220m'); GREEN=$(printf '\033[38;5;114m')
  SKY=$(printf '\033[38;5;75m');   GREY=$(printf '\033[38;5;245m')
  TTY=1
else
  B=; D=; Z=; RED=; CREAM=; GOLD=; GREEN=; SKY=; GREY=; TTY=
fi

nap() { [ -n "$TTY" ] && sleep "$1" || true; }
up()  { [ -n "$TTY" ] && printf '\033[%dA' "$1" || true; }
say() { printf '%s\n' "$*"; }

bar() { _i=0; _o=; while [ "$_i" -lt "$2" ]; do _o="$_o$1"; _i=$((_i+1)); done; printf '%s' "$_o"; }

# ── sprites ──────────────────────────────────────────────────
mushroom() {
  say "       ${RED}▄▄▄▄▄▄▄▄${Z}"
  say "     ${RED}▄█████████▄${Z}"
  say "    ${RED}███${Z} ${CREAM}▄▄${Z}  ${CREAM}▄▄${Z} ${RED}███${Z}"
  say "    ${RED}███${Z} ${CREAM}██${Z}  ${CREAM}██${Z} ${RED}███${Z}"
  say "    ${RED}▀█████████████▀${Z}"
  say "       ${CREAM}█████████${Z}"
  say "       ${CREAM}█████████${Z}"
  say "       ${CREAM}▀███████▀${Z}"
}

title() {
  say ""
  say "   ${B}${GOLD}C H A R L I E   &   T H E${Z}"
  say "   ${B}${RED}S K I L L S   F A C T O R Y${Z}"
  say "   ${D}${GREY}── 1-UP your Claude Code ──${Z}"
  say ""
}

hero_small() {
  say "        ${SKY}▄█▄${Z}      ${D}LV.1${Z}"
  say "        ${SKY}███${Z}      ${D}feeling ordinary${Z}"
  say "        ${SKY}▀ ▀${Z}"
  say ""
  say ""
}

hero_big() {
  say "       ${GOLD}▄█████▄${Z}    ${B}${GOLD}LV.MAX  ★${Z}"
  say "       ${GOLD}███████${Z}    ${GREEN}powered up${Z}"
  say "       ${GOLD}▐█████▌${Z}"
  say "       ${GOLD}▐█▌ ▐█▌${Z}"
  say "       ${GOLD}▀▀▀ ▀▀▀${Z}"
}

# ── power gauge ──────────────────────────────────────────────
CELLS=24
gauge() { # gauge <filled> <label>
  _f=$1; _e=$(( CELLS - _f )); _p=$(( _f * 100 / CELLS ))
  [ -n "$TTY" ] && printf '\r'
  printf '   %sPOWER%s %s▐%s%s%s%s%s%s▌%s %s%3d%%%s  %s%-22s%s' \
    "$B" "$Z" "$GREY" "$Z" \
    "$GOLD" "$(bar '█' "$_f")" "$Z" \
    "$D$(bar '░' "$_e")$Z" "$GREY" "$Z" \
    "$B" "$_p" "$Z" "$GREEN" "$2" "$Z"
  [ -n "$TTY" ] || printf '\n'
}

fill_to() { # fill_to <from> <to> <label>
  _c=$1
  if [ -n "$TTY" ]; then
    while [ "$_c" -lt "$2" ]; do
      _c=$(( _c + 1 )); gauge "$_c" "$3"; nap 0.04
    done
  else
    gauge "$2" "$3"
  fi
}

level_up() {
  say ""
  say ""
  say "   ${B}${GOLD}★  ★  ★   L E V E L   U P !   ★  ★  ★${Z}"
  say ""
  hero_big
  say ""
  say "   ${D}new abilities unlocked:${Z}"
  for s in $INSTALLED; do
    say "     ${RED}◄${Z}${CREAM}●${Z}${RED}►${Z}  ${B}${GREEN}/$s${Z}"
  done
  say ""
  say "   ${D}Restart Claude Code to use them.${Z}"
  say ""
}

# ── run ──────────────────────────────────────────────────────
title
mushroom
say ""
hero_small

command -v curl >/dev/null 2>&1 || { say "   ${RED}✗ curl not found — no power-ups can be delivered.${Z}"; exit 1; }
command -v tar  >/dev/null 2>&1 || { say "   ${RED}✗ tar not found — nothing here can be unwrapped.${Z}"; exit 1; }

TMP=$(mktemp -d 2>/dev/null || mktemp -d -t skillsfactory)
trap 'rm -rf "$TMP"' EXIT INT TERM

say "   ${D}fetching power-ups from ${REPO}@${BRANCH}...${Z}"
if ! curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$BRANCH" | tar -xz -C "$TMP" 2>/dev/null; then
  say "   ${RED}✗ could not reach the warehouse. Check the repo, branch, or your connection.${Z}"
  exit 1
fi

SRC=$(find "$TMP" -type d -name skills -path '*skills-factory*' 2>/dev/null | head -1)
[ -n "$SRC" ] && [ -d "$SRC" ] || { say "   ${RED}✗ the crate arrived empty — no skills/ inside.${Z}"; exit 1; }

mkdir -p "$DEST"
STAMP=$(date +%Y%m%d-%H%M%S)
INSTALLED=; SKIPPED=

TOTAL=0
for s in $SKILLS; do TOTAL=$(( TOTAL + 1 )); done

say ""
gauge 0 "warming up..."
DONE=0; CUR=0
for s in $SKILLS; do
  DONE=$(( DONE + 1 ))
  TARGET=$(( CELLS * DONE / TOTAL ))
  if [ ! -f "$SRC/$s/SKILL.md" ]; then
    SKIPPED="$SKIPPED $s"; continue
  fi
  if [ -d "$DEST/$s" ]; then
    mkdir -p "$DEST/.factory-backup"
    mv "$DEST/$s" "$DEST/.factory-backup/$s-$STAMP"
  fi
  cp -R "$SRC/$s" "$DEST/$s"
  INSTALLED="$INSTALLED $s"
  fill_to "$CUR" "$TARGET" "got $s!"
  CUR=$TARGET
  nap 0.25
done

[ -n "$INSTALLED" ] || { say ""; say ""; say "   ${RED}✗ No power-ups collected. Still LV.1.${Z}"; exit 1; }

level_up
for s in $SKIPPED; do say "   ${RED}✗ missing from the crate: $s${Z}"; done
say "   ${D}installed to:${Z} $DEST"
[ -d "$DEST/.factory-backup" ] && say "   ${D}previous versions kept in:${Z} $DEST/.factory-backup"
say ""
