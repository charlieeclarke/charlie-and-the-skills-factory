#!/usr/bin/env node
'use strict';

const fs = require('fs');
const os = require('os');
const path = require('path');

const SKILLS = ['grill-me', 'componentise', 'spec', 'tickets', 'spike', 'deep-review', 'handover'];
const CELLS = 24;
const WALK = 44;
const FRAME_H = 10;

const args = process.argv.slice(2);
const projectMode = args.includes('--project') || args.includes('-p');
const VERSION = require('../package.json').version;

const DEST = process.env.CLAUDE_SKILLS_DIR || (projectMode
  ? path.join(process.cwd(), '.claude', 'skills')
  : path.join(os.homedir(), '.claude', 'skills'));
const SRC = path.join(__dirname, '..', 'plugins', 'skills-factory', 'skills');
const MARKER = () => path.join(DEST, '.factory-version');

const live = Boolean(process.stdout.isTTY) && !process.env.NO_COLOR;
const e = live
  ? { B:'\x1b[1m', D:'\x1b[2m', Z:'\x1b[0m', RED:'\x1b[38;5;203m',
      CREAM:'\x1b[38;5;223m', GOLD:'\x1b[38;5;220m',
      GREEN:'\x1b[38;5;114m', GREY:'\x1b[38;5;245m' }
  : { B:'', D:'', Z:'', RED:'', CREAM:'', GOLD:'', GREEN:'', GREY:'' };

const UB = '▄', FB = '█', TB = '▀', LH = '▐', RH = '▌',
      SH = '░', GR = '▁', ST = '★', LA = '◄',
      DOT = '●', RA = '►';

const BANNER_WORDS = [["      .,                                                               ,;", "     ,Wt .    .                  j.                    i   t         f#i", "    i#D. Di   Dt              .. EW,                  LE   Ej      .E#t", "   f#f   E#i  E#i            ;W, E##j                L#E   E#,    i#W,", " .D#i    E#t  E#t           j##, E###D.             G#W.   E#t   L#D.", ":KW,     E#t  E#t          G###, E#jG#W;           D#K.    E#t :K#Wfff;", "t#f      E########f.     :E####, E#t t##f         E#K.     E#t i##WLLLLt", " ;#G     E#j..K#j...    ;W#DG##, E#t  :K#E:     .E#E.      E#t  .E#L", "  :KE.   E#t  E#t      j###DW##, E#KDDDD###i   .K#E        E#t    f#E:", "   .DW:  E#t  E#t     G##i,,G##, E#f,t#Wi,,,  .K#D         E#t     ,WW;", "     L#, f#t  f#t   :K#K:   L##, E#t  ;#W:   .W#G          E#t      .D#;", "      jt  ii   ii  ;##D.    L##, DWi   ,KK: :W##########Wt E#t        tt", "                   ,,,      .,,             :,,,,,,,,,,,,,.,;."], ["                             ;", "                             ED.", "              L.             E#Wi                                        ,;", "              EW:        ,ft E###G.                  .    .            f#i", "           .. E##;       t#E E#fD#W;        GEEEEEEELDi   Dt         .E#t", "          ;W, E###t      t#E E#t t##L       ,;;L#K;;.E#i  E#i       i#W,", "         j##, E#fE#f     t#E E#t  .E#K,        t#E   E#t  E#t      L#D.", "        G###, E#t D#G    t#E E#t    j##f       t#E   E#t  E#t    :K#Wfff;", "      :E####, E#t  f#E.  t#E E#t    :E#K:      t#E   E########f. i##WLLLLt", "     ;W#DG##, E#t   t#K: t#E E#t   t##L        t#E   E#j..K#j...  .E#L", "    j###DW##, E#t    ;#W,t#E E#t .D#W;         t#E   E#t  E#t       f#E:", "   G##i,,G##, E#t     :K#D#E E#tiW#G.          t#E   E#t  E#t        ,WW;", " :K#K:   L##, E#t      .E##E E#K##i            t#E   f#t  f#t         .D#;", ";##D.    L##, ..         G#E E##D.              fE    ii   ii           tt", ",,,      .,,              fE E#t                 :", "                           , L:"], ["         . G:                                                 .", "        ;W E#,    :t              i              i           ;W", "       f#E E#t  .GEEj            LE             LE          f#E", "     .E#f  E#t j#K;E#,          L#E            L#E        .E#f", "    iWW;   E#GK#f  E#t         G#W.           G#W.       iWW;", "   L##Lffi E##D.   E#t        D#K.           D#K.       L##Lffi", "  tLLG##L  E##Wi   E#t       E#K.           E#K.       tLLG##L", "    ,W#i   E#jL#D: E#t     .E#E.          .E#E.          ,W#i", "   j#E.    E#t ,K#jE#t    .K#E           .K#E           j#E.", " .D#j      E#t   jDE#t   .K#D           .K#D          .D#j", ",WK,       j#t     E#t  .W#G           .W#G          ,WK,", "EG.         ,;     E#t :W##########Wt :W##########Wt EG.", ",                  ,;. :,,,,,,,,,,,,,.:,,,,,,,,,,,,,.,"], ["   ,", "   Et                                          :", "   E#t                        .,              t#,", "   E##t                      ,Wt             ;##W.   j.", "   E#W#t             ..     i#D. GEEEEEEEL  :#L:WE   EW,        f.     ;WE.", "   E#tfL.           ;W,    f#f   ,;;L#K;;. .KG  ,#D  E##j       E#,   i#G", "   E#t             j##,  .D#i       t#E    EE    ;#f E###D.     E#t  f#f", ",ffW#Dffj.        G###, :KW,        t#E   f#.     t#iE#jG#W;    E#t G#i", " ;LW#ELLLf.     :E####, t#f         t#E   :#G     GK E#t t##f   E#jEW,", "   E#t         ;W#DG##,  ;#G        t#E    ;#L   LW. E#t  :K#E: E##E.", "   E#t        j###DW##,   :KE.      t#E     t#f f#:  E#KDDDD###iE#G", "   E#t       G##i,,G##,    .DW:     t#E      f#D#;   E#f,t#Wi,,,E#t", "   E#t     :K#K:   L##,      L#,    t#E       G#t    E#t  ;#W:  E#t", "   E#t    ;##D.    L##,       jt     fE        t     DWi   ,KK: EE.", "   ;#t    ,,,      .,,                :                         t", "    :;"]];
const BANNER_COLOUR = [e.GOLD, e.GREY, e.RED, e.RED];

