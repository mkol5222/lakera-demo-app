# Changelog

All notable changes to **Lakera Guard Demo**. The newest version is always on the [latest release](../../releases/latest) page; update with the [one-line installer](README.md#quick-start-one-command).

## [0.1.2] - 2026-11-18

### Added
- **Windows support**: Windows 10/11 x64 build (`Lakera-Guard-Demo_windows-x64-setup.exe`). The installer is per-user, so no admin rights are needed.
- **One-line install and upgrade on Windows**: `irm https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.ps1 | iex`. It downloads the latest release, verifies its SHA-256 checksum, installs silently and starts the app.
- On Windows, API keys are stored in **Windows Credential Manager**. The Settings screen names the credential store your platform uses.

## [0.1.1] - 2026-11-18

### Added
- **Playground result view**: a large BLOCKED / ALLOWED verdict, a summary of which detectors flagged the prompt, latency and request ID.
- **Detector breakdown** in Playground: every detector Guard evaluated is listed with a 5-step confidence meter (*Unlikely* to *Confident*). Detectors that fired are listed first and highlighted.
- **Raw API request / response** panel in Playground: collapsed by default, showing the exact JSON sent to `/v2/guard` (without the API key) and the unmodified Guard response, each with a **Copy** button.
- Press **⌘ + Enter** in Playground to screen the prompt.

## [0.1.0] - 2026-11-18

First release.

### Added
- **Prompt Roulette**: screen a random prompt from the downloaded datasets live with Lakera Guard. **TRY MORE** spins again, and a session score strip tracks the results.
- **Datasets**: one-click download of the public evaluation datasets recommended by Lakera from Hugging Face (Salad-Data, ALERT, Vigil, ChatGPT-Jailbreak-Prompts, ToxicQAFinal, SQuAD 2.0), with preview, re-download and delete.
- **Replay**: batch-replay a dataset to Guard (first N or a random sample, configurable concurrency) with live detection or false-positive rate, latency and per-detector counts.
- **Playground**: screen a single prompt.
- **Settings**: Lakera API key and optional Hugging Face token stored in the macOS Keychain. Configurable endpoint, project ID, concurrency and timeout.
- Universal macOS build (Apple Silicon and Intel) and a one-line `curl | bash` installer with SHA-256 verification.

[0.1.2]: ../../releases/tag/v0.1.2
[0.1.1]: ../../releases/tag/v0.1.1
[0.1.0]: ../../releases/tag/v0.1.0
