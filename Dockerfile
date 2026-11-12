FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY IdentityDemoApp/IdentityDemoApp.csproj IdentityDemoApp/
RUN dotnet restore IdentityDemoApp/IdentityDemoApp.csproj

COPY IdentityDemoApp/ IdentityDemoApp/
WORKDIR /src/IdentityDemoApp
RUN dotnet publish IdentityDemoApp.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["sh", "-c", "dotnet IdentityDemoApp.dll --urls http://0.0.0.0:${PORT:-8080}"]