const say = (s) => process.stdout.write(s + '\n');
const rep = (ch, n) => (n > 0 ? new Array(n + 1).join(ch) : '');
const sp = (n) => rep(' ', n);
const up = (n) => { if (live) process.stdout.write('\x1b[' + n + 'A'); };
const sleep = (ms) => new Promise((r) => setTimeout(r, live ? ms : 0));

function banner() {
  BANNER_WORDS.forEach((word, i) => {
    word.forEach((line) => say('  ' + BANNER_COLOUR[i] + line + e.Z));
  });
}

// The mushroom walks right and grows as the gauge fills. Mirrors install.sh.
function sprite(cell) {
  const pad = sp(2 + Math.floor((cell * WALK) / CELLS));
  let rows;
  if (cell < 8) {
    rows = [
      e.RED + ' ' + rep(UB, 3) + ' ' + e.Z,
      e.RED + UB + rep(FB, 3) + UB + e.Z,
      e.CREAM + ' ' + rep(FB, 3) + ' ' + e.Z,
      e.CREAM + ' ' + rep(TB, 3) + ' ' + e.Z
    ];
  } else if (cell < 16) {
    rows = [
      e.RED + sp(3) + rep(UB, 5) + e.Z,
      e.RED + ' ' + UB + rep(FB, 7) + UB + e.Z,
      e.RED + rep(FB, 2) + e.Z + ' ' + e.CREAM + rep(UB, 2) + e.Z + ' ' +
        e.CREAM + rep(UB, 2) + e.Z + ' ' + e.RED + rep(FB, 2) + e.Z,
      e.RED + TB + rep(FB, 9) + TB + e.Z,
      e.CREAM + sp(3) + rep(FB, 5) + e.Z,
      e.CREAM + sp(3) + TB + rep(FB, 3) + TB + e.Z
    ];
  } else {
    rows = [
      e.RED + sp(7) + rep(UB, 8) + e.Z,
      e.RED + sp(5) + UB + rep(FB, 9) + UB + e.Z,
      e.RED + sp(4) + rep(FB, 3) + e.Z + ' ' + e.CREAM + rep(UB, 2) + e.Z + '  ' +
        e.CREAM + rep(UB, 2) + e.Z + ' ' + e.RED + rep(FB, 3) + e.Z,
      e.RED + sp(4) + rep(FB, 3) + e.Z + ' ' + e.CREAM + rep(FB, 2) + e.Z + '  ' +
        e.CREAM + rep(FB, 2) + e.Z + ' ' + e.RED + rep(FB, 3) + e.Z,
      e.RED + sp(4) + TB + rep(FB, 13) + TB + e.Z,
      e.CREAM + sp(7) + rep(FB, 9) + e.Z,
      e.CREAM + sp(7) + rep(FB, 9) + e.Z,
      e.CREAM + sp(7) + TB + rep(FB, 7) + TB + e.Z
    ];
  }
  const block = [];
  while (block.length < 8 - rows.length) block.push('');
  rows.forEach((r) => block.push(pad + r));
  return block;
}

