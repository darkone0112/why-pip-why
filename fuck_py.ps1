# 🔥 Ultimate Python Exorcism Script for Windows
Write-Host "🧨 Launching full Python annihilation protocol..." -ForegroundColor Red

# --- STEP 1: Try to uninstall all Python versions via WMI ---
Write-Host "`n📦 Attempting to uninstall Python via WMI..." -ForegroundColor Cyan
$products = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE 'Python%'"
foreach ($product in $products) {
    Write-Host "Uninstalling $($product.Name)..."
    try {
        $product.Uninstall() | Out-Null
        Write-Host "✔️ Uninstalled: $($product.Name)"
    } catch {
        Write-Host "❌ Failed to uninstall $($product.Name), continuing..." -ForegroundColor Yellow
    }
}

Start-Sleep -Seconds 2

# --- STEP 2: Delete all known Python folders ---
Write-Host "`n🧹 Deleting known Python directories..." -ForegroundColor Cyan

$pathsToDelete = @(
    "$env:ProgramFiles\Python*",
    "$env:ProgramFiles(x86)\Python*",
    "$env:LOCALAPPDATA\Programs\Python",
    "$env:APPDATA\Python",
    "$env:LOCALAPPDATA\pip",
    "$env:USERPROFILE\AppData\Roaming\Python",
    "$env:USERPROFILE\AppData\Local\pip",
    "$env:USERPROFILE\AppData\Local\Programs\Python",
    "$env:USERPROFILE\.virtualenvs",
    "$env:USERPROFILE\AppData\Local\Temp\pip*"
)

foreach ($path in $pathsToDelete) {
    if (Test-Path $path) {
        try {
            Remove-Item -Recurse -Force -Path $path -ErrorAction Stop
            Write-Host "✔️ Deleted: $path"
        } catch {
            Write-Host "❌ Could not delete: $path" -ForegroundColor Yellow
        }
    }
}

# --- STEP 3: Clean PATH variables ---
Write-Host "`n🧼 Scrubbing PATH environment variables..." -ForegroundColor Cyan

function Clean-Path ($scope) {
    $original = [Environment]::GetEnvironmentVariable("Path", $scope)
    if ($null -ne $original) {
        $split = $original -split ";"
        $filtered = $split | Where-Object { $_ -notmatch "Python" -and $_ -notmatch "pip" -and $_ -ne "" }
        [Environment]::SetEnvironmentVariable("Path", ($filtered -join ";"), $scope)
        Write-Host "✔️ Cleaned PATH for $scope"
    }
}
Clean-Path -scope "User"
Clean-Path -scope "Machine"

# --- STEP 4: Nuke all related registry entries including uninstall data ---
Write-Host "`n🧯 Purging Python-related registry keys..." -ForegroundColor Cyan

$registryRoots = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\Python",
    "HKLM:\Software\WOW6432Node\Python",
    "HKCU:\Software\Python"
)

foreach ($root in $registryRoots) {
    try {
        Get-ChildItem -Path $root -ErrorAction SilentlyContinue | ForEach-Object {
            $keyName = $_.Name
            if ($keyName -match "Python") {
                try {
                    Remove-Item -Path $_.PsPath -Recurse -Force -ErrorAction Stop
                    Write-Host "✔️ Removed registry key: $keyName"
                } catch {
                    Write-Host "❌ Could not remove registry key: $keyName" -ForegroundColor Yellow
                }
            }
        }
    } catch {
        Write-Host "⚠️ Could not access registry path: $root" -ForegroundColor Yellow
    }
}

# --- STEP 5: Final checks ---
Write-Host "`n✅ Purge complete." -ForegroundColor Green
Write-Host "💀 If you still see Python anywhere, it's a ghost process." -ForegroundColor DarkGray
Write-Host "🔄 Reboot your system before reinstalling Python." -ForegroundColor Yellow
Write-Host "📥 Download clean installer from: https://www.python.org/downloads/"
