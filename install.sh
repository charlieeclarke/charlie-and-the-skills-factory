#!/bin/sh
# Charlie & the Skills Factory - installer
# Usage: curl -fsSL https://raw.githubusercontent.com/charlieeclarke/charlie-and-the-skills-factory/main/install.sh | sh

set -e

REPO="charlieeclarke/charlie-and-the-skills-factory"
BRANCH="${SKILLS_FACTORY_REF:-main}"
PROJECT=
for _a in "$@"; do
  case "$_a" in --project|-p) PROJECT=1 ;; esac
done
if [ -n "$PROJECT" ]; then _default="$PWD/.claude/skills"; else _default="$HOME/.claude/skills"; fi
DEST="${CLAUDE_SKILLS_DIR:-$_default}"
SKILLS="grill-me componentise spec tickets spike deep-review handover"

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  B=$(printf '\033[1m'); D=$(printf '\033[2m'); Z=$(printf '\033[0m')
  RED=$(printf '\033[38;5;203m');  CREAM=$(printf '\033[38;5;223m')
  GOLD=$(printf '\033[38;5;220m'); GREEN=$(printf '\033[38;5;114m')
  GREY=$(printf '\033[38;5;245m')
  TTY=1
else
  B=; D=; Z=; RED=; CREAM=; GOLD=; GREEN=; GREY=; TTY=
fi

CELLS=24
WALK=44
FRAME_H=10

nap() { [ -n "$TTY" ] && sleep "$1" || true; }
up()  { [ -n "$TTY" ] && printf '\033[%dA' "$1" || true; }
say() { printf '%s\n' "$*"; }
bar() { _i=0; _o=; while [ "$_i" -lt "$2" ]; do _o="$_o$1"; _i=$((_i+1)); done; printf '%s' "$_o"; }

BANNER=$(cat <<'ART'
      .,                                                               ,;
     ,Wt .    .                  j.                    i   t         f#i
    i#D. Di   Dt              .. EW,                  LE   Ej      .E#t
   f#f   E#i  E#i            ;W, E##j                L#E   E#,    i#W,
 .D#i    E#t  E#t           j##, E###D.             G#W.   E#t   L#D.
:KW,     E#t  E#t          G###, E#jG#W;           D#K.    E#t :K#Wfff;
t#f      E########f.     :E####, E#t t##f         E#K.     E#t i##WLLLLt
 ;#G     E#j..K#j...    ;W#DG##, E#t  :K#E:     .E#E.      E#t  .E#L
  :KE.   E#t  E#t      j###DW##, E#KDDDD###i   .K#E        E#t    f#E:
   .DW:  E#t  E#t     G##i,,G##, E#f,t#Wi,,,  .K#D         E#t     ,WW;
     L#, f#t  f#t   :K#K:   L##, E#t  ;#W:   .W#G          E#t      .D#;
      jt  ii   ii  ;##D.    L##, DWi   ,KK: :W##########Wt E#t        tt
                   ,,,      .,,             :,,,,,,,,,,,,,.,;.
                             ;
                             ED.
              L.             E#Wi                                        ,;
              EW:        ,ft E###G.                  .    .            f#i
           .. E##;       t#E E#fD#W;        GEEEEEEELDi   Dt         .E#t
          ;W, E###t      t#E E#t t##L       ,;;L#K;;.E#i  E#i       i#W,
         j##, E#fE#f     t#E E#t  .E#K,        t#E   E#t  E#t      L#D.
        G###, E#t D#G    t#E E#t    j##f       t#E   E#t  E#t    :K#Wfff;
      :E####, E#t  f#E.  t#E E#t    :E#K:      t#E   E########f. i##WLLLLt
     ;W#DG##, E#t   t#K: t#E E#t   t##L        t#E   E#j..K#j...  .E#L
    j###DW##, E#t    ;#W,t#E E#t .D#W;         t#E   E#t  E#t       f#E:
   G##i,,G##, E#t     :K#D#E E#tiW#G.          t#E   E#t  E#t        ,WW;
 :K#K:   L##, E#t      .E##E E#K##i            t#E   f#t  f#t         .D#;
;##D.    L##, ..         G#E E##D.              fE    ii   ii           tt
,,,      .,,              fE E#t                 :
                           , L:
         . G:                                                 .
        ;W E#,    :t              i              i           ;W
       f#E E#t  .GEEj            LE             LE          f#E
     .E#f  E#t j#K;E#,          L#E            L#E        .E#f
    iWW;   E#GK#f  E#t         G#W.           G#W.       iWW;
   L##Lffi E##D.   E#t        D#K.           D#K.       L##Lffi
  tLLG##L  E##Wi   E#t       E#K.           E#K.       tLLG##L
    ,W#i   E#jL#D: E#t     .E#E.          .E#E.          ,W#i
   j#E.    E#t ,K#jE#t    .K#E           .K#E           j#E.
 .D#j      E#t   jDE#t   .K#D           .K#D          .D#j
,WK,       j#t     E#t  .W#G           .W#G          ,WK,
EG.         ,;     E#t :W##########Wt :W##########Wt EG.
,                  ,;. :,,,,,,,,,,,,,.:,,,,,,,,,,,,,.,
   ,
   Et                                          :
   E#t                        .,              t#,
   E##t                      ,Wt             ;##W.   j.
   E#W#t             ..     i#D. GEEEEEEEL  :#L:WE   EW,        f.     ;WE.
   E#tfL.           ;W,    f#f   ,;;L#K;;. .KG  ,#D  E##j       E#,   i#G
   E#t             j##,  .D#i       t#E    EE    ;#f E###D.     E#t  f#f
,ffW#Dffj.        G###, :KW,        t#E   f#.     t#iE#jG#W;    E#t G#i
 ;LW#ELLLf.     :E####, t#f         t#E   :#G     GK E#t t##f   E#jEW,
   E#t         ;W#DG##,  ;#G        t#E    ;#L   LW. E#t  :K#E: E##E.
   E#t        j###DW##,   :KE.      t#E     t#f f#:  E#KDDDD###iE#G
   E#t       G##i,,G##,    .DW:     t#E      f#D#;   E#f,t#Wi,,,E#t
   E#t     :K#K:   L##,      L#,    t#E       G#t    E#t  ;#W:  E#t
   E#t    ;##D.    L##,       jt     fE        t     DWi   ,KK: EE.
   ;#t    ,,,      .,,                :                         t
    :;
ART
)

