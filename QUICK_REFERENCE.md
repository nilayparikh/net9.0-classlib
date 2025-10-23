# Quick Reference Guide

## 🚀 For Template Users

### Initial Setup (First Time)

```powershell
# 1. Use this template on GitHub or clone
git clone https://github.com/yourusername/Net9.ClassLib.git MyNewProject
cd MyNewProject

# 2. Run the automated rename script
.\scripts\rename-template.ps1 -NewName "MyAwesome.Library"

# That's it! The script will:
#   - Rename all files and folders
#   - Update all namespaces and references
#   - Update all documentation
#   - Build and test the solution
#   - Initialize git with an initial commit

# 3. (Optional) Install MCP servers for AI-assisted development
.\scripts\install-mcps.ps1
```

### Manual Rename (Alternative Method)

If you prefer to rename manually:

```powershell
# 1. Use this template on GitHub
# 2. Clone your new repo
git clone https://github.com/yourusername/yournewrepo.git
cd yournewrepo

# 3. Rename the library (PowerShell)
# Rename solution
Rename-Item YourLibrary.sln YourActualName.sln

# Rename project folders
Rename-Item src\YourLibrary src\YourActualName
Rename-Item tests\YourLibrary.Tests tests\YourActualName.Tests

# Rename project files
Rename-Item src\YourActualName\YourLibrary.csproj YourActualName.csproj
Rename-Item tests\YourActualName.Tests\YourLibrary.Tests.csproj YourActualName.Tests.csproj

# 4. Update solution references
dotnet sln remove src\YourLibrary\YourLibrary.csproj
dotnet sln remove tests\YourLibrary.Tests\YourLibrary.Tests.csproj
dotnet sln add src\YourActualName\YourActualName.csproj
dotnet sln add tests\YourActualName.Tests\YourActualName.Tests.csproj

# 5. Build and test
dotnet build
dotnet test

# 6. Install MCP servers (optional)
.\scripts\install-mcps.ps1
```

### Manual Edits Required (Manual Rename Only)

After manual renaming, update these files:

1. **Namespaces in .cs files**

    - Replace `namespace YourLibrary` with `namespace YourActualName`
    - Replace `using YourLibrary` with `using YourActualName`

2. **Project references**

    - In `tests\YourActualName.Tests\YourActualName.Tests.csproj`
    - Update `<ProjectReference>` path

3. **VS Code config**

    - `.vscode\settings.json` - Update `dotnet.defaultSolution`
    - `.vscode\tasks.json` - Update project paths
    - `.vscode\launch.json` - Update program path

4. **Package metadata**

    - `src\YourActualName\YourActualName.csproj` - Update all `<Package*>` tags
    - `Directory.Build.props` - Update author, company, copyright

5. **Documentation**
    - `README.md` - Update library name and description
    - `CONTRIBUTING.md` - Update repository URLs

## 📝 Common Commands

### Build

```powershell
dotnet build                    # Build all projects
dotnet build -c Release         # Release build
dotnet clean                    # Clean build artifacts
dotnet restore                  # Restore NuGet packages
```

### Test

```powershell
dotnet test                                              # Run all tests
dotnet test --filter "FullyQualifiedName~UnitTests"      # Unit tests only
dotnet test --filter "FullyQualifiedName~IntegrationTests" # Integration tests only
dotnet test /p:CollectCoverage=true                      # With coverage
```

### Package

```powershell
dotnet pack -c Release                  # Create NuGet package
dotnet nuget push *.nupkg --source ...  # Publish package
```

### VS Code Tasks

Press `Ctrl+Shift+P` → "Tasks: Run Task":

-   `build` - Build solution
-   `test` - Run all tests
-   `test-coverage` - Run tests with coverage
-   `watch` - Watch and rebuild on changes

## 📂 Project Structure

```
YourLibrary/
├── src/YourLibrary/              # Main library code
│   ├── Models/                   # Domain models
│   ├── Services/                 # Business logic
│   ├── Repositories/             # Data access
│   ├── Interfaces/               # Abstractions
│   └── Extensions/               # Extension methods
├── tests/YourLibrary.Tests/
│   ├── UnitTests/                # Isolated tests (no dependencies)
│   └── IntegrationTests/         # End-to-end tests (with dependencies)
└── docs/                         # Documentation
```

