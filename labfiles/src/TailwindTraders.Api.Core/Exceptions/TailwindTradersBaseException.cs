namespace contosoTraders.Api.Core.Exceptions;

public abstract class contosoTradersBaseException : Exception
{
    protected contosoTradersBaseException(string message) : base(message)
    {
    }

    public abstract IActionResult ToActionResult();
}