namespace contosoTraders.Api.Core.Exceptions;

public class ProfileNotFoundException : contosoTradersBaseException
{
    public ProfileNotFoundException(string email)
        : base($"Profile for email '{email}' could not be found.")
    {
    }

    public override IActionResult ToActionResult()
    {
        return new NotFoundObjectResult(Message);
    }
}