#!/usr/bin/env bash
# ==============================================================================
#  ⚡ One-Line Installer for `shortcuts`
#  Installs `shortcuts` on Termux, PRoot Distro, Linux, macOS, and WSL.
# ==============================================================================

set -e

# Terminal Colors
BOLD="\033[1m"
CYAN="\033[0;36m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
WHITE="\033[1;37m"
GRAY="\033[0;90m"
RED="\033[0;31m"
RESET="\033[0m"

echo ""
echo -e "${CYAN}╭──────────────────────────────────────────────────────────────╮${RESET}"
echo -e "${CYAN}│  ${BOLD}${WHITE}⚡ INSTALLING SHORTCUTS CLI${RESET}${CYAN}                                 │${RESET}"
echo -e "${CYAN}│  ${DIM}Fast, noise-free installed tools & shortcuts detector${RESET}${CYAN}      │${RESET}"
echo -e "${CYAN}╰──────────────────────────────────────────────────────────────╯${RESET}"
echo ""

REPO="0xposa/shortcuts"
BRANCH="main"
RAW_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/bin/shortcuts"

# Determine target directory
if [ -n "$PREFIX" ] && [ -d "$PREFIX/bin" ] && [ -w "$PREFIX/bin" ]; then
    INSTALL_DIR="$PREFIX/bin"
elif [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
elif command -v sudo >/dev/null 2>&1; then
    USE_SUDO="sudo"
    INSTALL_DIR="/usr/local/bin"
else
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
fi

TARGET="${INSTALL_DIR}/shortcuts"
echo -e "  ${GRAY}Target path :${RESET} ${WHITE}${TARGET}${RESET}"

# Download
echo -e "  ${GRAY}Downloading :${RESET} ${CYAN}${RAW_URL}${RESET}..."

if command -v curl >/dev/null 2>&1; then
    ${USE_SUDO} curl -fsSL "$RAW_URL" -o "$TARGET"
elif command -v wget >/dev/null 2>&1; then
    ${USE_SUDO} wget -qO "$TARGET" "$RAW_URL"
else
    echo -e "${RED}✖ Error: curl or wget is required to install shortcuts.${RESET}" >&2
    exit 1
fi

${USE_SUDO} chmod +x "$TARGET"

# Check if INSTALL_DIR is in PATH
case ":$PATH:" in
    *:"$INSTALL_DIR":*) ;;
    *)
        echo -e "  ${YELLOW}⚠ Notice : ${INSTALL_DIR} is not in your \$PATH.${RESET}"
        echo -e "    Add this to your ~/.bashrc or ~/.zshrc: ${BOLD}export PATH=\"\$PATH:${INSTALL_DIR}\"${RESET}"
        ;;
esac

echo ""
echo -e "${GREEN}${BOLD}✔ Successfully installed \`shortcuts\` to ${TARGET}!${RESET}"
echo ""
echo -e "${WHITE}You can now run:${RESET}"
echo -e "  ${GREEN}${BOLD}shortcuts${RESET}          # Show all installed tools & shortcuts"
echo -e "  ${GREEN}${BOLD}shortcuts <query>${RESET}  # Search specific tool (e.g. shortcuts agy)"
echo -e "  ${GREEN}${BOLD}shortcuts --help${RESET}   # View help options"
echo ""
