#!/bin/bash

# Installation de la configuration Claude Code
# Usage: ./install-claude.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_MEMORY_DIR="$CLAUDE_DIR/projects/-Users-$(whoami)/memory"

echo "🚀 Installation de la configuration Claude Code..."

# Créer les répertoires nécessaires
echo "📁 Création des répertoires..."
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_MEMORY_DIR"

# Fonction de backup
backup_if_exists() {
    local file=$1
    if [ -f "$file" ]; then
        echo "⚠️  Backup de $file vers $file.backup"
        mv "$file" "$file.backup"
    fi
}

# Copier CLAUDE.md global
echo "📄 Installation de CLAUDE.md global..."
backup_if_exists "$CLAUDE_DIR/CLAUDE.md"
cp "$SCRIPT_DIR/claude/CLAUDE.md" "$CLAUDE_DIR/"

# Copier les settings
echo "⚙️  Installation des settings..."
backup_if_exists "$CLAUDE_DIR/settings.json"
cp "$SCRIPT_DIR/claude/settings.json" "$CLAUDE_DIR/"

if [ -f "$SCRIPT_DIR/claude/settings.local.json" ]; then
    backup_if_exists "$CLAUDE_DIR/settings.local.json"
    cp "$SCRIPT_DIR/claude/settings.local.json" "$CLAUDE_DIR/"
fi

# Copier les skills
echo "🛠️  Installation des skills..."
for skill in "$SCRIPT_DIR/claude/commands"/*.md; do
    skill_name=$(basename "$skill")
    backup_if_exists "$CLAUDE_DIR/commands/$skill_name"
    cp "$skill" "$CLAUDE_DIR/commands/"
    echo "   ✅ $skill_name"
done

# Copier la mémoire auto
echo "🧠 Installation de la mémoire auto..."
for memory_file in "$SCRIPT_DIR/claude/memory"/*.md; do
    memory_name=$(basename "$memory_file")
    backup_if_exists "$CLAUDE_MEMORY_DIR/$memory_name"
    cp "$memory_file" "$CLAUDE_MEMORY_DIR/"
    echo "   ✅ $memory_name"
done

# Copier les hooks
echo "🔒 Installation des hooks..."
if [ -d "$SCRIPT_DIR/claude/hooks" ]; then
    for hook in "$SCRIPT_DIR/claude/hooks"/*.js; do
        if [ -f "$hook" ]; then
            hook_name=$(basename "$hook")
            backup_if_exists "$CLAUDE_DIR/hooks/$hook_name"
            cp "$hook" "$CLAUDE_DIR/hooks/"
            chmod +x "$CLAUDE_DIR/hooks/$hook_name"
            echo "   ✅ $hook_name"
        fi
    done
fi

echo ""
echo "✨ Installation terminée !"
echo ""
echo "📋 Configuration installée :"
echo "   - CLAUDE.md global"
echo "   - Settings"
echo "   - $(ls "$SCRIPT_DIR/claude/commands" | wc -l | tr -d ' ') skills"
echo "   - $(ls "$SCRIPT_DIR/claude/memory" | wc -l | tr -d ' ') fichiers de mémoire"
if [ -d "$SCRIPT_DIR/claude/hooks" ]; then
    echo "   - $(ls "$SCRIPT_DIR/claude/hooks" 2>/dev/null | wc -l | tr -d ' ') hooks"
fi
echo ""
echo "ℹ️  Les anciens fichiers ont été sauvegardés en .backup"
echo ""
echo "🎯 Prochaines étapes :"
echo "   1. Installer le framework Lyd depuis son repo dédié"
echo "   2. Relancer Claude Code pour charger la config"
echo ""
