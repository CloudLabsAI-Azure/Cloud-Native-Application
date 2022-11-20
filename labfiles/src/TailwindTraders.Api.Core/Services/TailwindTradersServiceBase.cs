namespace TailwindTraders.Api.Core.Services;

internal abstract class TailwindTradersServiceBase
{
    protected readonly IConfiguration Configuration;
    protected readonly IMapper Mapper;

    protected TailwindTradersServiceBase(IMapper mapper, IConfiguration configuration)
    {
        Mapper = mapper;
        Configuration = configuration;
    }
}