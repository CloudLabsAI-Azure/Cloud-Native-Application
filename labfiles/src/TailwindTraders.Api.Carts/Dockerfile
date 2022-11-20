FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["TailwindTraders.Api.Carts/TailwindTraders.Api.Carts.csproj", "TailwindTraders.Api.Carts/"]
COPY ["TailwindTraders.Api.Core/TailwindTraders.Api.Core.csproj", "TailwindTraders.Api.Core/"]
RUN dotnet restore "TailwindTraders.Api.Carts/TailwindTraders.Api.Carts.csproj"
COPY . .
WORKDIR "/src/TailwindTraders.Api.Carts"
RUN dotnet build "TailwindTraders.Api.Carts.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TailwindTraders.Api.Carts.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TailwindTraders.Api.Carts.dll"]