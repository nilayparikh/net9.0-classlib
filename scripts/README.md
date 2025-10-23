# PowerShell Automation Scripts

This template includes two PowerShell scripts to automate common tasks.

## 📦 rename-template.ps1

**Purpose**: Automatically rename the entire template from "YourLibrary" to your custom library name.

**Usage**:
```powershell
# Basic usage - renames everything and builds/tests
.\scripts\rename-template.ps1 -NewName "MyAwesome.Library"

# Skip build and test (faster, but you should build manually)
.\scripts\rename-template.ps1 -NewName "MyCompany.Utils" -SkipBuild

# Skip git initialization
.\scripts\rename-template.ps1 -NewName "DataAccess" -SkipGit

# Skip both
.\scripts\rename-template.ps1 -NewName "Core.Services" -SkipBuild -SkipGit
```

**What it does** (18 steps):
1. Validates your library name is a valid C# identifier
2. Checks template state
3. Renames `src\YourLibrary` → `src\YourName`
4. Renames `tests\YourLibrary.Tests` → `tests\YourName.Tests`
5. Renames project files (`.csproj`)
6. Updates namespaces in all `.cs` files
7. Updates project references
8. Updates solution file content
9. Renames solution file
10. Updates `README.md`
11. Updates all documentation files (`docs\`, `CONTRIBUTING.md`, etc.)
12. Updates `.github\instructions\` AI files
13. Updates `.vscode\` settings
14. Updates `Directory.Build.props`
15. Cleans old build artifacts
16. Builds the solution (unless `-SkipBuild`)
17. Runs all tests (unless `-SkipBuild`)
18. Initializes git repository with initial commit (unless `-SkipGit`)

**Parameters**:
- `-NewName` (required): Your library name (e.g., "MyCompany.DataAccess")
- `-SkipBuild` (optional): Skip building and testing
- `-SkipGit` (optional): Skip git initialization

**Example Output**:
```
=== .NET 9 Class Library Template Renamer ===

[1/18] Validating library name...
  OK: 'MyAwesome.Library' is valid

[2/18] Checking template state...
  OK: Template is ready for renaming

[3/18] Renaming source directory...
  Renamed: src\YourLibrary -> src\MyAwesome.Library

...

[18/18] Initializing git repository...
  Git repository initialized with initial commit

=== Rename Complete! ===

[SUCCESS] Library renamed from YourLibrary to MyAwesome.Library

Next steps:
  1. Review the changes: git status
  2. Update LICENSE with your name and year
  3. Update README.md with your project description
  4. Update version in Directory.Build.props
  5. Start coding your library!
```

---

## 🔧 install-mcps.ps1

**Purpose**: Install MCP (Model Context Protocol) servers for AI-assisted development in VS Code.

**Usage**:
```powershell
# Install all MCP servers from mcp.json
.\scripts\install-mcps.ps1

# Only check which servers are installed (don't install)
.\scripts\install-mcps.ps1 -VerifyOnly

# Force reinstall even if already installed
.\scripts\install-mcps.ps1 -Force
```

**What it does**:
1. Checks prerequisites (Node.js, npx)
2. Reads `mcp.json` configuration
3. For each MCP server:
   - Checks if already installed
   - Installs using `npx` if needed
4. Displays summary of installed/skipped servers

**Parameters**:
- `-VerifyOnly` (optional): Only check installation status, don't install
- `-Force` (optional): Force reinstall even if already installed

**MCP Servers Included**:
- **Context7**: Library documentation lookup
- **Memory**: Context retention across sessions
- **Microsoft Docs**: Search official Microsoft documentation
- **Sequential Thinking**: Problem-solving assistance
- **Playwright**: Browser automation

**Prerequisites**:
- Node.js (v18 or higher recommended)
- npm/npx (comes with Node.js)

**Example Output**:
```
=== MCP Server Installer ===

Checking prerequisites...
  [OK] Node.js: v22.20.0
  [OK] npx: Found at C:\Program Files\nodejs\npx.ps1

Loading MCP server configuration...
  Found 5 MCP server(s)

Processing: context7 (@upstash/context7)
  Installing @upstash/context7...
  [SUCCESS] context7 installed

Processing: memory (@upstash/memory)
  [SKIP] Already installed

...

=== Installation Summary ===
Installed: 3
Skipped: 2

MCP servers have been installed successfully!
You may need to restart VS Code for changes to take effect.
```

---

## 🚀 Recommended Workflow

### First Time Setup

```powershell
# 1. Clone or use this template
git clone https://github.com/yourusername/Net9.ClassLib.git MyProject
cd MyProject

# 2. Rename the template
.\scripts\rename-template.ps1 -NewName "MyCompany.MyProject"

# 3. Install MCP servers (for AI assistance)
.\scripts\install-mcps.ps1

# 4. Open in VS Code
code .

# 5. Start coding!
```

### Verify Only Mode

Before making changes, you can verify the current state:

```powershell
# Check what would be renamed (template name validation only)
.\scripts\rename-template.ps1 -NewName "TestName" -SkipBuild -SkipGit

# Check which MCP servers are installed
.\scripts\install-mcps.ps1 -VerifyOnly
```

---

## 📝 Notes

### Valid Library Names

Your library name must:
- Start with a letter or underscore
- Contain only letters, numbers, dots (`.`), and underscores (`_`)
- Be a valid C# namespace identifier

**Valid examples**:
- `MyLibrary`
- `MyCompany.Core`
- `MyCompany.DataAccess.SqlServer`
- `Utilities_2024`
- `_InternalTools`

**Invalid examples**:
- `123Library` (starts with number)
- `My-Library` (contains dash)
- `My Library` (contains space)
- `My@Library` (contains special character)

### Post-Rename Tasks

After running `rename-template.ps1`, remember to:
1. Update `LICENSE` with your name and year
2. Update `README.md` with your project description
3. Update `Directory.Build.props` with your package metadata
4. Review and update `CHANGELOG.md`
5. Update `.github\instructions\` if needed for your team's standards

### Troubleshooting

**rename-template.ps1 fails on build**:
```powershell
# Run without building, then build manually
.\scripts\rename-template.ps1 -NewName "MyLib" -SkipBuild
dotnet build
dotnet test
```

**install-mcps.ps1 reports Node.js not found**:
```powershell
# Install Node.js from https://nodejs.org/
# Restart PowerShell after installation
node --version  # Should show v18+ 
npm --version   # Should show 8+
```

**Permission errors**:
```powershell
# Run PowerShell as Administrator, or
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

---

## 🔍 Script Internals

Both scripts:
- Use `Set-StrictMode -Version Latest` for safety
- Use `$ErrorActionPreference = 'Stop'` to fail fast
- Include comprehensive error handling with try-catch blocks
- Provide colored output for better readability
- Support `-WhatIf` simulation (future enhancement)

Files modified by `rename-template.ps1`:
- All `.cs` files (namespace updates)
- All `.csproj` files (project names and references)
- `.sln` file (solution name and project paths)
- `README.md`, `CONTRIBUTING.md`, all docs
- `.github\instructions\*.md`
- `.vscode\*.json`
- `Directory.Build.props`

MCP servers installed by `install-mcps.ps1`:
- Configured in `mcp.json`
- Installed via `npx` (cached globally)
- Can be verified with `npx -y <package> --version`
