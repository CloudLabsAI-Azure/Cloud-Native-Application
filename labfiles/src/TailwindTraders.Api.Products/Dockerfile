FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["contosoTraders.Api.Products/contosoTraders.Api.Products.csproj", "contosoTraders.Api.Products/"]
COPY ["contosoTraders.Api.Core/contosoTraders.Api.Core.csproj", "contosoTraders.Api.Core/"]
RUN dotnet restore "contosoTraders.Api.Products/contosoTraders.Api.Products.csproj"
COPY . .
WORKDIR "/src/contosoTraders.Api.Products"
RUN dotnet build "contosoTraders.Api.Products.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "contosoTraders.Api.Products.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "contosoTraders.Api.Products.dll"]