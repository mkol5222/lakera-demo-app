# Lakera Guard Demo: quick installer / updater for Windows 10/11 (x64).
#
#   irm https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.ps1 | iex
#
# Downloads the latest release from GitHub over HTTPS, verifies its SHA-256
# checksum, runs the per-user installer silently (no admin rights needed) and
# starts the app. Running it again upgrades to the newest release and keeps
# settings, keys and datasets.
#
# Optional: set $env:LGD_NO_LAUNCH = '1' before running to skip starting the app.

& {
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'   # much faster Invoke-WebRequest on Windows PowerShell 5.1

    $Repo  = 'mkol5222/lakera-demo-app'
    $Asset = 'Lakera-Guard-Demo_windows-x64-setup.exe'
    $Base  = "https://github.com/$Repo/releases/latest/download"
    $App   = Join-Path $env:LOCALAPPDATA 'Lakera Guard Demo\lakera-demo.exe'

    function Say($msg) { Write-Host "==> $msg" -ForegroundColor Magenta }

    if (-not [Environment]::Is64BitOperatingSystem) { throw 'Lakera Guard Demo requires 64-bit Windows.' }

    # Windows PowerShell 5.1 may default to TLS 1.0; require TLS 1.2+.
    $tls = [Net.SecurityProtocolType]::Tls12
    try { $tls = $tls -bor [Net.SecurityProtocolType]::Tls13 } catch { }
    [Net.ServicePointManager]::SecurityProtocol = $tls

    $tmp = Join-Path ([IO.Path]::GetTempPath()) ("lgd-" + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $exe  = Join-Path $tmp $Asset
        $sums = Join-Path $tmp 'SHA256SUMS.txt'

        Say 'Downloading latest release of Lakera Guard Demo'
        Invoke-WebRequest -UseBasicParsing -Uri "$Base/$Asset" -OutFile $exe
        Invoke-WebRequest -UseBasicParsing -Uri "$Base/SHA256SUMS.txt" -OutFile $sums

        Say 'Verifying SHA-256 checksum'
        $expected = $null
        foreach ($line in Get-Content $sums) {
            $parts = $line -split '\s+', 2
            if ($parts.Count -eq 2 -and ($parts[1].Trim() -replace '^\./', '') -eq $Asset) { $expected = $parts[0].ToLower() }
        }
        if (-not $expected) { throw "No checksum listed for $Asset" }
        $actual = (Get-FileHash -Algorithm SHA256 -Path $exe).Hash.ToLower()
        if ($actual -ne $expected) { throw "Checksum mismatch (expected $expected, got $actual)" }

        $running = Get-Process -Name 'lakera-demo' -ErrorAction SilentlyContinue
        if ($running) {
            Say 'Closing running app'
            $running | Stop-Process -Force
            Start-Sleep -Seconds 1
        }

        Say 'Installing (per-user, no admin rights needed)'
        $p = Start-Process -FilePath $exe -ArgumentList '/S' -Wait -PassThru
        if ($p.ExitCode -ne 0) { throw "Installer exited with code $($p.ExitCode)" }
        if (-not (Test-Path $App)) { throw "Install finished but $App was not found" }

        $ver = (Get-Item $App).VersionInfo.ProductVersion
        Say "Installed Lakera Guard Demo $ver"
        if ($env:LGD_NO_LAUNCH -ne '1') { Start-Process -FilePath $App }
    }
    finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}
