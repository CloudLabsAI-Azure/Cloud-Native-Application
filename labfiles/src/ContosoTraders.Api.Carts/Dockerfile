FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["contosoTraders.Api.Carts/contosoTraders.Api.Carts.csproj", "contosoTraders.Api.Carts/"]
COPY ["contosoTraders.Api.Core/contosoTraders.Api.Core.csproj", "contosoTraders.Api.Core/"]
RUN dotnet restore "contosoTraders.Api.Carts/contosoTraders.Api.Carts.csproj"
COPY . .
WORKDIR "/src/contosoTraders.Api.Carts"
RUN dotnet build "contosoTraders.Api.Carts.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "contosoTraders.Api.Carts.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "contosoTraders.Api.Carts.dll"]