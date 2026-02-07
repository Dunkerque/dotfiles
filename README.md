# Dotfiles

Configuration personnelle pour bash, vim, tmux et Claude Code.

## 📦 Contenu

### Configuration système
- `.bash_profile` - Configuration bash
- `.vimrc` - Configuration vim
- `.tmux.conf` - Configuration tmux

### Claude Code
- `claude/CLAUDE.md` - Configuration globale Claude Code
- `claude/settings.json` - Settings Claude Code
- `claude/commands/` - Skills disponibles :
  - `introspection.md` - Sparring partner cognitif
  - `lyd.md` - Orchestrateur de projets Lyd
  - `lyd-dashboard.md` - Gestionnaire du dashboard Lyd
  - `ytp.md` - YouTube Productor
- `claude/memory/` - Mémoire auto persistante

## 🚀 Installation

### Installation complète

```bash
git clone git@github.com:Dunkerque/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install-claude.sh
```

### Installation sélective

**Dotfiles système uniquement :**
```bash
ln -sf ~/.dotfiles/.bash_profile ~/
ln -sf ~/.dotfiles/.vimrc ~/
ln -sf ~/.dotfiles/.tmux.conf ~/
```

**Claude Code uniquement :**
```bash
./install-claude.sh
```

## 📝 Synchronisation

### Depuis local vers repo

```bash
# Depuis ~/.dotfiles
git add .
git commit -m "Update config"
git push
```

### Depuis repo vers serveur

```bash
# Sur le serveur
cd ~/.dotfiles
git pull
./install-claude.sh
```

## 🔗 Dépendances

### Framework Lyd

Le framework Lyd est dans un repo séparé. Pour l'installer :

```bash
# Cloner le repo Lyd
git clone [URL_DU_REPO_LYD] ~/Sites/business/lyd

# Installer les skills globalement
cd ~/Sites/business/lyd
./install-global.sh
```

## 🛡️ Sécurité

⚠️ **Attention** : Les fichiers de mémoire auto (`claude/memory/`) peuvent contenir des informations personnelles. Vérifie leur contenu avant de pousser sur un repo public.

## 📄 License

Configuration personnelle - Utilise à tes risques et périls !
