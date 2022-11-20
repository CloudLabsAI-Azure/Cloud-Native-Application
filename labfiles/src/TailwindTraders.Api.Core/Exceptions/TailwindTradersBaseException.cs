namespace TailwindTraders.Api.Core.Exceptions;

public abstract class TailwindTradersBaseException : Exception
{
    protected TailwindTradersBaseException(string message) : base(message)
    {
    }

    public abstract IActionResult ToActionResult();
}