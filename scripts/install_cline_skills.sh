#!/bin/bash
# Install Cline Skills from this repository
# Usage:
#   ./scripts/install_cline_skills.sh --global     # Install to ~/.cline/skills/
#   ./scripts/install_cline_skills.sh --project    # Install to .cline/skills/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_SOURCE="$REPO_DIR/skills"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

install_skills() {
    local target_dir="$1"
    
    if [ ! -d "$SKILLS_SOURCE" ]; then
        echo "Error: Skills directory not found at $SKILLS_SOURCE"
        exit 1
    fi
    
    mkdir -p "$target_dir"
    
    echo -e "${BLUE}Installing Cline Skills to $target_dir${NC}"
    
    for skill_dir in "$SKILLS_SOURCE"/*/; do
        if [ -d "$skill_dir" ] && [ -f "$skill_dir/SKILL.md" ]; then
            skill_name=$(basename "$skill_dir")
            echo -e "  ${GREEN}✓${NC} $skill_name"
            cp -r "$skill_dir" "$target_dir/"
        fi
    done
    
    echo -e "${GREEN}Done! Skills installed to $target_dir${NC}"
    echo ""
    echo "Make sure Skills are enabled in Cline:"
    echo "  Settings → Features → Enable Skills"
}

case "${1:-}" in
    --global)
        install_skills "$HOME/.cline/skills"
        ;;
    --project)
        install_skills "$(pwd)/.cline/skills"
        ;;
    *)
        echo "Usage: $0 --global | --project"
        echo ""
        echo "  --global    Install skills to ~/.cline/skills/ (available across all projects)"
        echo "  --project   Install skills to .cline/skills/ (current project only)"
        exit 1
        ;;
esac