## 🎯 Coding Standards Quick Reference

### Naming Conventions

```csharp
public class CustomerService { }           // PascalCase for classes
public interface ICustomerRepository { }   // Interfaces with 'I' prefix
private readonly ILogger _logger;          // Fields with '_' prefix
public string CustomerName { get; set; }   // PascalCase for properties
public void ProcessOrder() { }             // PascalCase for methods
var customerName = "John";                 // camelCase for local variables
```

### File Organization

```csharp
using System;                    // System namespaces
using System.Collections.Generic;

using Microsoft.Extensions.Logging;  // Microsoft namespaces

using YourLibrary.Models;        // Project namespaces

namespace YourLibrary.Services;  // File-scoped namespace (preferred)

/// <summary>XML documentation for public API</summary>
public class CustomerService
{
    // 1. Constants
    private const int MaxRetries = 3;

    // 2. Fields
    private readonly ILogger _logger;

    // 3. Constructor
    public CustomerService(ILogger logger) => _logger = logger;

    // 4. Properties
    public string Name { get; init; } = string.Empty;

    // 5. Methods
    public async Task ProcessAsync() { }
}
```

### Modern C# Features

```csharp
// Nullable reference types
public string Name { get; set; } = string.Empty;  // Non-nullable
public string? MiddleName { get; set; }            // Nullable

// Guard clauses (.NET 8+)
ArgumentNullException.ThrowIfNull(parameter);
ArgumentException.ThrowIfNullOrWhiteSpace(name);
ArgumentOutOfRangeException.ThrowIfNegativeOrZero(id);

// Pattern matching
var result = value switch
{
    < 10 => "Small",
    < 100 => "Medium",
    _ => "Large"
};

// Expression bodies
public double Area => Width * Height;
public override string ToString() => $"{Name}: {Value}";
```

### Test Structure

```csharp
[Fact]
public void MethodName_Scenario_ExpectedResult()
{
    // Arrange
    var sut = new SystemUnderTest();
    var input = "test";

    // Act
    var result = sut.Method(input);

    // Assert
    result.Should().Be("expected");
}
```

## 🤖 AI Instructions Location

-   `.github/instructions/base.instructions.md` - Core guidelines
-   `.github/instructions/cs.instructions.md` - C# standards

## 📦 MCP Servers Included

-   **Context7**: Library documentation lookup
-   **Memory**: Context retention across sessions
-   **Microsoft Docs**: Search Microsoft documentation
-   **Sequential Thinking**: Problem-solving assistance
-   **Playwright**: Browser automation

Install with: `.\scripts\install-mcps.ps1`

## 🔧 Key Configuration Files

-   `.editorconfig` - Code formatting rules
-   `Directory.Build.props` - Common MSBuild properties
-   `mcp.json` - MCP server configuration
-   `.vscode/settings.json` - VS Code workspace settings

## 📚 Documentation

-   `README.md` - Project overview
-   `docs/GETTING_STARTED.md` - Detailed setup guide
-   `CONTRIBUTING.md` - Contribution guidelines
-   `CHANGELOG.md` - Version history
-   `TEMPLATE_README.md` - Template information

## ✅ Quality Checklist

Before committing code:

-   [ ] Code builds without warnings
-   [ ] All tests pass
-   [ ] XML documentation for public APIs
-   [ ] Follows naming conventions
-   [ ] No magic numbers or hard-coded values
-   [ ] Error handling is appropriate
-   [ ] Tests added for new functionality
-   [ ] Documentation updated

## 🆘 Common Issues

**Tests not discovered?**

```powershell
dotnet clean && dotnet build
# Restart VS Code
```

**MCP installation fails?**

```powershell
node --version  # Verify Node.js installed
.\scripts\install-mcps.ps1 -VerifyOnly
```

**Build warnings about Source Link?**

-   Normal for new projects without git commits
-   Will resolve after first git commit

## 🔗 Quick Links

-   [.NET Documentation](https://docs.microsoft.com/dotnet/)
-   [C# Guide](https://docs.microsoft.com/dotnet/csharp/)
-   [xUnit Docs](https://xunit.net/)
-   [FluentAssertions](https://fluentassertions.com/)

---

**Need more help?** See `docs/GETTING_STARTED.md` for detailed instructions.

