# Lakera Guard Demo (macOS app)

Ready-to-run macOS demo app for **Lakera Guard (AI Guardrails)**: Prompt Roulette, one-click download of public red-team datasets, and batch replay against the Guard API.

This repository only distributes the built app.

## ⬇️ Download

**[Latest release →](../../releases/latest)**: get the `.dmg`, open it, and drag the app to Applications.

The app is not notarized. On first launch use **right-click → Open**, or go to **System Settings → Privacy & Security → Open Anyway**. You can also run:

```sh
xattr -dr com.apple.quarantine "/Applications/Lakera Guard Demo.app"
```

Then open **Settings**, paste your Lakera Guard API key (stored in the macOS Keychain), download a dataset and hit **SPIN**.
