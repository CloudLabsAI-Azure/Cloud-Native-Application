namespace TailwindTraders.Api.Core.Controllers;

[ApiController]
public class TailwindTradersControllerBase : ControllerBase
{
    private readonly IMediator _mediator;

    protected TailwindTradersControllerBase(IMediator mediator)
    {
        _mediator = mediator;
    }

    protected async Task<IActionResult> ProcessHttpRequestAsync(IRequest<IActionResult> request)
    {
        try
        {
            return await _mediator.Send(request);
        }
        catch (TailwindTradersBaseException tailwindTradersBaseException)
        {
            return tailwindTradersBaseException.ToActionResult();
        }
        catch (ValidationException validationException)
        {
            return new BadRequestObjectResult(validationException.Message);
        }
    }
}