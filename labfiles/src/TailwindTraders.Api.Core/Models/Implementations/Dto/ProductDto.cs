using Type = contosoTraders.Api.Core.Models.Implementations.Dao.Type;

namespace contosoTraders.Api.Core.Models.Implementations.Dto;

public class ProductDto
{
    public int Id { get; set; }

    public string Name { get; set; }

    public decimal? Price { get; set; }

    public string ImageUrl { get; set; }

    public Brand Brand { get; set; }

    public Type Type { get; set; }

    public IEnumerable<Feature> Features { get; set; }

    public int StockUnits { get; set; }
}