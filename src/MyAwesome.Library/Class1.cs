namespace YourLibrary;

/// <summary>
/// Example class demonstrating the library structure.
/// </summary>
public class Class1
{
    /// <summary>
    /// Example method that returns a greeting message.
    /// </summary>
    /// <param name="name">The name to greet.</param>
    /// <returns>A greeting message.</returns>
    public string Greet(string name)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        return $"Hello, {name}!";
    }
}
