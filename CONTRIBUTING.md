# Contributing to YourLibrary

Thank you for your interest in contributing to this project! We welcome contributions from the community.

## Table of Contents

-   [Code of Conduct](#code-of-conduct)
-   [Getting Started](#getting-started)
-   [Development Setup](#development-setup)
-   [How to Contribute](#how-to-contribute)
-   [Coding Standards](#coding-standards)
-   [Testing Guidelines](#testing-guidelines)
-   [Pull Request Process](#pull-request-process)
-   [Reporting Issues](#reporting-issues)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please be respectful and constructive in all interactions.

### Our Standards

-   Use welcoming and inclusive language
-   Be respectful of differing viewpoints and experiences
-   Gracefully accept constructive criticism
-   Focus on what is best for the community
-   Show empathy towards other community members

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
    ```bash
    git clone https://github.com/yourusername/yourrepository.git
    cd yourrepository
    ```
3. **Add upstream remote**:
    ```bash
    git remote add upstream https://github.com/originalowner/originalrepository.git
    ```
4. **Create a feature branch**:
    ```bash
    git checkout -b feature/your-feature-name
    ```

## Development Setup

### Prerequisites

-   [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
-   [Visual Studio Code](https://code.visualstudio.com/) or Visual Studio 2022+
-   [Node.js](https://nodejs.org/) (for MCP servers)
-   [Git](https://git-scm.com/)

### Initial Setup

1. **Restore dependencies**:

    ```bash
    dotnet restore
    ```

2. **Build the solution**:

    ```bash
    dotnet build
    ```

3. **Run tests**:

    ```bash
    dotnet test
    ```

4. **Install MCP servers** (optional, for AI assistance):
    ```powershell
    .\scripts\install-mcps.ps1
    ```

### VS Code Extensions

Install the recommended extensions when prompted, or manually install:

-   C# Dev Kit
-   GitHub Copilot (optional)
-   EditorConfig for VS Code
-   Markdown Lint

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

-   **Bug fixes**: Fix existing issues
-   **New features**: Add new functionality
-   **Documentation**: Improve or add documentation
-   **Tests**: Add or improve test coverage
-   **Performance**: Optimize existing code
-   **Refactoring**: Improve code quality without changing behavior

### Contribution Workflow

1. **Check existing issues** to avoid duplicate work
2. **Create an issue** for major changes to discuss first
3. **Write code** following our coding standards
4. **Add tests** for new functionality
5. **Update documentation** as needed
6. **Submit a pull request**

## Coding Standards

All code must follow the standards defined in `.github/instructions/cs.instructions.md`. Key points:

### Naming Conventions

-   **PascalCase**: Classes, methods, properties, public members
-   **camelCase**: Local variables, parameters
-   **\_camelCase**: Private fields (with underscore prefix)

### Code Style

-   Use file-scoped namespaces
-   Enable nullable reference types
-   Use modern C# features (C# 12)
-   Follow SOLID principles
-   One type per file

### Documentation

-   Add XML comments for all public APIs
-   Include `<summary>`, `<param>`, `<returns>`, `<exception>` tags
-   Provide usage examples for complex APIs

### Example

```csharp
namespace YourLibrary.Services;

/// <summary>
/// Provides customer management services.
/// </summary>
public class CustomerService
{
    private readonly ICustomerRepository _repository;

    /// <summary>
    /// Initializes a new instance of the <see cref="CustomerService"/> class.
    /// </summary>
    /// <param name="repository">The customer repository.</param>
    /// <exception cref="ArgumentNullException">
    /// Thrown when <paramref name="repository"/> is null.
    /// </exception>
    public CustomerService(ICustomerRepository repository)
    {
        ArgumentNullException.ThrowIfNull(repository);
        _repository = repository;
    }

    /// <summary>
    /// Gets a customer by their unique identifier.
    /// </summary>
    /// <param name="customerId">The customer identifier.</param>
    /// <returns>The customer if found; otherwise, null.</returns>
    public async Task<Customer?> GetCustomerAsync(int customerId)
    {
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(customerId);
        return await _repository.GetByIdAsync(customerId);
    }
}
```

## Testing Guidelines

### Test Organization

-   **Unit tests**: `tests/YourLibrary.Tests/UnitTests/`

    -   No external dependencies
    -   Fast and isolated
    -   Use mocking for dependencies

-   **Integration tests**: `tests/YourLibrary.Tests/IntegrationTests/`
    -   Test component interactions
    -   May use real dependencies
    -   Validate end-to-end scenarios

### Test Structure

Follow the Arrange-Act-Assert (AAA) pattern:

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

### Test Requirements

-   All new public methods must have tests
-   Aim for >80% code coverage for new code
-   Use descriptive test names
-   Use FluentAssertions for readable assertions
-   Tests should be fast and deterministic

### Running Tests

```bash
# Run all tests
dotnet test

# Run specific category
dotnet test --filter "FullyQualifiedName~UnitTests"

# Run with coverage
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
```

## Pull Request Process

### Before Submitting

1. **Update your branch** with latest upstream changes:

    ```bash
    git fetch upstream
    git rebase upstream/main
    ```

2. **Ensure all tests pass**:

    ```bash
    dotnet test
    ```

3. **Check code compiles** without warnings:

    ```bash
    dotnet build
    ```

4. **Run code analysis** (if available)

5. **Update documentation** for any API changes

### PR Guidelines

-   **Title**: Use a clear, descriptive title

    -   `feat: Add customer search functionality`
    -   `fix: Resolve null reference in OrderService`
    -   `docs: Update API documentation for CustomerService`
    -   `test: Add unit tests for PaymentProcessor`

-   **Description**: Include:

    -   What changes were made
    -   Why the changes were necessary
    -   Any breaking changes
    -   Related issue numbers (e.g., "Fixes #123")

-   **Size**: Keep PRs focused and reasonably sized

    -   Prefer smaller, focused PRs over large ones
    -   If making large changes, break into multiple PRs

-   **Commits**:
    -   Use clear, descriptive commit messages
    -   Squash commits if requested by reviewers

### PR Checklist

Before submitting, ensure:

-   [ ] Code follows project coding standards
-   [ ] All tests pass
-   [ ] New code has appropriate test coverage
-   [ ] XML documentation is complete for public APIs
-   [ ] No new compiler warnings introduced
-   [ ] README and documentation updated if needed
-   [ ] Breaking changes are documented
-   [ ] Commits have clear messages

### Review Process

1. **Automated checks** run on all PRs
2. **Code review** by maintainers
3. **Address feedback** if changes are requested
4. **Approval and merge** once all requirements are met

## Reporting Issues

### Bug Reports

When reporting bugs, include:

-   **Description**: Clear description of the issue
-   **Steps to reproduce**: Detailed steps to reproduce the problem
-   **Expected behavior**: What you expected to happen
-   **Actual behavior**: What actually happened
-   **Environment**: OS, .NET version, etc.
-   **Code sample**: Minimal reproducible example if possible

### Feature Requests

When requesting features, include:

-   **Use case**: Why is this feature needed?
-   **Proposed solution**: How should it work?
-   **Alternatives**: Any alternative solutions considered?
-   **Additional context**: Any other relevant information

### Issue Labels

We use labels to organize issues:

-   `bug`: Something isn't working
-   `enhancement`: New feature or request
-   `documentation`: Documentation improvements
-   `good first issue`: Good for newcomers
-   `help wanted`: Extra attention needed

## Development Tips

### Keeping Your Fork Updated

```bash
# Fetch upstream changes
git fetch upstream

# Update your main branch
git checkout main
git merge upstream/main

# Update your feature branch
git checkout feature/your-feature
git rebase main
```

### Code Analysis

Run code analysis before committing:

```bash
# Build with analysis
dotnet build /p:RunAnalyzers=true /p:TreatWarningsAsErrors=true
```

### Using AI Assistance

This project includes MCP servers for AI-assisted development:

-   Use GitHub Copilot for code suggestions
-   Refer to `.github/instructions/` for AI guidelines
-   Ensure AI-generated code is reviewed and tested

## Questions?

If you have questions:

1. Check existing documentation
2. Search existing issues
3. Create a new issue with the `question` label
4. Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing! 🎉