print_banner() {
  _n=0
  printf '%s\n' "$BANNER" | while IFS= read -r _l; do
    _n=$((_n + 1))
    if   [ "$_n" -le 13 ]; then _c=$GOLD
    elif [ "$_n" -le 29 ]; then _c=$GREY
    else                        _c=$RED
    fi
    printf '  %s%s%s\n' "$_c" "$_l" "$Z"
  done
}

# ---- the mushroom: walks right, grows as the gauge fills ----
draw_sprite() {
  _c=$1
  _pad=$(bar ' ' $(( 2 + _c * WALK / CELLS )))
  if   [ "$_c" -lt 8 ];  then _sz=1
  elif [ "$_c" -lt 16 ]; then _sz=2
  else                        _sz=3
  fi
  case $_sz in
    1)
      say ""; say ""; say ""; say ""
      say "$_pad${RED} ▄▄▄ ${Z}"
      say "$_pad${RED}▄███▄${Z}"
      say "$_pad${CREAM} ███ ${Z}"
      say "$_pad${CREAM} ▀▀▀ ${Z}"
      ;;
    2)
      say ""; say ""
      say "$_pad${RED}   ▄▄▄▄▄${Z}"
      say "$_pad${RED} ▄███████▄${Z}"
      say "$_pad${RED}██${Z} ${CREAM}▄▄${Z} ${CREAM}▄▄${Z} ${RED}██${Z}"
      say "$_pad${RED}▀█████████▀${Z}"
      say "$_pad${CREAM}   █████${Z}"
      say "$_pad${CREAM}   ▀███▀${Z}"
      ;;
    3)
      say "$_pad${RED}       ▄▄▄▄▄▄▄▄${Z}"
      say "$_pad${RED}     ▄█████████▄${Z}"
      say "$_pad${RED}    ███${Z} ${CREAM}▄▄${Z}  ${CREAM}▄▄${Z} ${RED}███${Z}"
      say "$_pad${RED}    ███${Z} ${CREAM}██${Z}  ${CREAM}██${Z} ${RED}███${Z}"
      say "$_pad${RED}    ▀█████████████▀${Z}"
      say "$_pad${CREAM}       █████████${Z}"
      say "$_pad${CREAM}       █████████${Z}"
      say "$_pad${CREAM}       ▀███████▀${Z}"
      ;;
  esac
}

ground() { printf '  %s%s%s\n' "$D" "$(bar '▁' 60)" "$Z"; }

gauge() {
  _f=$1; _e=$(( CELLS - _f )); _p=$(( _f * 100 / CELLS ))
  printf '  %sPOWER%s %s▐%s%s%s%s%s%s▌%s %s%3d%%%s  %s%s%s\n' \
    "$B" "$Z" "$GREY" "$Z" \
    "$GOLD" "$(bar '█' "$_f")" "$Z" \
    "$D$(bar '░' "$_e")$Z" "$GREY" "$Z" \
    "$B" "$_p" "$Z" "$GREEN" "$2" "$Z"
}

