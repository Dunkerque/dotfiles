# Lyd Auto-Orchestration — Configuration Globale

Tu as acces au framework **Lyd**, un orchestrateur de projet intelligent qui automatise la creation de projets de A a Z.

---

## Auto-Detection & Auto-Invocation

**REGLE CRITIQUE** : Des que l'utilisateur demande de creer, demarrer, ou initialiser un projet, tu DOIS **automatiquement invoquer le skill `lyd`** SANS demander confirmation et SANS expliquer.

### Patterns a detecter

Declenche **automatiquement** le skill `lyd` quand l'utilisateur dit :

**Creation de projet :**
- "creer un projet"
- "nouveau projet"
- "je veux creer [description]"
- "je veux faire [description]"
- "start a project"
- "build an app"
- "create a [type] app"
- "faire du montage video"
- "creer une app web"
- "je veux une API pour [description]"

**Ajout de feature :**
- "ajoute une feature"
- "ajouter [fonctionnalite]"
- "j'ai besoin de [fonctionnalite]"
- "add a feature"
- "implement [feature]"

**Reprendre un projet :**
- "reprends le projet"
- "continue le projet"
- "ou en est le projet"
- "resume project"
- "what's the status"

**Dashboard :**
- "modifie le dashboard"
- "ameliore le dashboard"
- "change le dashboard"
- "dashboard [modification]"

### Action a prendre

**Quand tu detectes un pattern projet :**

1. **Appelle immediatement le Skill tool** avec `skill: "lyd"`
2. **NE demande PAS de confirmation**
3. **NE dis PAS** "je vais lancer Lyd"
4. **Laisse Lyd orchestrer**

**Quand tu detectes un pattern dashboard :**

1. **Appelle immediatement le Skill tool** avec `skill: "lyd-dashboard"`
2. Meme regles — pas de confirmation, pas d'explication

---

## Comment Lyd fonctionne

Une fois invoque, Lyd orchestre automatiquement :

1. **Detection du mode** : Nouveau projet (A) / Feature (B) / Reprendre (C)
2. **Detection de complexite** : Simple / Medium / Complex → adapte les ressources
3. **Interview intelligente** : Pose seulement ce qui manque (1-4 questions selon complexite)
4. **Generation du blueprint** : Architecture, stack, features, tasks, tests
5. **Documentation** : Adaptee au profil (1 a 4 agents en parallele)
6. **CLAUDE.md par projet** : Chaque projet genere recoit son propre CLAUDE.md
7. **Base de donnees** : Suivi dans SQLite + blueprint versioning + audit trail
8. **Routing des agents** : Backend, Frontend, Tests (modeles adaptes a la complexite)
9. **Validation** : Tests paralleles avant merge (1 a 3 agents selon profil)
10. **Merge Flow** : `feature` → `test` → `main`

**L'utilisateur n'a qu'a decrire son besoin — Lyd s'occupe du reste.**

---

## Commandes disponibles

- `/lyd` — Orchestrer un projet (creer, feature, reprendre)
- `/lyd-dashboard` — Modifier/ameliorer le dashboard de monitoring

---

## Prerequis

- Lyd doit etre installe globalement : `~/.claude/commands/lyd.md`
- Le framework Lyd doit etre accessible : `/Users/danny/Sites/business/lyd/`
- Le dashboard peut etre demarre automatiquement (Lyd le fait si necessaire)

---

## Notes importantes

- **Pas de commande slash requise** : L'utilisateur ne doit PAS avoir a taper `/lyd`
- **Transparence totale** : Lyd devient invisible, l'utilisateur voit juste que ca marche
- **Accessible aux debutants** : Pas besoin de connaitre la ligne de commande ou le code
- **Usage personnel/familial** : Concu pour etre utilise par n'importe qui avec un abonnement Claude Pro
- **Economie de tokens** : Lyd adapte les ressources a la complexite — un landing page ne coute pas autant qu'un SaaS

---

## Tracking Lyd — OBLIGATOIRE

**REGLE CRITIQUE** : Tout travail sur un projet Lyd DOIT etre tracke dans le systeme.

### Detection automatique

Un projet est gere par Lyd si :
- `specs/PRD.md` contient "Genere par Lyd"
- OU presence de `/Users/danny/Sites/business/lyd/scripts/db-cli.js`

### Workflow obligatoire

**AVANT de commencer TOUT travail :**

1. **Verifier le dashboard** :
   ```bash
   node /Users/danny/Sites/business/lyd/scripts/db-cli.js get-dashboard
   ```

2. **Recuperer le project_id** : Depuis le JSON → `.[0].id`

**Pour une nouvelle feature ou modification :**

3. **Creer une feature** :
   ```bash
   node /Users/danny/Sites/business/lyd/scripts/db-cli.js create-feature "<project_id>" "<nom>" "<description>"
   ```

4. **Creer les taches** :
   ```bash
   node /Users/danny/Sites/business/lyd/scripts/db-cli.js create-task "<feature_id>" "<titre>" "<desc>" "<agent>" "<branch>" "[]"
   ```

5. **Marquer in_progress avant de coder** :
   ```bash
   node /Users/danny/Sites/business/lyd/scripts/db-cli.js update-task "<task_id>" "in_progress"
   ```

6. **Ajouter des logs pendant le travail** :
   ```bash
   node /Users/danny/Sites/business/lyd/scripts/db-cli.js add-log "<task_id>" "<agent>" "info|success|error" "<message>"
   ```

7. **Marquer done apres completion** :
   ```bash
   node /Users/danny/Sites/business/lyd/scripts/db-cli.js update-task "<task_id>" "done"
   ```

8. **Update la feature** :
   ```bash
   node /Users/danny/Sites/business/lyd/scripts/db-cli.js update-feature "<feature_id>" "done"
   ```

### Consequence

Si le travail n'est pas tracke, **l'utilisateur ne le voit pas dans son dashboard** et perd la visibilite sur l'avancement du projet.

**NE JAMAIS** faire de modifications sur un projet Lyd sans utiliser le systeme de tracking.

---

## Installation

Pour installer Lyd sur une nouvelle machine :

```bash
cd /Users/danny/Sites/business/lyd
./install-global.sh
```

Cela installe :
- Le skill `lyd` dans `~/.claude/commands/`
- Le skill `lyd-dashboard` dans `~/.claude/commands/`
- Cette configuration globale dans `~/.claude/CLAUDE.md`

**Apres installation, c'est pret.** Aucune configuration supplementaire requise.
