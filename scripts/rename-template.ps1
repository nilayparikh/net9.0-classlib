<#
.SYNOPSIS
    Renames the template library from YourLibrary to your custom library name.

.DESCRIPTION
    This script automates the process of customizing the .NET 9 class library template
    by renaming all occurrences of "YourLibrary" to your specified library name.
    
    It performs the following operations:
    1. Validates the new library name
    2. Renames directories (src/YourLibrary, tests/YourLibrary.Tests)
    3. Renames project files (.csproj)
    4. Updates namespaces in all .cs files
    5. Updates project references
    6. Updates solution file
    7. Updates documentation files
    8. Renames solution file
    9. Builds and tests the renamed solution
    10. Optionally initializes a git repository

.PARAMETER NewName
    The new name for your library. Must be a valid C# identifier (e.g., "MyAwesome.Library").

.PARAMETER SkipBuild
    Skip the build and test steps after renaming.

.PARAMETER SkipGit
    Skip git repository initialization.

.EXAMPLE
    .\scripts\rename-template.ps1 -NewName "MyCompany.DataAccess"
    Renames the template to MyCompany.DataAccess

.EXAMPLE
    .\scripts\rename-template.ps1 -NewName "Utilities" -SkipGit
    Renames to Utilities without initializing git
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$NewName,
    
    [switch]$SkipBuild,
    [switch]$SkipGit
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Validate library name
function Test-LibraryName {
    param([string]$Name)
    
    if ($Name -match '^[a-zA-Z_][a-zA-Z0-9_.]*$') {
        return $true
    }
    
    Write-Host "[ERROR] Invalid library name: $Name" -ForegroundColor Red
    Write-Host "Library name must:" -ForegroundColor Yellow
    Write-Host "  - Start with a letter or underscore" -ForegroundColor Yellow
    Write-Host "  - Contain only letters, numbers, dots, and underscores" -ForegroundColor Yellow
    Write-Host "  - Be a valid C# namespace identifier" -ForegroundColor Yellow
    return $false
}

# Main execution
Write-Host ""
Write-Host "=== .NET 9 Class Library Template Renamer ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Validate name
Write-Host "[1/18] Validating library name..." -ForegroundColor Cyan
if (-not (Test-LibraryName $NewName)) {
    exit 1
}
Write-Host "  OK: '$NewName' is valid" -ForegroundColor Green
Write-Host ""

# Step 2: Check if already renamed
Write-Host "[2/18] Checking template state..." -ForegroundColor Cyan
$srcYourLibrary = "src\YourLibrary"
if (-not (Test-Path $srcYourLibrary)) {
    Write-Host "  WARNING: Template appears to be already renamed or modified" -ForegroundColor Yellow
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne 'y') {
        Write-Host "Rename cancelled." -ForegroundColor Gray
        exit 0
    }
}
else {
    Write-Host "  OK: Template is ready for renaming" -ForegroundColor Green
}
Write-Host ""

# Step 3: Rename source directory
Write-Host "[3/18] Renaming source directory..." -ForegroundColor Cyan
if (Test-Path $srcYourLibrary) {
    $newSrcDir = "src\$NewName"
    Rename-Item -Path $srcYourLibrary -NewName $NewName
    Write-Host "  Renamed: $srcYourLibrary -> $newSrcDir" -ForegroundColor Green
}
else {
    Write-Host "  SKIP: Source directory not found" -ForegroundColor Gray
}
Write-Host ""

# Step 4: Rename test directory
Write-Host "[4/18] Renaming test directory..." -ForegroundColor Cyan
$testYourLibrary = "tests\YourLibrary.Tests"
if (Test-Path $testYourLibrary) {
    $newTestDir = "tests\$NewName.Tests"
    Rename-Item -Path $testYourLibrary -NewName "$NewName.Tests"
    Write-Host "  Renamed: $testYourLibrary -> $newTestDir" -ForegroundColor Green
}
else {
    Write-Host "  SKIP: Test directory not found" -ForegroundColor Gray
}
Write-Host ""

