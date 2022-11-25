namespace ContosoTraders.Api.Core.Services;

internal abstract class ContosoTradersServiceBase
{
    protected readonly IConfiguration Configuration;
    protected readonly IMapper Mapper;

    protected ContosoTradersServiceBase(IMapper mapper, IConfiguration configuration)
    {
        Mapper = mapper;
        Configuration = configuration;
    }
}