function gauge(f, label) {
  let pct = String(Math.round((f * 100) / CELLS));
  while (pct.length < 3) pct = ' ' + pct;
  return '  ' + e.B + 'POWER' + e.Z + ' ' + e.GREY + LH + e.Z +
    e.GOLD + rep(FB, f) + e.Z + e.D + rep(SH, CELLS - f) + e.Z +
    e.GREY + RH + e.Z + ' ' + e.B + pct + '%' + e.Z + '  ' +
    e.GREEN + label + e.Z;
}

function frame(cell, label) {
  sprite(cell).forEach(say);
  say('  ' + e.D + rep(GR, 60) + e.Z);
  say(gauge(cell, label));
}

function copyDir(from, to) {
  fs.mkdirSync(to, { recursive: true });
  for (const entry of fs.readdirSync(from, { withFileTypes: true })) {
    const a = path.join(from, entry.name);
    const b = path.join(to, entry.name);
    if (entry.isDirectory()) copyDir(a, b);
    else fs.copyFileSync(a, b);
  }
}

function readMarker() {
  try { return JSON.parse(fs.readFileSync(MARKER(), 'utf8')); } catch (err) { return null; }
}

function writeMarker(skills) {
  fs.writeFileSync(MARKER(), JSON.stringify({
    version: VERSION, installed: new Date().toISOString(), skills
  }, null, 2) + '\n');
}

function die(msg) {
  say('  ' + e.RED + 'x ' + msg + e.Z);
  process.exit(1);
}

async function main() {
  say('');
  banner();
  say('');

  if (!fs.existsSync(SRC)) die('the crate arrived empty - no skills/ inside the package.');

  const destExisted = fs.existsSync(DEST);
  fs.mkdirSync(DEST, { recursive: true });

  const d = new Date();
  const p2 = (n) => String(n).padStart(2, '0');
  const stamp = String(d.getFullYear()) + p2(d.getMonth() + 1) + p2(d.getDate()) +
    '-' + p2(d.getHours()) + p2(d.getMinutes()) + p2(d.getSeconds());
  const previous = readMarker();
  const installed = [];
  const skipped = [];
  let backedUp = false;
  let cur = 0;

  frame(0, 'warming up...');
  await sleep(400);

  for (let i = 0; i < SKILLS.length; i++) {
    const s = SKILLS[i];
    const target = Math.round((CELLS * (i + 1)) / SKILLS.length);

    if (!fs.existsSync(path.join(SRC, s, 'SKILL.md'))) { skipped.push(s); continue; }

    const dst = path.join(DEST, s);
    if (fs.existsSync(dst)) {
      const backup = path.join(DEST, '.factory-backup');
      fs.mkdirSync(backup, { recursive: true });
      let target = path.join(backup, s + '-' + stamp);
      for (let n = 2; fs.existsSync(target); n++) {
        target = path.join(backup, s + '-' + stamp + '-' + n);
      }
      fs.renameSync(dst, target);
      backedUp = true;
    }
    copyDir(path.join(SRC, s), dst);
    installed.push(s);

    if (live) {
      while (cur < target) {
        cur += 1;
        up(FRAME_H);
        frame(cur, 'got ' + s + '!');
        await sleep(50);
      }
    } else {
      cur = target;
      frame(cur, 'got ' + s + '!');
    }
    await sleep(300);
  }

  if (!installed.length) die('No power-ups collected. Still small.');

  const stars = [ST, ST, ST].join('  ');
  say('');
  say('  ' + e.B + e.GOLD + stars + '   L E V E L   U P !   ' + stars + e.Z);
  say('');
  say('  ' + e.D + 'new abilities unlocked:' + e.Z);
  installed.forEach((s) => {
    say('    ' + e.RED + LA + e.Z + e.CREAM + DOT + e.Z + e.RED + RA + e.Z +
        '  ' + e.B + e.GREEN + '/' + s + e.Z);
  });
  say('');
  skipped.forEach((s) => say('  ' + e.RED + 'x missing from the package: ' + s + e.Z));
  writeMarker(installed);

  if (previous && previous.version !== VERSION) {
    say('  ' + e.D + 'updated:' + e.Z + ' ' + previous.version + ' ' + RA + ' ' + e.B + VERSION + e.Z);
  } else {
    say('  ' + e.D + 'version:' + e.Z + ' ' + VERSION);
  }
  if (destExisted) {
    say('  ' + e.D + 'Claude Code picks these up automatically - no restart needed.' + e.Z);
  } else {
    say('  ' + e.D + 'Restart Claude Code so it starts watching this new folder.' + e.Z);
  }
  say('  ' + e.D + 'installed to:' + e.Z + ' ' + DEST);
  if (projectMode) {
    say('  ' + e.D + 'commit .claude/skills/ so everyone gets these on clone.' + e.Z);
  }
  if (backedUp) {
    say('  ' + e.D + 'previous versions kept in:' + e.Z + ' ' + path.join(DEST, '.factory-backup'));
  }
  say('');
}

main().catch((err) => die(err && err.message ? err.message : String(err)));