# Step 5: Rename project files
Write-Host "[5/18] Renaming project files..." -ForegroundColor Cyan
$srcProject = "src\$NewName\YourLibrary.csproj"
if (Test-Path $srcProject) {
    $newSrcProject = "src\$NewName\$NewName.csproj"
    Rename-Item -Path $srcProject -NewName "$NewName.csproj"
    Write-Host "  Renamed: $srcProject -> $newSrcProject" -ForegroundColor Green
}

$testProject = "tests\$NewName.Tests\YourLibrary.Tests.csproj"
if (Test-Path $testProject) {
    $newTestProject = "tests\$NewName.Tests\$NewName.Tests.csproj"
    Rename-Item -Path $testProject -NewName "$NewName.Tests.csproj"
    Write-Host "  Renamed: $testProject -> $newTestProject" -ForegroundColor Green
}
Write-Host ""

# Step 6: Update namespaces in C# files
Write-Host "[6/18] Updating namespaces in C# files..." -ForegroundColor Cyan
$csFiles = Get-ChildItem -Path . -Include *.cs -Recurse -File
$updatedFiles = 0
foreach ($file in $csFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match 'YourLibrary') {
        $newContent = $content -replace 'YourLibrary', $NewName
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "  Updated: $($file.FullName)" -ForegroundColor Gray
        $updatedFiles++
    }
}
Write-Host "  Updated $updatedFiles C# file(s)" -ForegroundColor Green
Write-Host ""

# Step 7: Update project references
Write-Host "[7/18] Updating project references..." -ForegroundColor Cyan
$csprojFiles = Get-ChildItem -Path . -Include *.csproj -Recurse -File
foreach ($file in $csprojFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match 'YourLibrary') {
        $newContent = $content -replace 'YourLibrary', $NewName
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "  Updated: $($file.FullName)" -ForegroundColor Gray
    }
}
Write-Host "  Project references updated" -ForegroundColor Green
Write-Host ""

# Step 8: Update solution file
Write-Host "[8/18] Updating solution file..." -ForegroundColor Cyan
$slnFile = "YourLibrary.sln"
if (Test-Path $slnFile) {
    $content = Get-Content $slnFile -Raw
    $newContent = $content -replace 'YourLibrary', $NewName
    Set-Content -Path $slnFile -Value $newContent -NoNewline
    Write-Host "  Updated: $slnFile" -ForegroundColor Green
}
else {
    Write-Host "  SKIP: Solution file not found" -ForegroundColor Gray
}
Write-Host ""

# Step 9: Rename solution file
Write-Host "[9/18] Renaming solution file..." -ForegroundColor Cyan
if (Test-Path $slnFile) {
    $newSlnFile = "$NewName.sln"
    Rename-Item -Path $slnFile -NewName $newSlnFile
    Write-Host "  Renamed: $slnFile -> $newSlnFile" -ForegroundColor Green
}
Write-Host ""

# Step 10: Update README.md
Write-Host "[10/18] Updating README.md..." -ForegroundColor Cyan
if (Test-Path "README.md") {
    $content = Get-Content "README.md" -Raw
    $newContent = $content -replace 'YourLibrary', $NewName
    Set-Content -Path "README.md" -Value $newContent -NoNewline
    Write-Host "  Updated: README.md" -ForegroundColor Green
}
Write-Host ""

# Step 11: Update GETTING_STARTED.md
Write-Host "[11/18] Updating documentation..." -ForegroundColor Cyan
$docFiles = @("docs\GETTING_STARTED.md", "CONTRIBUTING.md", "PROJECT_SUMMARY.md", "QUICK_REFERENCE.md")
$updatedDocs = 0
foreach ($docFile in $docFiles) {
    if (Test-Path $docFile) {
        $content = Get-Content $docFile -Raw
        $newContent = $content -replace 'YourLibrary', $NewName
        Set-Content -Path $docFile -Value $newContent -NoNewline
        Write-Host "  Updated: $docFile" -ForegroundColor Gray
        $updatedDocs++
    }
}
Write-Host "  Updated $updatedDocs documentation file(s)" -ForegroundColor Green
Write-Host ""

# Step 12: Update .github instructions
Write-Host "[12/18] Updating AI instructions..." -ForegroundColor Cyan
$instructionFiles = Get-ChildItem -Path ".github\instructions" -Include *.md -Recurse -File -ErrorAction SilentlyContinue
$updatedInstructions = 0
foreach ($file in $instructionFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match 'YourLibrary') {
        $newContent = $content -replace 'YourLibrary', $NewName
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "  Updated: $($file.FullName)" -ForegroundColor Gray
        $updatedInstructions++
    }
}
Write-Host "  Updated $updatedInstructions instruction file(s)" -ForegroundColor Green
Write-Host ""

