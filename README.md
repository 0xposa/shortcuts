# ⚡ shortcuts

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform: Termux | Linux | macOS | Windows](https://img.shields.io/badge/Platform-Termux%20%7C%20Linux%20%7C%20macOS%20%7C%20Windows-blue.svg)](#supported-platforms)
[![Shell: Bash & PowerShell](https://img.shields.io/badge/Shell-Bash%20%7C%20PowerShell-green.svg)](#installation)

> **A lightning-fast, noise-free CLI catalog for your installed developer tools, custom scripts, launchers, and aliases.**

---

## 💡 Why `shortcuts`?

Ever installed developer tools, CLI agents, custom scripts, and desktop launchers, only to forget their shortcut names a week later?

Most terminal inspectors dump **hundreds of irrelevant system binaries**, Python pip entry points (`fastapi`, `idna`, `uvicorn`, `playwright`), OS compatibility shims (`xdg-open`, `sudo`), and boilerplate shell aliases (`ls`, `ll`, `la`).

**`shortcuts` solves this by:**
1. **Grouping strictly by the installed application/package** (e.g. *Google Antigravity*, *OpenCode*, *Desktop GUI*, *Brave Browser*, *Shizuku*), showing the primary command and all its alternative aliases.
2. **Filtering out all background noise** so only what you deliberately installed is shown.
3. **Zero-fork execution**: Built with pure shell memory matching, executing in **< 1 second** even inside Android PRoot Distros with high `ptrace` overhead.

---

## 📺 Preview

```text
╭──────────────────────────────────────────────────────────────╮
│  ⚡ INSTALLED TOOLS & SHORTCUTS                              │
│  Grouped by each installed tool & package                    │
╰──────────────────────────────────────────────────────────────╯
  Platform : Termux (PRoot Debian 13.7)  | Shell : bash

📦 Google Antigravity
────────────────────────────────────────────────────────────────
  agy              (agy-claude          ) Google Antigravity AI Agent
  agy-switcher     (agy-rotation        ) Account Switcher & Auto-Rotation

📦 OpenCode
────────────────────────────────────────────────────────────────
  opencode         (opencode2           ) Autonomous AI Coding Agent

📦 Appdroid
────────────────────────────────────────────────────────────────
  appdroid         (app                 ) Android Application & APK Manager

📦 Desktop Environment (XFCE / X11)
────────────────────────────────────────────────────────────────
  desktop          (xfce, lxqt, start   ) Start X11 GUI desktop session
  kill-desktop     (stop-desktop, stop-xfce) Stop X11 GUI desktop session
  xfce-tiling                             Window tiling manager for XFCE

📦 Brave Browser
────────────────────────────────────────────────────────────────
  brave            (brave-desktop, ext  ) Brave Web Browser launcher

📦 Chromium Browser
────────────────────────────────────────────────────────────────
  chrome-desktop   (chromium, chrome-x11) Chromium Web Browser launcher

📦 Shutdown Timer
────────────────────────────────────────────────────────────────
  sdtimer          (shutdown-timer      ) Countdown timer for sleep/shutdown

📦 Shizuku
────────────────────────────────────────────────────────────────
  rish                                    Privileged Android terminal access via Shizuku

📦 NourIDE
────────────────────────────────────────────────────────────────
  nouride                                 Code editor launcher

📦 Termux-X11
────────────────────────────────────────────────────────────────
  termux-x11-show                         Bring Termux-X11 window to foreground

📦 Google Pro
────────────────────────────────────────────────────────────────
  googlepro        (gpro                ) Google Pro assistant script

🔗 Navigation Aliases
────────────────────────────────────────────────────────────────
  android / sdcard     → cd /sdcard
  termux / termux-home → cd /data/data/com.termux/files/home

────────────────────────────────────────────────────────────────
  📊 SUMMARY : 11 Installed Tools & 2 Navigation Aliases (16 total shortcuts)
────────────────────────────────────────────────────────────────
```

---

## 🚀 One-Line Installation

### Linux / Termux / PRoot Distro / macOS / WSL

Run this single command in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/0xposa/shortcuts/main/install.sh | bash
```

*Or with `wget`:*
```bash
wget -qO- https://raw.githubusercontent.com/0xposa/shortcuts/main/install.sh | bash
```

---

### Windows (PowerShell)

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/0xposa/shortcuts/main/install.ps1 | iex
```

---

## 🕹️ Usage

### 1. Show All Installed Tools
```bash
shortcuts
```

### 2. Search / Filter by Keyword
Quickly check shortcuts for a specific tool:
```bash
shortcuts agy
shortcuts opencode
shortcuts desktop
shortcuts timer
```

### 3. Show Raw / Unfiltered Binaries (Optional)
If you ever want to see all raw binaries (including pip packages & system shims):
```bash
shortcuts --all
```

### 4. Help
```bash
shortcuts --help
```

---

## ✨ Features

* 📦 **Per-Tool Grouping**: Commands are organized under their parent application name, not broad abstract buckets.
* ⚡ **Blazing Fast**: Uses pure Bash built-ins (no repeated subshell forks), running in under a second on mobile hardware.
* 🧹 **Smart Noise Gate**: Automatically detects and hides pip packages, temporary files, backup files, and OS shims.
* 🔍 **Instant Filter**: Type `shortcuts <name>` to isolate only the tools matching your query.
* 📱 **First-Class Termux & PRoot Support**: Tailored to run flawlessly inside native Termux and PRoot Linux containers.
* 🖥️ **Cross-Platform**: Complete support for Linux, Termux, PRoot, macOS, and Windows PowerShell.

---

## 🗑️ Uninstallation

### Linux / Termux / PRoot:
```bash
rm -f /usr/local/bin/shortcuts "$PREFIX/bin/shortcuts" "$HOME/.local/bin/shortcuts"
```

### Windows (PowerShell):
```powershell
Remove-Item "$HOME\.local\bin\shortcuts.*" -Force
```

---

## 📄 License

Distributed under the [MIT License](LICENSE).
Created with ❤️ by [@0xposa](https://github.com/0xposa).
