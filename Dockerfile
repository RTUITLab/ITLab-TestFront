FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ITLab.TestFront/ITLab.TestFront.csproj ./ITLab.TestFront/
RUN dotnet restore "ITLab.TestFront"
COPY . .
RUN dotnet build "ITLab.TestFront" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ITLab.TestFront" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://*:9003
ENTRYPOINT ["dotnet", "ITLab.TestFront.dll"]