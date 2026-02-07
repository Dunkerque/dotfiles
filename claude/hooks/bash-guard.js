#!/usr/bin/env node
'use strict';

/**
 * Claude Code — Bash Guard Hook
 *
 * Intercepte chaque commande Bash avant exécution.
 * Retourne permissionDecision "deny" si un pattern dangereux est détecté.
 *
 * Patterns bloqués :
 *   1. rm -rf sur des chemins système critiques
 *   2. eval comme commande shell
 *   3. exec qui remplace le processus courant
 *   4. Fork bomb  :(){ ... }
 *   5. Pipe vers un shell  (| sh, | bash, | zsh, | dash)
 *   6. dd vers un périphérique bloc  (of=/dev/…)
 *   7. mkfs  (formatage disque)
 *   8. shred  (suppression irréversible)
 *   9. sudo  (élévation de privileges)
 */

const CRITICAL_PATHS = [
  '/', '/home', '/usr', '/etc', '/var', '/opt',
  '/bin', '/sbin', '/lib', '/lib64',
  '/System', '/Applications', '/Library',
  '/root', '/boot', '/dev', '/proc', '/sys',
  '~', '$HOME'
];

let raw = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', d => raw += d);
process.stdin.on('end', () => {
  let cmd = '';
  try {
    const payload = JSON.parse(raw);
    cmd = payload?.tool_input?.command || '';
  } catch {
    cmd = raw.trim();
  }

  if (!cmd) { process.exit(0); }

  const threat = scan(cmd);
  if (threat) {
    const output = {
      hookSpecificOutput: {
        hookEventName: 'PreToolUse',
        permissionDecision: 'deny',
        permissionDecisionReason: `[bash-guard] ${threat}`
      }
    };
    console.log(JSON.stringify(output));
    process.exit(0);
  }

  // Rien de dangereux — on autorise
  process.exit(0);
});

function scan(cmd) {
  const c = cmd.trim();
  const low = c.toLowerCase();

  // ── 1. rm -rf sur chemins critiques ──────────────────────────
  // Détecte rm avec -r(ecursive) ET -f(orce) dans les flags (toutes combinaisons)
  const rmMatch = c.match(/\brm\s+((-[a-zA-Z]+\s+)*-[a-zA-Z]+)/);
  if (rmMatch) {
    const flagsStr = rmMatch[1];
    if (/[rR]/.test(flagsStr) && /[fF]/.test(flagsStr)) {
      // Extraire tout ce qui vient après les flags
      const rest = c.slice(c.indexOf(rmMatch[1]) + rmMatch[1].length).trim();
      // Premier token = première cible
      const firstTarget = rest.split(/[\s;|&]/)[0];
      const normalized = firstTarget.replace(/\/+$/, '') || '/';
      if (CRITICAL_PATHS.includes(normalized)) {
        return `rm -rf sur "${firstTarget}" — chemin système bloqué`;
      }
    }
  }

  // ── 2. eval comme commande shell ──────────────────────────────
  // Bloque : eval "…"  /  ; eval …  /  && eval …
  // Ne bloque PAS : node -e "… eval(…) …"  (eval en JavaScript)
  if (/(?:^|[;|&]\s*)\s*eval\b/.test(c)) {
    const evalPos = c.search(/\beval\b/);
    const before = c.slice(0, evalPos);
    if (!/\bnode\s+-e\b/.test(before)) {
      return 'eval utilisé comme commande shell';
    }
  }

  // ── 3. exec (remplace le processus shell) ─────────────────────
  // Bloque : exec bash / exec python / exec /usr/bin/…
  // Ne bloque PAS : exec 3< file  (redirection de file descriptor)
  if (/(?:^|[;|&]\s*)\s*exec\s+[a-zA-Z\/]/.test(c)) {
    return 'exec détecté — remplacement du processus shell';
  }

  // ── 4. Fork bomb ───────────────────────────────────────────────
  if (/:\(\s*\)\s*\{/.test(c)) {
    return 'fork bomb détectée';
  }

  // ── 5. Pipe vers un shell (injection de code) ─────────────────
  // Bloque : curl … | sh / wget … | bash / base64 -d | zsh / …
  if (/\|\s*(sh|bash|zsh|dash)\b/.test(low)) {
    return 'pipe vers un shell — risque d\'injection de code';
  }

  // ── 6. dd vers périphérique bloc ───────────────────────────────
  if (/\bdd\b/.test(low) && /of=\/dev\/[a-z]/.test(low)) {
    return 'dd vers périphérique bloc bloqué';
  }

  // ── 7. mkfs (formatage disque) ─────────────────────────────────
  if (/\bmkfs/.test(low)) {
    return 'formatage disque détecté (mkfs)';
  }

  // ── 8. shred (suppression sécurisée irréversible) ─────────────
  if (/\bshred\b/.test(low)) {
    return 'shred détecté — suppression irréversible';
  }

  // ── 9. sudo (élévation de privileges) ─────────────────────────
  if (/\bsudo\b/.test(low)) {
    return 'sudo détecté — élévation de privileges non autorisée';
  }

  return null; // ✓ Safe
}
