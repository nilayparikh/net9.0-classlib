# C# Coding Standards and Conventions

This document outlines the C# coding standards for this project. All code should follow these conventions to ensure consistency and maintainability.

## Table of Contents

1. [Naming Conventions](#naming-conventions)
2. [File Organization](#file-organization)
3. [Namespace Guidelines](#namespace-guidelines)
4. [Class Structure](#class-structure)
5. [Code Formatting](#code-formatting)
6. [Language Features](#language-features)
7. [Documentation](#documentation)
8. [Error Handling](#error-handling)
9. [Testing Standards](#testing-standards)
10. [Best Practices](#best-practices)

---

## Naming Conventions

### General Rules

- **PascalCase**: Use for class names, method names, property names, constants, and public fields
- **camelCase**: Use for local variables, private fields (with underscore prefix), and parameters
- **UPPER_CASE**: Avoid (use PascalCase for constants instead)

### Specific Guidelines

```csharp
// ✅ CORRECT
public class CustomerService { }
public interface ICustomerRepository { }
public enum OrderStatus { Pending, Approved, Rejected }

// Private fields with underscore prefix
private readonly ILogger _logger;
private int _counter;

// Properties use PascalCase
public string CustomerName { get; set; }

// Methods use PascalCase
public async Task<Customer> GetCustomerByIdAsync(int customerId)
{
    // Local variables use camelCase
    var customerData = await _repository.GetAsync(customerId);
    return customerData;
}

// Constants use PascalCase
private const int MaxRetryCount = 3;
public static readonly TimeSpan DefaultTimeout = TimeSpan.FromSeconds(30);

// ❌ INCORRECT
public class customer_service { }  // Wrong casing
private int Counter;                // Private field should be _counter
public const int MAX_RETRY = 3;    // Use PascalCase, not UPPER_CASE
```

### Interface Naming

- Always prefix interfaces with `I`
- Use descriptive names that indicate behavior

```csharp
// ✅ CORRECT
public interface ICustomerRepository { }
public interface IEmailSender { }
public interface IDisposable { }

// ❌ INCORRECT
public interface CustomerRepository { }  // Missing 'I' prefix
public interface Customer { }             // Ambiguous
```

### Generic Type Parameters

- Use descriptive names prefixed with `T`
- For single type parameters, `T` alone is acceptable

```csharp
// ✅ CORRECT
public class Repository<T> where T : class { }
public class Dictionary<TKey, TValue> { }
public interface IConverter<TInput, TOutput> { }

// ❌ INCORRECT
public class Repository<Type> { }  // Don't use 'Type'
public class Dictionary<K, V> { }  // Use descriptive names
```

---

## File Organization

### One Class Per File

- Each class, interface, or enum should be in its own file
- File name must match the type name exactly

```csharp
// File: CustomerService.cs
namespace YourLibrary.Services;

public class CustomerService
{
    // Implementation
}
```

### File Structure Order

1. File header comment (if required)
2. `using` statements (organized by groups)
3. `namespace` declaration (file-scoped preferred in .NET 6+)
4. Type declarations (classes, interfaces, enums)

```csharp
// File: CustomerRepository.cs

// Using statements - organized
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using Microsoft.Extensions.Logging;

using YourLibrary.Models;
using YourLibrary.Interfaces;

// File-scoped namespace (preferred in .NET 6+)
namespace YourLibrary.Repositories;

/// <summary>
/// Repository for customer data operations.
/// </summary>
public class CustomerRepository : ICustomerRepository
{
    // Implementation
}
```

### Using Statements Organization

Group usings in the following order:
1. System namespaces
2. Microsoft namespaces
3. Third-party namespaces
4. Project namespaces

Separate groups with blank lines.

---

## Namespace Guidelines

### Namespace Structure

```csharp
// ✅ CORRECT - Follows project structure
namespace YourLibrary;                          // Root
namespace YourLibrary.Models;                   // Domain models
namespace YourLibrary.Services;                 // Business logic
namespace YourLibrary.Repositories;             // Data access
namespace YourLibrary.Interfaces;               // Contracts
namespace YourLibrary.Exceptions;               // Custom exceptions
namespace YourLibrary.Extensions;               // Extension methods
namespace YourLibrary.Utilities;                // Helper utilities

// ❌ INCORRECT
namespace YourLibrary.Stuff;                    // Vague
namespace Utils;                                 // Too generic
namespace YourLibrary.SomeFeature.Helpers.Misc; // Too deep
```

### File-Scoped Namespaces (Preferred in .NET 6+)

```csharp
// ✅ PREFERRED
namespace YourLibrary.Services;

public class CustomerService
{
    // No extra indentation needed
}

// ❌ OLD STYLE (still valid but not preferred)
namespace YourLibrary.Services
{
    public class CustomerService
    {
        // Extra indentation level
    }
}
```

---

## Class Structure

### Member Order

Organize class members in the following order:

1. Constants
2. Static fields
3. Fields (private)
4. Constructors
5. Finalizers (if needed)
6. Properties
7. Indexers
8. Events
9. Methods (public first, then protected, then private)
10. Nested types

```csharp
public class Customer
{
    // 1. Constants
    private const int MaxNameLength = 100;

    // 2. Static fields
    private static readonly ILogger _staticLogger = LoggerFactory.Create();

    // 3. Fields
    private readonly ICustomerRepository _repository;
    private int _retryCount;

    // 4. Constructor
    public Customer(ICustomerRepository repository)
    {
        _repository = repository ?? throw new ArgumentNullException(nameof(repository));
    }

    // 6. Properties
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;

    // 8. Events
    public event EventHandler? DataChanged;

    // 9. Public methods
    public async Task SaveAsync()
    {
        await _repository.SaveAsync(this);
    }

    // Private methods
    private void ValidateName()
    {
        if (string.IsNullOrWhiteSpace(Name))
            throw new InvalidOperationException("Name cannot be empty");
    }
}
```

### Access Modifiers

Always explicitly specify access modifiers:

```csharp
// ✅ CORRECT
public class Customer { }
internal class InternalHelper { }
private readonly ILogger _logger;

// ❌ INCORRECT
class Customer { }  // Missing access modifier
```

---

## Code Formatting

### Braces and Indentation

- Use Allman style (opening brace on new line)
- Use 4 spaces for indentation (not tabs)

```csharp
// ✅ CORRECT
public void ProcessOrder(Order order)
{
    if (order == null)
    {
        throw new ArgumentNullException(nameof(order));
    }

    foreach (var item in order.Items)
    {
        ProcessItem(item);
    }
}

// ❌ INCORRECT - K&R style
public void ProcessOrder(Order order) {
    if (order == null) {
        throw new ArgumentNullException(nameof(order));
    }
}
```

### Line Length

- Keep lines under 120 characters when possible
- Break long method chains into multiple lines

```csharp
// ✅ CORRECT
var customers = await _repository
    .GetAll()
    .Where(c => c.IsActive)
    .OrderBy(c => c.Name)
    .ToListAsync();

// ❌ INCORRECT - Too long
var customers = await _repository.GetAll().Where(c => c.IsActive).OrderBy(c => c.Name).ToListAsync();
```

### Blank Lines

- One blank line between methods
- One blank line between property groups
- No blank lines at the beginning or end of code blocks

```csharp
public class Example
{
    public int Property1 { get; set; }
    public string Property2 { get; set; } = string.Empty;

    public void Method1()
    {
        // No blank line here
        var x = 1;
    }

    public void Method2()
    {
        var y = 2;
        // No blank line here
    }
}
```

---

## Language Features

### Use Modern C# Features

```csharp
// ✅ CORRECT - Modern C# 12/11/10
public class Product
{
    // Primary constructor (C# 12)
    public required string Name { get; init; }
    public decimal Price { get; init; }

    // Pattern matching
    public string GetPriceCategory() => Price switch
    {
        < 10 => "Budget",
        < 100 => "Standard",
        _ => "Premium"
    };

    // Target-typed new (C# 9)
    public List<string> Tags { get; } = new();

    // String interpolation
    public override string ToString() => $"{Name} - ${Price:F2}";
}

// ❌ AVOID - Old style
public class Product
{
    public Product()
    {
        Tags = new List<string>();
    }

    public string Name { get; set; }
    public decimal Price { get; set; }

    public string GetPriceCategory()
    {
        if (Price < 10)
            return "Budget";
        else if (Price < 100)
            return "Standard";
        else
            return "Premium";
    }
}
```

### Nullable Reference Types

Always enable nullable reference types and use them correctly:

```csharp
// In .csproj: <Nullable>enable</Nullable>

// ✅ CORRECT
public class Customer
{
    public string Name { get; set; } = string.Empty;  // Non-nullable, initialized
    public string? MiddleName { get; set; }           // Nullable

    public void UpdateName(string name)  // Non-nullable parameter
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        Name = name;
    }

    public string? FindCustomer(int id)  // Nullable return
    {
        // May return null
        return _repository.Find(id)?.Name;
    }
}

// ❌ INCORRECT
public class Customer
{
    public string Name { get; set; }  // Warning: may be null
}
```

### Use Expression-Bodied Members

```csharp
// ✅ CORRECT - For simple members
public class Rectangle
{
    public double Width { get; }
    public double Height { get; }

    public Rectangle(double width, double height) =>
        (Width, Height) = (width, height);

    public double Area => Width * Height;

    public override string ToString() => $"{Width}x{Height}";
}

// For complex logic, use block body
public async Task<Customer> GetCustomerAsync(int id)
{
    var customer = await _repository.GetAsync(id);
    await LogAccessAsync(id);
    return customer;
}
```

### LINQ Preferences

```csharp
// ✅ CORRECT - Method syntax for simple queries
var activeCustomers = customers.Where(c => c.IsActive);
var names = customers.Select(c => c.Name);

// Query syntax for complex queries with multiple clauses
var result = from customer in customers
             join order in orders on customer.Id equals order.CustomerId
             where customer.IsActive && order.Total > 100
             select new { customer.Name, order.Total };

// Use async LINQ methods
var customers = await _repository
    .GetAll()
    .Where(c => c.IsActive)
    .ToListAsync();
```

---

## Documentation

### XML Documentation Comments

Document all public APIs:

```csharp
/// <summary>
/// Represents a customer in the system.
/// </summary>
public class Customer
{
    /// <summary>
    /// Gets or sets the unique identifier for the customer.
    /// </summary>
    public int Id { get; set; }

    /// <summary>
    /// Gets or sets the customer's full name.
    /// </summary>
    /// <remarks>
    /// The name must not exceed 100 characters.
    /// </remarks>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Validates the customer data.
    /// </summary>
    /// <returns>
    /// <c>true</c> if the customer data is valid; otherwise, <c>false</c>.
    /// </returns>
    /// <exception cref="InvalidOperationException">
    /// Thrown when the customer ID is not set.
    /// </exception>
    public bool Validate()
    {
        if (Id <= 0)
            throw new InvalidOperationException("Customer ID must be set");

        return !string.IsNullOrWhiteSpace(Name);
    }
}
```

### Code Comments

- Use `//` for single-line comments
- Explain "why", not "what"
- Keep comments up-to-date with code changes

```csharp
// ✅ CORRECT - Explains WHY
// Use exponential backoff to avoid overwhelming the service
await Task.Delay(TimeSpan.FromSeconds(Math.Pow(2, retryCount)));

// ❌ INCORRECT - States the obvious
// Increment retry count by 1
retryCount++;
```

---

## Error Handling

### Exception Handling

```csharp
// ✅ CORRECT
public async Task<Customer> GetCustomerAsync(int id)
{
    ArgumentOutOfRangeException.ThrowIfNegativeOrZero(id);

    try
    {
        return await _repository.GetAsync(id);
    }
    catch (DbException ex)
    {
        _logger.LogError(ex, "Failed to retrieve customer {CustomerId}", id);
        throw new DataAccessException($"Failed to retrieve customer {id}", ex);
    }
}

// ❌ INCORRECT - Swallowing exceptions
try
{
    return await _repository.GetAsync(id);
}
catch (Exception)
{
    return null;  // Don't hide errors
}

// ❌ INCORRECT - Catching too broadly without rethrowing
catch (Exception ex)
{
    _logger.LogError(ex, "Error occurred");
    // Should rethrow or wrap in domain exception
}
```

### Guard Clauses

Use guard clauses and modern validation methods:

```csharp
// ✅ CORRECT - .NET 6+
public void ProcessOrder(Order order, string customerName)
{
    ArgumentNullException.ThrowIfNull(order);
    ArgumentException.ThrowIfNullOrWhiteSpace(customerName);

    // Main logic here
}

// ✅ CORRECT - .NET 8+
public void SetQuantity(int quantity)
{
    ArgumentOutOfRangeException.ThrowIfNegativeOrZero(quantity);

    _quantity = quantity;
}
```

---

## Testing Standards

### Test Structure

Follow the Arrange-Act-Assert (AAA) pattern:

```csharp
[Fact]
public void GetDiscountedPrice_WithValidDiscount_ReturnsReducedPrice()
{
    // Arrange
    var product = new Product { Price = 100 };
    var discount = 0.2m;

    // Act
    var result = product.GetDiscountedPrice(discount);

    // Assert
    result.Should().Be(80);
}
```

### Test Naming

- Use descriptive names: `MethodName_Scenario_ExpectedResult`
- Make tests readable and self-documenting

```csharp
// ✅ CORRECT
[Fact]
public void Withdraw_WithInsufficientFunds_ThrowsInvalidOperationException()

[Theory]
[InlineData(0)]
[InlineData(-10)]
public void SetPrice_WithInvalidValue_ThrowsArgumentOutOfRangeException(decimal price)

// ❌ INCORRECT
[Fact]
public void Test1()
[Fact]
public void WithdrawTest()
```

### Unit vs Integration Tests

**Unit Tests** (`UnitTests/` folder):
- No external dependencies
- Use mocks/fakes
- Fast execution
- Test single responsibility

**Integration Tests** (`IntegrationTests/` folder):
- Test component interactions
- May use real dependencies
- Slower execution
- Validate end-to-end scenarios

---

## Best Practices

### Dependency Injection

```csharp
// ✅ CORRECT
public class CustomerService
{
    private readonly ICustomerRepository _repository;
    private readonly ILogger<CustomerService> _logger;

    public CustomerService(
        ICustomerRepository repository,
        ILogger<CustomerService> logger)
    {
        _repository = repository ?? throw new ArgumentNullException(nameof(repository));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }
}
```

### Async/Await

```csharp
// ✅ CORRECT
public async Task<IEnumerable<Customer>> GetActiveCustomersAsync()
{
    return await _repository
        .GetAll()
        .Where(c => c.IsActive)
        .ToListAsync();
}

// ❌ INCORRECT - Async void (except for event handlers)
public async void ProcessOrder(Order order)  // Don't do this
{
    await _service.ProcessAsync(order);
}

// ❌ INCORRECT - Unnecessary async
public async Task<int> GetCountAsync()
{
    return await Task.FromResult(42);  // Just return 42 directly
}
```

### Immutability

Prefer immutable types when possible:

```csharp
// ✅ CORRECT
public record Product(string Name, decimal Price);

public class Money
{
    public decimal Amount { get; init; }
    public string Currency { get; init; } = "USD";
}

// For mutable objects, prefer init-only setters
public class Customer
{
    public required string Name { get; init; }
    public string Email { get; init; } = string.Empty;
}
```

### SOLID Principles

Follow SOLID principles:
- **S**ingle Responsibility Principle
- **O**pen/Closed Principle
- **L**iskov Substitution Principle
- **I**nterface Segregation Principle
- **D**ependency Inversion Principle

```csharp
// ✅ CORRECT - Single Responsibility
public class OrderValidator
{
    public bool Validate(Order order) { /* ... */ }
}

public class OrderProcessor
{
    public void Process(Order order) { /* ... */ }
}

// ❌ INCORRECT - Multiple responsibilities
public class OrderManager
{
    public bool Validate(Order order) { /* ... */ }
    public void Process(Order order) { /* ... */ }
    public void SendEmail(Order order) { /* ... */ }
    public void LogOrder(Order order) { /* ... */ }
}
```

---

## Summary Checklist

- [ ] Use correct naming conventions (PascalCase, camelCase, _prefix for fields)
- [ ] One type per file, file name matches type name
- [ ] Use file-scoped namespaces
- [ ] Follow member order in classes
- [ ] Enable and use nullable reference types
- [ ] Use modern C# features (pattern matching, expression bodies, etc.)
- [ ] Document public APIs with XML comments
- [ ] Use proper error handling with guard clauses
- [ ] Follow AAA pattern in tests
- [ ] Separate unit tests from integration tests
- [ ] Use dependency injection
- [ ] Prefer immutability where appropriate
- [ ] Follow SOLID principles

---

**Note**: These standards should be enforced through:
- `.editorconfig` file
- Code analysis rules
- Code reviews
- Automated linting in CI/CD (when implemented)
