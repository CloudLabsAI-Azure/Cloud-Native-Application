FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["TailwindTraders.Api.Products/TailwindTraders.Api.Products.csproj", "TailwindTraders.Api.Products/"]
COPY ["TailwindTraders.Api.Core/TailwindTraders.Api.Core.csproj", "TailwindTraders.Api.Core/"]
RUN dotnet restore "TailwindTraders.Api.Products/TailwindTraders.Api.Products.csproj"
COPY . .
WORKDIR "/src/TailwindTraders.Api.Products"
RUN dotnet build "TailwindTraders.Api.Products.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TailwindTraders.Api.Products.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TailwindTraders.Api.Products.dll"]