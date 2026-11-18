# Lakera Guard Demo

[![Latest release](https://img.shields.io/github/v/release/mkol5222/lakera-demo-app?label=download)](../../releases/latest) · [Changelog](CHANGELOG.md)

A ready-to-run desktop app for **macOS** and **Windows** for demoing **Lakera Guard (AI Guardrails)** with real-world jailbreak, prompt-injection and benign prompts.

![Prompt Roulette](docs/roulette.png)

## What it does

| | |
|---|---|
| 🎲 **Prompt Roulette** | Picks a random prompt from the downloaded datasets, screens it live with Lakera Guard, and shows **BLOCKED / ALLOWED**, the detectors that fired, the latency, and whether Guard got it right. Hit **TRY MORE** for the next one. |
| 📚 **Datasets** | One-click download of the public evaluation datasets [recommended by Lakera](https://docs.lakera.ai/docs/datasets) from Hugging Face: Salad-Data, ALERT, Vigil, ChatGPT-Jailbreak-Prompts, ToxicQAFinal and SQuAD 2.0 (benign, for false-positive checks). |
| ▶️ **Replay** | Batch-replays a dataset (first N rows or a random sample) to the [Guard API](https://docs.lakera.ai/docs/api/screening-roles), with live detection rate or false-positive rate, latency and per-detector counts. |
| 🧪 **Playground** | Screen any prompt you type and see the verdict, a per-detector confidence breakdown and, optionally, the raw API request and response. |
| 🔐 **Settings** | Your Lakera API key (and optional Hugging Face token) is stored in the OS credential store (**macOS Keychain** / **Windows Credential Manager**), never in a file. You can also set the endpoint, project ID (policy) and concurrency. |

![Datasets](docs/datasets.png)

![Replay](docs/replay.png)

![Playground](docs/playground.png)

<sub>The screenshots show the UI with prompts from the real datasets and sample Guard verdicts.</sub>

## Install

| Platform | Quick start (install **and** upgrade) | Manual download |
|---|---|---|
| **macOS** 11+ (Apple Silicon and Intel) | `curl -fsSL https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.sh \| bash` | `Lakera-Guard-Demo_macos-universal.dmg` |
| **Windows** 10/11 x64 | `irm https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.ps1 \| iex` | `Lakera-Guard-Demo_windows-x64-setup.exe` |

Both installers download the latest release over HTTPS, verify its SHA-256 checksum against `SHA256SUMS.txt`, install the app and start it.

### macOS

#### Quick start (one command)

```sh
curl -fsSL https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.sh | bash
```

This installs **Lakera Guard Demo.app** into `/Applications` (or `~/Applications` if `/Applications` isn't writable) and opens it. To read [`install.sh`](install.sh) first:

```sh
curl -fsSL https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.sh -o install.sh
less install.sh && bash install.sh
```

#### Manual install

1. Open **[Releases → Latest](../../releases/latest)** and download `Lakera-Guard-Demo_macos-universal.dmg`.
2. Open the DMG and drag **Lakera Guard Demo** into **Applications**.
3. The app is not notarized by Apple, so on first launch macOS will warn you. Either:
   - right-click the app → **Open** → **Open**, or
   - go to **System Settings → Privacy & Security** → **Open Anyway**, or
   - run `xattr -dr com.apple.quarantine "/Applications/Lakera Guard Demo.app"`.

### Windows

#### Quick start (one command, PowerShell)

```powershell
irm https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.ps1 | iex
```

This runs the per-user installer silently, so **no admin rights** are needed. The app goes into `%LOCALAPPDATA%\Lakera Guard Demo`, gets a Start-menu shortcut, and starts. To read [`install.ps1`](install.ps1) first:

```powershell
irm https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.ps1 -OutFile install.ps1
notepad install.ps1
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

#### Manual install

1. Open **[Releases → Latest](../../releases/latest)** and download `Lakera-Guard-Demo_windows-x64-setup.exe`.
2. Run it. The installer isn't code-signed, so SmartScreen may show *"Windows protected your PC"*. Click **More info → Run anyway**.
3. The app uses Microsoft Edge **WebView2**, which ships with Windows 11. On older systems the installer downloads it automatically.

## First run

A setup wizard opens on first start: paste your Lakera Guard API key, and it downloads the small *ChatGPT-Jailbreak-Prompts* dataset for you. You can reopen it later from **Settings → Run setup wizard**. To do it by hand:

1. **Settings** → paste your **Lakera Guard API key** → **Save** (it goes to the Keychain or Credential Manager). Optionally set a **Project ID** to use a specific Guard policy, then click **Test Guard connection**.
2. **Datasets** → download a small one to start, e.g. *ChatGPT-Jailbreak-Prompts* (79 prompts) or *Vigil* (104).
3. **Prompt Roulette** → **SPIN**, then **TRY MORE**.

Tips:
- Download *SQuAD 2.0* as well, so the roulette mixes in benign prompts and you can show there are no false positives.
- *ToxicQAFinal* is a content-moderation dataset. It is only flagged if your Guard project policy enables moderation detectors.
- Datasets are stored in `~/Library/Application Support/com.checkpoint.lakera-demo/datasets/` (macOS) or `%APPDATA%\com.checkpoint.lakera-demo\datasets\` (Windows).

## Updating

From version **0.1.3** the app updates itself. On startup it checks GitHub Releases and, if a newer version exists, shows what's new and offers **Update & restart**. Updates are signature-verified before they are installed. You can also click **Check for updates** at the top of **Settings**, or turn off the startup check in **Settings → General**. **Settings → Changelog** shows what's new in each version.

You can always run the same one-line installer again instead (`curl … | bash` on macOS, `irm … | iex` on Windows); versions 0.1.2 and older need this once. Settings, keys and datasets are kept. See [CHANGELOG.md](CHANGELOG.md) for what's new.

## Uninstall

**macOS**

```sh
rm -rf "/Applications/Lakera Guard Demo.app" ~/Library/Application\ Support/com.checkpoint.lakera-demo
security delete-generic-password -s com.checkpoint.lakera-demo -a lakera-guard-api-key 2>/dev/null
security delete-generic-password -s com.checkpoint.lakera-demo -a huggingface-token 2>/dev/null
```

**Windows (PowerShell)**

```powershell
& "$env:LOCALAPPDATA\Lakera Guard Demo\uninstall.exe"
Remove-Item -Recurse -Force "$env:APPDATA\com.checkpoint.lakera-demo" -ErrorAction SilentlyContinue
cmdkey /delete:lakera-guard-api-key.com.checkpoint.lakera-demo
cmdkey /delete:huggingface-token.com.checkpoint.lakera-demo
```

---

This repository distributes the built app only.
