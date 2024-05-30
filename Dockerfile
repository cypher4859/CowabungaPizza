FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

EXPOSE 8080

# copy csproj and restore as distinct layers
COPY CowabungaPizza/*.csproj CowabungaPizza/
COPY CowabungaPizza.Client/*.csproj CowabungaPizza.Client/
COPY CowabungaPizza.ComponentsLibrary/*.csproj CowabungaPizza.ComponentsLibrary/
COPY CowabungaPizza.Shared/*.csproj CowabungaPizza.Shared/
RUN dotnet restore CowabungaPizza/CowabungaPizza.csproj

COPY CowabungaPizza/ CowabungaPizza/
COPY CowabungaPizza.Client/ CowabungaPizza.Client/
COPY CowabungaPizza.ComponentsLibrary/ CowabungaPizza.ComponentsLibrary/
COPY CowabungaPizza.Shared/ CowabungaPizza.Shared/

FROM build AS publish
WORKDIR /source/CowabungaPizza
RUN dotnet publish --no-restore -o /app

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT [ "dotnet", "CowabungaPizza.dll" ]