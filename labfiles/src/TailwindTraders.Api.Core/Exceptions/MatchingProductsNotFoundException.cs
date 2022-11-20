namespace TailwindTraders.Api.Core.Exceptions;

public class MatchingProductsNotFoundException : TailwindTradersBaseException
{
    public MatchingProductsNotFoundException(string tags)
        : base($"No matching products found for tags :  {tags}")
    {
    }

    public override IActionResult ToActionResult()
    {
        return new NotFoundObjectResult(Message);
    }
}