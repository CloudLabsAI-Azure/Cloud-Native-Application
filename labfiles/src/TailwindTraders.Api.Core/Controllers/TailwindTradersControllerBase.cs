namespace contosoTraders.Api.Core.Controllers;

[ApiController]
public class contosoTradersControllerBase : ControllerBase
{
    private readonly IMediator _mediator;

    protected contosoTradersControllerBase(IMediator mediator)
    {
        _mediator = mediator;
    }

    protected async Task<IActionResult> ProcessHttpRequestAsync(IRequest<IActionResult> request)
    {
        try
        {
            return await _mediator.Send(request);
        }
        catch (contosoTradersBaseException contosoTradersBaseException)
        {
            return contosoTradersBaseException.ToActionResult();
        }
        catch (ValidationException validationException)
        {
            return new BadRequestObjectResult(validationException.Message);
        }
    }
}