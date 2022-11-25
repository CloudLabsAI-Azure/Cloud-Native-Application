namespace contosoTraders.Api.Core.Services;

internal abstract class contosoTradersServiceBase
{
    protected readonly IConfiguration Configuration;
    protected readonly IMapper Mapper;

    protected contosoTradersServiceBase(IMapper mapper, IConfiguration configuration)
    {
        Mapper = mapper;
        Configuration = configuration;
    }
}