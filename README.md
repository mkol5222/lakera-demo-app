# Lakera Guard Demo

A ready-to-run **macOS app** for demoing **Lakera Guard (AI Guardrails)** with real-world jailbreak, prompt-injection and benign prompts.

![Prompt Roulette](docs/roulette.png)

## What it does

| | |
|---|---|
| 🎲 **Prompt Roulette** | Picks a random prompt from the downloaded datasets, screens it live with Lakera Guard, and shows **BLOCKED / ALLOWED**, the detectors that fired, the latency, and whether Guard got it right. Hit **TRY MORE** for the next one. |
| 📚 **Datasets** | One-click download of the public evaluation datasets [recommended by Lakera](https://docs.lakera.ai/docs/datasets) from Hugging Face: Salad-Data, ALERT, Vigil, ChatGPT-Jailbreak-Prompts, ToxicQAFinal and SQuAD 2.0 (benign, for false-positive checks). |
| ▶️ **Replay** | Batch-replays a dataset (first N rows or a random sample) to the [Guard API](https://docs.lakera.ai/docs/api/screening-roles), with live detection rate or false-positive rate, latency and per-detector counts. |
| 🧪 **Playground** | Screen any prompt you type. |
| 🔐 **Settings** | Your Lakera API key (and optional Hugging Face token) is stored in the **macOS Keychain**, never in a file. You can also set the endpoint, project ID (policy) and concurrency. |

![Datasets](docs/datasets.png)

![Replay](docs/replay.png)

<sub>The screenshots show the UI with prompts from the real datasets and sample Guard verdicts.</sub>

## Install

Requires macOS 11 or later, on Apple Silicon or Intel (universal build).

### Quick start (one command)

```sh
curl -fsSL https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.sh | bash
```

The script downloads the latest release over HTTPS and verifies its SHA-256 checksum. It then installs **Lakera Guard Demo.app** into `/Applications` (or `~/Applications` if `/Applications` isn't writable) and opens it. To read [`install.sh`](install.sh) before running it:

```sh
curl -fsSL https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.sh -o install.sh
less install.sh && bash install.sh
```

### Manual install from GitHub Releases

1. Open **[Releases → Latest](../../releases/latest)** and download `Lakera-Guard-Demo_macos-universal.dmg`.
2. Open the DMG and drag **Lakera Guard Demo** into **Applications**.
3. The app is not notarized by Apple, so on first launch macOS will warn you. Either:
   - right-click the app → **Open** → **Open**, or
   - go to **System Settings → Privacy & Security** → **Open Anyway**, or
   - run `xattr -dr com.apple.quarantine "/Applications/Lakera Guard Demo.app"`.

`SHA256SUMS.txt` in each release lists the checksums of the assets.

## First run

1. **Settings** → paste your **Lakera Guard API key** → **Save** (it goes to the Keychain). Optionally set a **Project ID** to use a specific Guard policy, then click **Test Guard connection**.
2. **Datasets** → download a small one to start, e.g. *ChatGPT-Jailbreak-Prompts* (79 prompts) or *Vigil* (104).
3. **Prompt Roulette** → **SPIN**, then **TRY MORE**.

Tips:
- Download *SQuAD 2.0* as well, so the roulette mixes in benign prompts and you can show there are no false positives.
- *ToxicQAFinal* is a content-moderation dataset. It is only flagged if your Guard project policy enables moderation detectors.
- Datasets are stored in `~/Library/Application Support/com.checkpoint.lakera-demo/datasets/`.

## Uninstall

```sh
rm -rf "/Applications/Lakera Guard Demo.app" ~/Library/Application\ Support/com.checkpoint.lakera-demo
security delete-generic-password -s com.checkpoint.lakera-demo -a lakera-guard-api-key 2>/dev/null
security delete-generic-password -s com.checkpoint.lakera-demo -a huggingface-token 2>/dev/null
```

---

This repository distributes the built app only.
