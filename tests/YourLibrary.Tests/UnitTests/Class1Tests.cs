namespace YourLibrary.Tests.UnitTests;

/// <summary>
/// Unit tests for Class1.
/// Unit tests should not have external dependencies (no database, no network, no file system).
/// </summary>
public class Class1Tests
{
    [Fact]
    public void Greet_WithValidName_ReturnsGreeting()
    {
        // Arrange
        var sut = new Class1();
        var name = "World";

        // Act
        var result = sut.Greet(name);

        // Assert
        result.Should().Be("Hello, World!");
    }

    [Fact]
    public void Greet_WithNullName_ThrowsArgumentException()
    {
        // Arrange
        var sut = new Class1();

        // Act
        var act = () => sut.Greet(null!);

        // Assert
        act.Should().Throw<ArgumentException>();
    }

    [Theory]
    [InlineData("")]
    [InlineData(" ")]
    [InlineData("   ")]
    public void Greet_WithEmptyOrWhitespaceName_ThrowsArgumentException(string name)
    {
        // Arrange
        var sut = new Class1();

        // Act
        var act = () => sut.Greet(name);

        // Assert
        act.Should().Throw<ArgumentException>();
    }
}
