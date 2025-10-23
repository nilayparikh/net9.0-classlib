<#
.SYNOPSIS
    Installs essential MCP (Model Context Protocol) servers for .NET development.

.DESCRIPTION
    This script installs the MCP servers defined in mcp.json.
    These servers enhance AI-assisted development capabilities in VS Code.

.PARAMETER VerifyOnly
    Only verifies if Node.js and npx are installed without installing MCPs.

.EXAMPLE
    .\install-mcps.ps1
    Installs all MCP servers.

.EXAMPLE
    .\install-mcps.ps1 -VerifyOnly
    Verifies Node.js installation only.
#>

[CmdletBinding()]
param(
    [switch]$VerifyOnly
)

$ErrorActionPreference = "Stop"

Write-Host "=== MCP Server Installation Script ===" -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is installed
Write-Host "Checking Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version 2>$null
    if ($nodeVersion) {
        Write-Host "✓ Node.js is installed: $nodeVersion" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ Node.js is not installed." -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Check if npx is available
Write-Host "Checking npx availability..." -ForegroundColor Yellow
try {
    $npxVersion = npx --version 2>$null
    if ($npxVersion) {
        Write-Host "✓ npx is available: $npxVersion" -ForegroundColor Green
    }
} catch {
    Write-Host "✗ npx is not available." -ForegroundColor Red
    Write-Host "Please ensure npm is properly installed." -ForegroundColor Yellow
    exit 1
}

if ($VerifyOnly) {
    Write-Host ""
    Write-Host "Verification complete. Environment is ready for MCP servers." -ForegroundColor Green
    exit 0
}

# Read mcp.json
Write-Host ""
Write-Host "Reading mcp.json configuration..." -ForegroundColor Yellow
$mcpJsonPath = Join-Path $PSScriptRoot "..\mcp.json"

if (-not (Test-Path $mcpJsonPath)) {
    Write-Host "✗ mcp.json not found at: $mcpJsonPath" -ForegroundColor Red
    exit 1
}

try {
    $mcpConfig = Get-Content $mcpJsonPath -Raw | ConvertFrom-Json
    Write-Host "✓ mcp.json loaded successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to parse mcp.json: $_" -ForegroundColor Red
    exit 1
}

# Extract MCP servers
$servers = $mcpConfig.mcpServers.PSObject.Properties

Write-Host ""
Write-Host "Found $($servers.Count) MCP server(s) in configuration:" -ForegroundColor Cyan
foreach ($server in $servers) {
    $serverName = $server.Name
    $serverConfig = $server.Value
    $isDisabled = $serverConfig.disabled -eq $true

    if ($isDisabled) {
        Write-Host "  - $serverName (disabled)" -ForegroundColor Gray
    } else {
        Write-Host "  - $serverName" -ForegroundColor White
    }
}

# Install each MCP server
Write-Host ""
Write-Host "Installing MCP servers..." -ForegroundColor Yellow
Write-Host ""

$installedCount = 0
$skippedCount = 0

foreach ($server in $servers) {
    $serverName = $server.Name
    $serverConfig = $server.Value
    $isDisabled = $serverConfig.disabled -eq $true

    if ($isDisabled) {
        Write-Host "Skipping $serverName (disabled)" -ForegroundColor Gray
        $skippedCount++
        continue
    }

    if ($serverConfig.command -eq "npx" -and $serverConfig.args.Count -gt 0) {
        # Extract package name (skip -y flag)
        $packageName = $serverConfig.args | Where-Object { $_ -ne "-y" } | Select-Object -First 1

        Write-Host "Installing $serverName..." -ForegroundColor Cyan
        Write-Host "  Package: $packageName" -ForegroundColor White

        try {
            # Use npx to download and cache the package
            $result = npx -y $packageName --version 2>&1
            Write-Host "  ✓ $serverName installed successfully" -ForegroundColor Green
            $installedCount++
        } catch {
            Write-Host "  ✗ Failed to install $serverName`: $_" -ForegroundColor Red
        }

        Write-Host ""
    }
}

# Summary
Write-Host "=== Installation Summary ===" -ForegroundColor Cyan
Write-Host "Installed: $installedCount" -ForegroundColor Green
Write-Host "Skipped: $skippedCount" -ForegroundColor Gray
Write-Host ""
Write-Host "MCP servers are now ready to use in VS Code." -ForegroundColor Green
Write-Host "Make sure the GitHub Copilot extension is installed and configured." -ForegroundColor Yellow
