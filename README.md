# YourLibrary

> A modern .NET 9 class library template with best practices built-in.

[![.NET](https://img.shields.io/badge/.NET-9.0-purple)](https://dotnet.microsoft.com/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 🚀 Quick Start

This is a GitHub template repository. Click the "Use this template" button to create your own repository based on this template.

### Prerequisites

-   [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0) or later
-   [Visual Studio Code](https://code.visualstudio.com/) (recommended) or Visual Studio 2022+
-   [Node.js](https://nodejs.org/) (for MCP servers)

### Setup Steps

1. **Create your repository from this template**

    - Click "Use this template" button on GitHub
    - Name your repository
    - Clone it locally

2. **Rename the library**

    - Replace `YourLibrary` with your library name in:
        - Solution file: `YourLibrary.sln` → `YourProjectName.sln`
        - Project files: `src/YourLibrary/` → `src/YourProjectName/`
        - Test files: `tests/YourLibrary.Tests/` → `tests/YourProjectName.Tests/`
        - Update namespaces in `.cs` files
        - Update project references in `.csproj` files
        - Update `.vscode/settings.json` and `.vscode/tasks.json`

3. **Install MCP servers** (for AI-assisted development)

    ```powershell
    .\scripts\install-mcps.ps1
    ```

4. **Open in VS Code**

    ```powershell
    code .
    ```

5. **Build the solution**

    ```powershell
    dotnet build
    ```

6. **Run tests**
    ```powershell
    dotnet test
    ```

## 📁 Project Structure

```
YourLibrary/
├── .github/
│   └── instructions/         # AI assistant instructions
│       ├── base.instructions.md
│       └── cs.instructions.md
├── .vscode/                  # VS Code configuration
│   ├── extensions.json       # Recommended extensions
│   ├── launch.json           # Debug configurations
│   ├── settings.json         # Workspace settings
│   └── tasks.json            # Build tasks
├── docs/                     # Documentation
│   └── api/                  # API documentation
├── scripts/                  # Utility scripts
│   └── install-mcps.ps1      # MCP installation script
├── src/
│   └── YourLibrary/          # Main library project
│       ├── YourLibrary.csproj
│       └── Class1.cs
├── tests/
│   └── YourLibrary.Tests/    # Test project
│       ├── YourLibrary.Tests.csproj
│       ├── UnitTests/        # Unit tests (no external dependencies)
│       └── IntegrationTests/ # Integration tests (with external dependencies)
├── .editorconfig             # Code style configuration
├── .gitignore                # Git ignore rules
├── CONTRIBUTING.md           # Contribution guidelines
├── LICENSE                   # License file
├── mcp.json                  # MCP server configuration
├── README.md                 # This file
└── YourLibrary.sln           # Solution file
```

## 🧪 Testing Strategy

### Unit Tests (`tests/YourLibrary.Tests/UnitTests/`)

-   **Purpose**: Test individual components in isolation
-   **Characteristics**:
    -   No external dependencies (database, network, file system)
    -   Fast execution
    -   Deterministic results
    -   Use mocking for dependencies

### Integration Tests (`tests/YourLibrary.Tests/IntegrationTests/`)

-   **Purpose**: Validate end-to-end scenarios
-   **Characteristics**:
    -   May include external dependencies
    -   Test component interactions
    -   Validate complete workflows
    -   May be slower than unit tests

### Running Tests

```powershell
# Run all tests
dotnet test

# Run only unit tests
dotnet test --filter "FullyQualifiedName~UnitTests"

# Run only integration tests
dotnet test --filter "FullyQualifiedName~IntegrationTests"

# Run tests with coverage
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
```

## 🛠️ Development

### Building

```powershell
# Build the solution
dotnet build

# Build in Release mode
dotnet build -c Release

# Clean build artifacts
dotnet clean
```

### Publishing

```powershell
# Create a NuGet package
dotnet pack -c Release

# Publish to a folder
dotnet publish -c Release -o ./publish
```

### VS Code Tasks

Press `Ctrl+Shift+P` and type "Tasks" to see available tasks:

-   **Build**: Build the solution
-   **Test**: Run all tests
-   **Test with Coverage**: Run tests with code coverage
-   **Watch**: Watch for file changes and rebuild

## 🤖 AI-Assisted Development

This template includes MCP (Model Context Protocol) servers for enhanced AI assistance:

-   **Context7**: Access up-to-date library documentation
-   **Memory**: Maintain context across sessions
-   **Microsoft Docs**: Search official Microsoft documentation
-   **Sequential Thinking**: Problem-solving assistance
-   **Playwright**: Browser automation support

### Installing MCP Servers

```powershell
# Install all MCP servers
.\scripts\install-mcps.ps1

# Verify prerequisites only
.\scripts\install-mcps.ps1 -VerifyOnly
```

### AI Instructions

The `.github/instructions/` folder contains guidelines for AI assistants:

-   `base.instructions.md`: General project guidelines
-   `cs.instructions.md`: C# coding standards and conventions

## 📝 Code Standards

This project follows modern .NET best practices:

-   ✅ **Nullable reference types** enabled
-   ✅ **Implicit usings** for common namespaces
-   ✅ **Latest C# language version**
-   ✅ **XML documentation** for public APIs
-   ✅ **Code analysis** with warnings as errors
-   ✅ **EditorConfig** for consistent formatting
-   ✅ **Source Link** for debugging support

See `.github/instructions/cs.instructions.md` for detailed coding standards.

## 📦 Package Configuration

Update the following in `src/YourLibrary/YourLibrary.csproj`:

```xml
<PropertyGroup>
  <PackageId>YourLibrary</PackageId>
  <Version>1.0.0</Version>
  <Authors>Your Name</Authors>
  <Company>Your Company</Company>
  <Description>Your library description</Description>
  <PackageProjectUrl>https://github.com/yourusername/yourrepository</PackageProjectUrl>
  <RepositoryUrl>https://github.com/yourusername/yourrepository</RepositoryUrl>
</PropertyGroup>
```

## 🤝 Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

-   [.NET Documentation](https://docs.microsoft.com/dotnet/)
-   [C# Programming Guide](https://docs.microsoft.com/dotnet/csharp/)
-   [xUnit Documentation](https://xunit.net/)
-   [FluentAssertions Documentation](https://fluentassertions.com/)
-   [Model Context Protocol](https://modelcontextprotocol.io/)

## 📮 Support

-   Create an issue for bug reports or feature requests
-   Check existing issues before creating new ones
-   Follow the issue template when available

---

**Happy Coding! 🎉**

