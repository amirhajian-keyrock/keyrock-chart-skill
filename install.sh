#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing Keyrock Chart Skill..."

# Create directories
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/keyrock/assets
mkdir -p ~/.claude/keyrock/assets/fonts

# Copy command file
cp "$SCRIPT_DIR/commands/keyrock-chart.md" ~/.claude/commands/keyrock-chart.md

# Copy brand system and templates
cp "$SCRIPT_DIR/keyrock/brand-system.md" ~/.claude/keyrock/brand-system.md
cp "$SCRIPT_DIR/keyrock/chart-templates.md" ~/.claude/keyrock/chart-templates.md

# Copy logo assets
cp "$SCRIPT_DIR/keyrock/assets/"*.png "$SCRIPT_DIR/keyrock/assets/"*.svg ~/.claude/keyrock/assets/

# Copy FK Grotesk Neue font files
cp "$SCRIPT_DIR/keyrock/assets/fonts/"*.ttf ~/.claude/keyrock/assets/fonts/

echo ""
echo "Keyrock Chart Skill installed successfully."
echo ""
echo "Files installed:"
echo "  ~/.claude/commands/keyrock-chart.md"
echo "  ~/.claude/keyrock/brand-system.md"
echo "  ~/.claude/keyrock/chart-templates.md"
echo "  ~/.claude/keyrock/assets/ (logo files)"
echo "  ~/.claude/keyrock/assets/fonts/ (FK Grotesk Neue TTF fonts)"
echo ""
echo "Usage: Open Claude Code and type /keyrock-chart"
