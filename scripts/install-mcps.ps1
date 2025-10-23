<#
.SYNOPSIS
    Installs MCP servers configured in mcp.json for use with VS Code.

.DESCRIPTION
    This script automates the installation of MCP servers listed in mcp.json.
    It uses npx to install and cache Node.js-based MCP servers globally.

.PARAMETER VerifyOnly
    Only verify if MCP servers are installed without installing them.

.PARAMETER Force
    Force reinstall even if servers are already installed.

.EXAMPLE
    .\scripts\install-mcps.ps1
    Installs all MCP servers from mcp.json

.EXAMPLE
    .\scripts\install-mcps.ps1 -VerifyOnly
    Checks which servers are installed
#>

[CmdletBinding()]
param(
    [switch]$VerifyOnly,
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Check if Node.js and npx are available
function Test-Prerequisites {
    Write-Host "Checking prerequisites..." -ForegroundColor Cyan

    try {
        $nodeVersion = node --version 2>&1
        Write-Host "  [OK] Node.js: $nodeVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  [ERROR] Node.js is not installed. Please install Node.js from https://nodejs.org/" -ForegroundColor Red
        return $false
    }

    try {
        $npxPath = Get-Command npx -ErrorAction Stop
        Write-Host "  [OK] npx: Found at $($npxPath.Source)" -ForegroundColor Green
    }
    catch {
        Write-Host "  [ERROR] npx is not available. Please ensure npm is properly installed." -ForegroundColor Red
        return $false
    }

    return $true
}

# Read and parse mcp.json
function Get-MCPServers {
    $mcpJsonPath = Join-Path $PSScriptRoot "..\mcp.json"

    if (-not (Test-Path $mcpJsonPath)) {
        Write-Host "  [ERROR] mcp.json not found at: $mcpJsonPath" -ForegroundColor Red
        return $null
    }

    try {
        $mcpConfig = Get-Content $mcpJsonPath -Raw | ConvertFrom-Json
        return $mcpConfig.mcpServers.psobject.Properties
    }
    catch {
        Write-Host "  [ERROR] Failed to parse mcp.json: $_" -ForegroundColor Red
        return $null
    }
}

# Check if a package is installed
function Test-PackageInstalled {
    param([string]$PackageName)

    try {
        $null = npx -y $PackageName --version 2>&1
        return $true
    }
    catch {
        return $false
    }
}

# Main execution
Write-Host ""
Write-Host "=== MCP Server Installer ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check prerequisites
if (-not (Test-Prerequisites)) {
    Write-Host ""
    Write-Host "Installation cannot continue. Please install the required prerequisites." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Load MCP servers from mcp.json
Write-Host "Loading MCP server configuration..." -ForegroundColor Cyan
$mcpServers = Get-MCPServers

if (-not $mcpServers -or $mcpServers.Count -eq 0) {
    Write-Host "  [ERROR] No MCP servers found in mcp.json" -ForegroundColor Red
    exit 1
}

Write-Host "  Found $($mcpServers.Count) MCP server(s)" -ForegroundColor Green
Write-Host ""

# Step 3: Process each server
$installedCount = 0
$skippedCount = 0

foreach ($server in $mcpServers) {
    $serverName = $server.Name
    $serverConfig = $server.Value

    # Extract npm package name from command
    if ($serverConfig.command -eq 'npx' -and $serverConfig.args.Count -gt 0) {
        $packageName = $serverConfig.args[0]

        Write-Host "Processing: $serverName ($packageName)" -ForegroundColor White

        if ($VerifyOnly) {
            # Only check if installed
            if (Test-PackageInstalled $packageName) {
                Write-Host "  [INSTALLED]" -ForegroundColor Green
                $installedCount++
            }
            else {
                Write-Host "  [NOT INSTALLED]" -ForegroundColor Yellow
            }
        }
        else {
            # Check and install if needed
            $isInstalled = Test-PackageInstalled $packageName

            if ($isInstalled -and -not $Force) {
                Write-Host "  [SKIP] Already installed" -ForegroundColor Gray
                $skippedCount++
                continue
            }

            try {
                Write-Host "  Installing $packageName..." -ForegroundColor Yellow
                $null = npx -y $packageName --version 2>&1
                Write-Host "  [SUCCESS] $serverName installed" -ForegroundColor Green
                $installedCount++
            }
            catch {
                Write-Host "  [FAILED] Could not install ${serverName}: $_" -ForegroundColor Red
            }
        }

        Write-Host ""
    }
}

# Summary
Write-Host "=== Installation Summary ===" -ForegroundColor Cyan
if ($VerifyOnly) {
    Write-Host "Installed: $installedCount" -ForegroundColor Green
    Write-Host "Not installed: $($mcpServers.Count - $installedCount)" -ForegroundColor Yellow
}
else {
    Write-Host "Installed: $installedCount" -ForegroundColor Green
    Write-Host "Skipped: $skippedCount" -ForegroundColor Gray
}
Write-Host ""

if (-not $VerifyOnly -and $installedCount -gt 0) {
    Write-Host "MCP servers have been installed successfully!" -ForegroundColor Green
    Write-Host "You may need to restart VS Code for changes to take effect." -ForegroundColor Cyan
}
