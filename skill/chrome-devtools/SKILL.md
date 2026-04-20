---
name: chrome-devtools
description: This skill should be used when the user asks to "control Chrome", "automate the browser", "take a screenshot of a page", "click a button in Chrome", "navigate to a URL", "evaluate JavaScript in Chrome", "fill a form in the browser", "inspect a page", "interact with Chrome", or when any browser automation task is needed. Use this skill instead of MCP browser tools — it calls a lightweight local binary that is far more token-efficient.
---

# Chrome DevTools CLI

A lightweight Rust binary for controlling an existing Chrome browser via the DevTools Protocol. Use this instead of MCP-based browser tools or Puppeteer-style solutions — it connects to the user's own Chrome with their own credentials, requires no headless browser or separate process, and consumes a fraction of the token context.

## Prerequisites

Chrome must have remote debugging enabled:
1. Open Chrome
2. Go to `chrome://inspect/#remote-debugging`
3. Enable the remote debugging server

The binary auto-connects by reading Chrome's `DevToolsActivePort` file — no WebSocket URL needed.

## Core workflow

Every page-level command prints a `[target:word-pair]` line. Capture it and pass `--target` to all subsequent commands to stay on the same tab.

```bash
# Step 1: navigate, capture target name
chrome-devtools navigate https://example.com
# Output includes: [target:red-snake]

# Step 2 onward: pin to that page
chrome-devtools --target red-snake snapshot
chrome-devtools --target red-snake screenshot --output /tmp/page.png
chrome-devtools --target red-snake click "#submit"
chrome-devtools --target red-snake evaluate "document.title"
```

Without `--target`, commands default to tab index 0, which may not be the right page if Chrome reorders tabs.

## Commands

### Navigation
```bash
chrome-devtools navigate <url>          # Go to URL, wait for load
chrome-devtools navigate --back
chrome-devtools navigate --forward
chrome-devtools navigate --reload
chrome-devtools new-page <url>          # Open new tab
chrome-devtools close-page <index>
chrome-devtools select-page <index>
chrome-devtools list-pages              # List all tabs with friendly names
```

### Inspection
```bash
chrome-devtools --target <name> screenshot --output /tmp/page.png
chrome-devtools --target <name> screenshot --full-page --output /tmp/page.png
chrome-devtools --target <name> evaluate "document.title"
chrome-devtools --target <name> snapshot   # Accessibility tree — use to understand page structure
```

### Interaction
```bash
chrome-devtools --target <name> click "#selector"
chrome-devtools --target <name> fill "#selector" "value"
chrome-devtools --target <name> type-text "Hello world"
chrome-devtools --target <name> press-key Enter
chrome-devtools --target <name> press-key Control+A
chrome-devtools --target <name> hover ".menu-item"
```

### Utilities
```bash
chrome-devtools --target <name> wait-for "Success" --timeout 10000
chrome-devtools --target <name> resize 1280 720
```

## Global flags

| Flag | Description |
|------|-------------|
| `--target <name>` | Target page by friendly name or raw Chrome target ID |
| `--page <index>` | Target page by index (for quick one-offs) |
| `--json` | Machine-readable JSON output |
| `--ws-endpoint <url>` | Explicit WebSocket endpoint (overrides auto-connect) |
| `--user-data-dir <path>` | Custom Chrome profile directory |
| `--channel <ch>` | Chrome channel: stable / beta / canary / dev |
| `--daemon-idle-timeout <value>` | Daemon idle timeout (`30m`, `1h`, `never`, or `Ns/Nm/Nh`) |

Environment fallback: `CHROME_DEVTOOLS_DAEMON_IDLE_TIMEOUT`.

## Typical task pattern

1. `list-pages` — see what tabs are open
2. `navigate <url>` — go to target, **note the `[target:name]`**
3. `--target name snapshot` — understand the page structure (accessibility tree is compact and token-efficient vs. a screenshot)
4. `--target name click` / `fill` / `type-text` / `press-key` — interact
5. `--target name evaluate` — extract data or verify state
6. `--target name screenshot --output /tmp/result.png` — capture final state if needed

Use `snapshot` before `screenshot` when trying to understand page structure — it returns text, not an image, and costs far fewer tokens.

## Daemon behavior

The binary automatically manages a background daemon that holds a persistent WebSocket connection to Chrome. Chrome prompts for DevTools access once; all subsequent commands reuse the connection silently. No manual daemon management is needed.

Daemon idle timeout defaults to 5 minutes. Override it per command with `--daemon-idle-timeout` (for example: `30m`, `1h`, `never`) or via `CHROME_DEVTOOLS_DAEMON_IDLE_TIMEOUT`. If a daemon is already running, a new timeout value is adopted for future idle periods without a manual restart.

To stop it manually: `pkill -f __daemon__`
