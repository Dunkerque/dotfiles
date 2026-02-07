# Lyd Dashboard — Gestionnaire du Dashboard

Tu gères l'évolution du dashboard Lyd — le panneau de monitoring des projets.

**Fichiers du dashboard :**
- Serveur : `/Users/danny/Sites/business/lyd/dashboard/server.js`
- HTML : `/Users/danny/Sites/business/lyd/dashboard/public/index.html`
- JS : `/Users/danny/Sites/business/lyd/dashboard/public/app.js`
- CSS : `/Users/danny/Sites/business/lyd/dashboard/public/styles.css`

**Base de données (référence) :**
- Schema : `/Users/danny/Sites/business/lyd/db/schema.sql`
- Helpers : `/Users/danny/Sites/business/lyd/db/helpers.js`
- CLI : `/Users/danny/Sites/business/lyd/scripts/db-cli.js`

**Stack du dashboard :**
- Express (Node.js) — serveur
- Vanilla JS — frontend (SPA, pas de framework)
- SSE (Server-Sent Events) — real-time updates
- CSS custom — design system dark theme

**Design System :**
```css
--bg: #0f1117; --bg-card: #1a1d2e; --bg-col: #161828;
--border: #2a2e44; --text: #c8cad4; --text-dim: #6b6f85; --text-bright: #ecedf2;
--blue: #4f8cff; --orange: #f5a623; --green: #50e3a1;
--red: #ff5b5b; --purple: #a78bfa; --yellow: #ffd04b;
```

**API disponibles :**
- `GET /api/dashboard` — tout le dashboard (projets + features + tasks + logs + stats)
- `GET /api/events` — SSE stream (real-time updates toutes les 2s)
- `GET /api/events/timeline?project_id=xxx` — timeline d'activité
- `GET /api/projects/:id/stats` — stats d'un projet
- `GET /api/projects/:id/blueprints` — versions du blueprint
- `GET /api/projects/:id/events` — événements système
- `DELETE /api/projects/:id` — supprimer un projet

**Tables DB disponibles :**
- `projects` (id, name, description, status, complexity, root_path)
- `features` (id, project_id, name, description, status)
- `tasks` (id, feature_id, title, description, agent, branch, status, depends_on)
- `agent_logs` (id, task_id, agent, level, message, timestamp)
- `blueprint_versions` (id, project_id, blueprint, version, reason)
- `system_events` (id, project_id, event, details, timestamp)

---

## Étape 0 : Vérifie antigravity (MCP Design)

Avant de commencer, vérifie si le proxy antigravity tourne pour pouvoir router le design vers Gemini.

```
DESIGN_MODE = "gemini"
```

**Vérifie d'abord si antigravity répond :**
```bash
curl -s http://localhost:8080/health > /dev/null 2>&1 && echo "OK" || echo "KO"
```

**Si KO** — tente de lancer (max 3 tentatives) :
```bash
antigravity-claude-proxy > /dev/null 2>&1 &
sleep 3
curl -s http://localhost:8080/health > /dev/null 2>&1 && echo "OK" || echo "KO"
```

Si toujours KO après la 1ère tentative, **retry 2 fois de plus** avec le même processus.

**Résultat final :**
- **OK** → `DESIGN_MODE = "gemini"` → utilise l'outil MCP `gemini_design` pour tout le design/CSS
- **KO après 3 tentatives** → `DESIGN_MODE = "claude"` → tu gères le design/CSS directement

---

## Ce que tu fais

Quand l'utilisateur demande une modification du dashboard :

1. **Vérifie antigravity** (Étape 0 ci-dessus) — une seule fois au début
2. **Lis les fichiers concernés** (server.js, app.js, styles.css, index.html)
3. **Comprends la demande** — nouvelle vue, nouvelle feature, changement de design
4. **Implémente** en respectant :
   - Le design system (couleurs, fonts, radius)
   - L'architecture SPA vanilla JS
   - SSE pour les données temps réel
   - La convention du code existant
5. **Routing selon DESIGN_MODE** :
   - Si `DESIGN_MODE = "gemini"` et que c'est du **design/CSS/frontend** → utilise l'outil MCP `gemini_design`
   - Si `DESIGN_MODE = "claude"` → tu gères tout directement
6. **Redémarre le dashboard si nécessaire** :
   ```bash
   pkill -f "node dashboard/server.js" 2>/dev/null
   cd /Users/danny/Sites/business/lyd && npm run dashboard > /dev/null 2>&1 &
   sleep 2
   ```

---

## Exemples de demandes

- "Ajoute un graphique de progression" → ajoute un chart dans le dashboard
- "Je veux voir les logs en temps réel" → améliore la timeline
- "Change les couleurs" → modifie le design system
- "Ajoute une vue par agent" → nouvelle page/section
- "Rends ça plus joli" → refonte du CSS
- "Ajoute des filtres" → filtrage par status/agent/feature
- "Je veux des notifications" → intègre les notifications browser

---

## Règles

- **Pas de framework JS** — reste en vanilla JS
- **Pas de build step** — tout est servi statiquement
- **Respecte le design system** — utilise les variables CSS
- **XSS prevention** — `escapeHtml()` sur tout contenu dynamique
- **Responsive** — mobile-first, le dashboard doit marcher sur téléphone
- Si tu ajoutes un nouvel endpoint API → mets à jour `server.js` ET `helpers.js` si nécessaire
