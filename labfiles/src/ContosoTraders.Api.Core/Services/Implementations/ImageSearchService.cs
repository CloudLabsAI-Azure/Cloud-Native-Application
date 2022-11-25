namespace ContosoTraders.Api.Core.Services.Implementations;

internal class ImageSearchService : IImageSearchService
{
    private readonly IImageAnalysisService _imageAnalysisService;

    private readonly IProductService _productService;

    public ImageSearchService(IProductService productService, IImageAnalysisService imageAnalysisService)
    {
        _productService = productService;
        _imageAnalysisService = imageAnalysisService;
    }

    public async Task<IEnumerable<ProductDto>> GetSimilarProductsAsync(Stream imageStream, CancellationToken cancellationToken = default)
    {
        var searchTerms = await _imageAnalysisService.AnalyzeImageAsync(imageStream, cancellationToken);

        var products = new List<ProductDto>();

        foreach (var term in searchTerms)
        {
            var matchingProducts = _productService.GetProducts(term);

            if (matchingProducts.Any())
                products.AddRange(matchingProducts);
        }

        if (!products.Any())
        {
            var searchTags = string.Empty;

            searchTerms.ToList().ForEach(tag => { searchTags += $"{tag}, "; });

            searchTags = searchTags.Remove(searchTags.Length - 2, 2) + '.';

            throw new MatchingProductsNotFoundException(searchTags);
        }

        products = products.Distinct().ToList();

        return products;
    }
}