# Step 13: Update .vscode settings
Write-Host "[13/18] Updating VS Code settings..." -ForegroundColor Cyan
$vscodeFiles = Get-ChildItem -Path ".vscode" -Include *.json -File -ErrorAction SilentlyContinue
foreach ($file in $vscodeFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match 'YourLibrary') {
        $newContent = $content -replace 'YourLibrary', $NewName
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "  Updated: $($file.Name)" -ForegroundColor Gray
    }
}
Write-Host "  VS Code settings updated" -ForegroundColor Green
Write-Host ""

# Step 14: Update Directory.Build.props
Write-Host "[14/18] Updating Directory.Build.props..." -ForegroundColor Cyan
if (Test-Path "Directory.Build.props") {
    $content = Get-Content "Directory.Build.props" -Raw
    $newContent = $content -replace 'YourLibrary', $NewName
    Set-Content -Path "Directory.Build.props" -Value $newContent -NoNewline
    Write-Host "  Updated: Directory.Build.props" -ForegroundColor Green
}
Write-Host ""

# Step 15: Clean old build artifacts
Write-Host "[15/18] Cleaning old build artifacts..." -ForegroundColor Cyan
$cleanDirs = @("bin", "obj")
Get-ChildItem -Path . -Include $cleanDirs -Recurse -Directory -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
Write-Host "  Build artifacts cleaned" -ForegroundColor Green
Write-Host ""

# Step 16: Build solution
if (-not $SkipBuild) {
    Write-Host "[16/18] Building solution..." -ForegroundColor Cyan
    try {
        $buildOutput = dotnet build "$NewName.sln" --configuration Release 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  Build succeeded" -ForegroundColor Green
        }
        else {
            Write-Host "  Build failed! Output:" -ForegroundColor Red
            Write-Host $buildOutput -ForegroundColor Gray
            exit 1
        }
    }
    catch {
        Write-Host "  Build error: $_" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "[16/18] Skipping build..." -ForegroundColor Gray
}
Write-Host ""

# Step 17: Run tests
if (-not $SkipBuild) {
    Write-Host "[17/18] Running tests..." -ForegroundColor Cyan
    try {
        $testOutput = dotnet test "$NewName.sln" --no-build --configuration Release 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  All tests passed" -ForegroundColor Green
        }
        else {
            Write-Host "  Tests failed! Output:" -ForegroundColor Red
            Write-Host $testOutput -ForegroundColor Gray
            exit 1
        }
    }
    catch {
        Write-Host "  Test error: $_" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "[17/18] Skipping tests..." -ForegroundColor Gray
}
Write-Host ""

# Step 18: Initialize git repository
if (-not $SkipGit) {
    Write-Host "[18/18] Initializing git repository..." -ForegroundColor Cyan
    try {
        if (-not (Test-Path ".git")) {
            git init 2>&1 | Out-Null
            git add . 2>&1 | Out-Null
            git commit -m "Initial commit: Renamed template to $NewName" 2>&1 | Out-Null
            Write-Host "  Git repository initialized with initial commit" -ForegroundColor Green
        }
        else {
            Write-Host "  SKIP: Git repository already exists" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "  SKIP: Git initialization failed (git may not be installed)" -ForegroundColor Yellow
    }
}
else {
    Write-Host "[18/18] Skipping git initialization..." -ForegroundColor Gray
}
Write-Host ""

# Summary
Write-Host "=== Rename Complete! ===" -ForegroundColor Green
Write-Host ""
Write-Host "[SUCCESS] Library renamed from YourLibrary to $NewName" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Review the changes: git status" -ForegroundColor White
Write-Host "  2. Update LICENSE with your name and year" -ForegroundColor White
Write-Host "  3. Update README.md with your project description" -ForegroundColor White
Write-Host "  4. Update version in Directory.Build.props" -ForegroundColor White
Write-Host "  5. Start coding your library!" -ForegroundColor White
Write-Host ""
