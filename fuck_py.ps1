# 🧨 Python Exorcism Protocol
Write-Host "Initiating full Python wipeout..." -ForegroundColor Red

# Step 1: Try to uninstall all Python versions via WMI
Write-Host "`nSearching for installed Python products..." -ForegroundColor Cyan
$pythonProducts = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE 'Python%'"
if ($pythonProducts.Count -gt 0) {
    foreach ($product in $pythonProducts) {
        Write-Host "Uninstalling $($product.Name)..."
        try {
            $product.Uninstall() | Out-Null
            Write-Host "✔️ Successfully uninstalled $($product.Name)"
        } catch {
            Write-Host "❌ Failed to uninstall $($product.Name) - possibly corrupted" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "No registered Python products found."
}

Start-Sleep -Seconds 2

# Step 2: Delete known Python folders
Write-Host "`n🧹 Deleting Python-related directories..." -ForegroundColor Cyan

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
            Write-Host "❌ Failed to delete: $path" -ForegroundColor Yellow
        }
    }
}

# Step 3: Remove Python from user PATH
Write-Host "`nScrubbing PATH variables..." -ForegroundColor Cyan

function Clean-Path ($scope) {
    $path = [Environment]::GetEnvironmentVariable("Path", $scope)
    if ($null -ne $path) {
        $splitPath = $path -split ";"
        $filteredPath = $splitPath | Where-Object { $_ -notmatch "Python" -and $_ -notmatch "pip" -and $_ -ne "" }
        [Environment]::SetEnvironmentVariable("Path", ($filteredPath -join ";"), $scope)
        Write-Host "✔️ Cleaned PATH for $scope"
    }
}

Clean-Path -scope "User"
Clean-Path -scope "Machine"

# Step 4: Remove leftover registry keys
Write-Host "`nClening registry entries..." -ForegroundColor Cyan

$registryPaths = @(
    "HKCU:\Software\Python",
    "HKLM:\Software\Python",
    "HKLM:\Software\WOW6432Node\Python",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

foreach ($reg in $registryPaths) {
    Get-ChildItem $reg -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.Name -match "Python") {
            try {
                Remove-Item -Recurse -Force -Path $_.PsPath -ErrorAction Stop
                Write-Host "✔️ Removed registry key: $($_.Name)"
            } catch {
                Write-Host "❌ Failed to remove registry key: $($_.Name)" -ForegroundColor Yellow
            }
        }
    }
}

# Final check
Write-Host "`n💀 Wipe complete." -ForegroundColor Green
Write-Host "If you're still seeing Python anywhere, it's haunted." -ForegroundColor DarkGray
Write-Host "`n💡 Reboot your system before reinstalling Python." -ForegroundColor Yellow