frame() { draw_sprite "$1"; ground; gauge "$1" "$2"; }

# ---- run ----
say ""
print_banner
say ""

command -v curl >/dev/null 2>&1 || { say "  ${RED}x curl not found - no power-ups can be delivered.${Z}"; exit 1; }
command -v tar  >/dev/null 2>&1 || { say "  ${RED}x tar not found - nothing here can be unwrapped.${Z}"; exit 1; }

TMP=$(mktemp -d 2>/dev/null || mktemp -d -t skillsfactory)
trap 'rm -rf "$TMP"' EXIT INT TERM

say "  ${D}fetching power-ups from ${REPO}@${BRANCH}...${Z}"
if ! curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$BRANCH" | tar -xz -C "$TMP" 2>/dev/null; then
  say "  ${RED}x could not reach the warehouse. Check the repo, branch, or your connection.${Z}"
  exit 1
fi

SRC=$(find "$TMP" -type d -name skills -path '*skills-factory*' 2>/dev/null | head -1)
[ -n "$SRC" ] && [ -d "$SRC" ] || { say "  ${RED}x the crate arrived empty - no skills/ inside.${Z}"; exit 1; }

VERSION=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$TMP"/*/package.json 2>/dev/null | head -1)
[ -n "$VERSION" ] || VERSION="unknown"
PREV=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$DEST/.factory-version" 2>/dev/null | head -1)

DEST_EXISTED=
[ -d "$DEST" ] && DEST_EXISTED=1
mkdir -p "$DEST"
STAMP=$(date +%Y%m%d-%H%M%S)
INSTALLED=; SKIPPED=

TOTAL=0
for s in $SKILLS; do TOTAL=$((TOTAL + 1)); done

say ""
frame 0 "warming up..."
nap 0.4

DONE=0; CUR=0
for s in $SKILLS; do
  DONE=$((DONE + 1))
  TARGET=$(( CELLS * DONE / TOTAL ))
  if [ ! -f "$SRC/$s/SKILL.md" ]; then SKIPPED="$SKIPPED $s"; continue; fi
  if [ -d "$DEST/$s" ]; then
    mkdir -p "$DEST/.factory-backup"
    _bk="$DEST/.factory-backup/$s-$STAMP"; _n=2
    while [ -e "$_bk" ]; do _bk="$DEST/.factory-backup/$s-$STAMP-$_n"; _n=$((_n + 1)); done
    mv "$DEST/$s" "$_bk"
  fi
  cp -R "$SRC/$s" "$DEST/$s"
  INSTALLED="$INSTALLED $s"
  if [ -n "$TTY" ]; then
    while [ "$CUR" -lt "$TARGET" ]; do
      CUR=$((CUR + 1))
      up "$FRAME_H"; frame "$CUR" "got $s!"; nap 0.05
    done
  else
    CUR=$TARGET
    up "$FRAME_H"; frame "$CUR" "got $s!"
  fi
  nap 0.3
done

[ -n "$INSTALLED" ] || { say ""; say "  ${RED}x No power-ups collected. Still small.${Z}"; exit 1; }

say ""
say "  ${B}${GOLD}★  ★  ★   L E V E L   U P !   ★  ★  ★${Z}"
say ""
say "  ${D}new abilities unlocked:${Z}"
for s in $INSTALLED; do
  say "    ${RED}◄${Z}${CREAM}●${Z}${RED}►${Z}  ${B}${GREEN}/$s${Z}"
done
say ""
for s in $SKIPPED; do say "  ${RED}x missing from the crate: $s${Z}"; done
printf '{\n  "version": "%s",\n  "installed": "%s",\n  "skills": [%s]\n}\n' \
  "$VERSION" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  "$(echo $INSTALLED | sed 's/ /", "/g; s/^/"/; s/$/"/')" > "$DEST/.factory-version"

if [ -n "$DEST_EXISTED" ]; then
  say "  ${D}Claude Code picks these up automatically - no restart needed.${Z}"
else
  say "  ${D}Restart Claude Code so it starts watching this new folder.${Z}"
fi
if [ -n "$PREV" ] && [ "$PREV" != "$VERSION" ]; then
  say "  ${D}updated:${Z} $PREV ${RED}►${Z} ${B}${VERSION}${Z}"
else
  say "  ${D}version:${Z} $VERSION"
fi
say "  ${D}installed to:${Z} $DEST"
[ -n "$PROJECT" ] && say "  ${D}commit .claude/skills/ so everyone gets these on clone.${Z}"
[ -d "$DEST/.factory-backup" ] && say "  ${D}previous versions kept in:${Z} $DEST/.factory-backup"
say ""
