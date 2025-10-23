---
applyTo: "**"
---

# AI Assistant Instructions - Base Guidelines

This document provides core instructions for AI assistants working with this .NET 9 class library project.

## Core Principles

1. **Complete Implementation**: Always complete the entire method, class, or feature—not just partial implementations
2. **Clarity Over Cleverness**: Prefer explicit, clear, and idiomatic code over clever or terse constructs
3. **Documentation First**: Include XML documentation comments for all public APIs
4. **Test Coverage**: Ensure adequate test coverage for all new code
5. **Code Quality**: Maintain high code quality standards and follow project conventions

## Code Generation Standards

### What is Expected

- ✅ Complete implementations (no placeholder comments like `// TODO: Implement this`)
- ✅ Follow C# coding standards defined in `cs.instructions.md`
- ✅ Use modern .NET 9 and C# 12 features appropriately
- ✅ Include comprehensive XML documentation for public APIs
- ✅ Add appropriate error handling and validation
- ✅ Consider thread safety when applicable
- ✅ Use dependency injection patterns
- ✅ Follow SOLID principles

### What to Avoid

- ❌ Partial or incomplete implementations
- ❌ Magic numbers or hard-coded values without explanation
- ❌ Swallowing exceptions without proper handling
- ❌ Breaking existing tests
- ❌ Introducing new compiler warnings or errors
- ❌ Code that violates established patterns in the codebase

## Acceptance Criteria

All generated or modified code must meet these criteria:

1. **Compilation**: Code must compile without errors or warnings
2. **Tests**: All existing tests must pass; new features must have tests
3. **Code Analysis**: No new code analysis issues (SonarQube, Roslyn analyzers)
4. **Documentation**: Updated documentation reflecting any API or behavior changes
5. **Standards Compliance**: Follows all guidelines in `cs.instructions.md`

## Documentation Requirements

### Code Documentation

- **XML Comments**: Required for all public types and members
- **Inline Comments**: Use sparingly, explain "why" not "what"
- **Examples**: Include usage examples in XML comments for complex APIs

### Project Documentation

1. **README.md Files**
   - Root: Overall project description, getting started, architecture
   - Folders: Purpose and organization of folder contents
   - Projects: Specific project information and usage

2. **Design Documentation** (`docs/design/`)
   - Architectural decisions and patterns
   - Complex algorithms or workflows
   - Integration patterns
   - Performance considerations

3. **API Documentation** (`docs/api/`)
   - Generated from XML comments
   - Usage examples and tutorials
   - Migration guides for breaking changes

## Testing Standards

### Test Organization

- **Unit Tests**: In `tests/YourLibrary.Tests/UnitTests/`
  - No external dependencies (database, network, file system)
  - Fast execution
  - Use mocking for dependencies
  - Follow AAA pattern (Arrange-Act-Assert)

- **Integration Tests**: In `tests/YourLibrary.Tests/IntegrationTests/`
  - Test component interactions
  - May use real dependencies
  - Validate end-to-end scenarios

### Test Requirements

- All new public methods must have unit tests
- Use descriptive test names: `MethodName_Scenario_ExpectedResult`
- Use FluentAssertions for readable assertions
- Aim for high code coverage (>80% for new code)
- Tests should be isolated and repeatable

## Code Quality

### Static Analysis

- Run code analysis before committing changes
- Address all warnings and errors
- No new code quality issues
- Maintain or improve code coverage

### Code Review Checklist

Before submitting code, verify:

- [ ] Code compiles without warnings
- [ ] All tests pass
- [ ] New code has appropriate tests
- [ ] XML documentation is complete
- [ ] Follows naming conventions
- [ ] No magic numbers or hard-coded values
- [ ] Error handling is appropriate
- [ ] No security vulnerabilities introduced
- [ ] Performance impact is acceptable
- [ ] Documentation is updated

## File Organization

### Project Structure

```
YourLibrary/
├── src/YourLibrary/           # Main library code
│   ├── Models/                # Domain models
│   ├── Services/              # Business logic
│   ├── Repositories/          # Data access
│   ├── Interfaces/            # Abstractions
│   ├── Exceptions/            # Custom exceptions
│   └── Extensions/            # Extension methods
├── tests/YourLibrary.Tests/
│   ├── UnitTests/             # Unit tests (isolated)
│   └── IntegrationTests/      # Integration tests (with dependencies)
└── docs/                      # Documentation
    ├── api/                   # API documentation
    └── design/                # Design documents
```

### Naming Conventions

- One type per file
- File name matches type name exactly
- Organize by feature or layer, not by type
- Keep folder depth reasonable (max 3-4 levels)

## Language and Framework Guidelines

### .NET 9 Features

Leverage modern .NET features:
- Primary constructors
- Collection expressions
- Improved pattern matching
- Required members
- Init-only properties
- Record types for immutable data

### Async/Await

- Use `async`/`await` for I/O-bound operations
- Suffix async methods with `Async`
- Avoid `async void` (except event handlers)
- Use `ConfigureAwait(false)` in library code when appropriate
- Return `ValueTask<T>` for hot paths when beneficial

### Dependency Injection

- Use constructor injection
- Inject interfaces, not concrete types
- Validate dependencies in constructor
- Follow the Explicit Dependencies Principle

## Error Handling

### Exception Guidelines

- Use guard clauses with modern validation methods:
  - `ArgumentNullException.ThrowIfNull()`
  - `ArgumentException.ThrowIfNullOrWhiteSpace()`
  - `ArgumentOutOfRangeException.ThrowIfNegativeOrZero()`
- Create custom exceptions for domain-specific errors
- Don't swallow exceptions
- Log errors before rethrowing or wrapping
- Include helpful error messages

### Validation

- Validate at API boundaries
- Use Data Annotations where appropriate
- Provide clear validation error messages
- Consider using FluentValidation for complex validation

## Performance Considerations

- Avoid premature optimization
- Use benchmarks for performance-critical code
- Consider memory allocations in hot paths
- Use `Span<T>` and `Memory<T>` where appropriate
- Profile before optimizing

## Security Guidelines

- Never hard-code secrets or credentials
- Validate all input from external sources
- Use parameterized queries for database access
- Sanitize data before output
- Follow principle of least privilege
- Keep dependencies up-to-date

## Breaking Changes

When making breaking changes:

1. Document the breaking change clearly
2. Provide migration path
3. Update version number appropriately (semantic versioning)
4. Update CHANGELOG.md
5. Consider deprecation warnings before removal

## AI-Specific Guidelines

### When Generating Code

1. **Understand Context**: Read related code before making changes
2. **Follow Patterns**: Match existing patterns in the codebase
3. **Be Consistent**: Use consistent naming and structure
4. **Think Holistically**: Consider impact on entire codebase
5. **Validate Assumptions**: Check if libraries/APIs exist before using them

### When Refactoring

1. **Preserve Behavior**: Don't change functionality during refactoring
2. **Small Steps**: Make incremental changes
3. **Test After Each Step**: Ensure tests pass after each change
4. **Update Tests**: Refactor tests along with production code

### When Adding Features

1. **Start with Tests**: Write tests first (TDD) when possible
2. **Implement Incrementally**: Build feature in small, testable pieces
3. **Document as You Go**: Add documentation with the code
4. **Consider Edge Cases**: Think about error conditions and boundaries

## Summary

The goal is to produce **production-ready, maintainable code** that:
- Follows established patterns and conventions
- Is well-tested and documented
- Meets performance and security standards
- Can be easily understood and modified by other developers

Always refer to `cs.instructions.md` for detailed C# coding standards.



