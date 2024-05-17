# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

EXPOSE 8080

# copy csproj and restore as distinct layers
COPY CowabungaPizza/*.csproj CowabungaPizza/
COPY CowabungaPizza.Client/*.csproj CowabungaPizza.Client/
COPY CowabungaPizza.ComponentsLibrary/*.csproj CowabungaPizza.ComponentsLibrary/
COPY CowabungaPizza.Shared/*.csproj CowabungaPizza.Shared/
RUN dotnet restore CowabungaPizza/CowabungaPizza.csproj

# # copy and build app and libraries
COPY CowabungaPizza/ CowabungaPizza/
COPY CowabungaPizza.Client/ CowabungaPizza.Client/
COPY CowabungaPizza.ComponentsLibrary/ CowabungaPizza.ComponentsLibrary/
COPY CowabungaPizza.Shared/ CowabungaPizza.Shared/

# # test stage -- exposes optional entrypoint
# # target entrypoint with: docker build --target test
# FROM build AS test

# COPY tests/*.csproj tests/
# WORKDIR /source/tests
# RUN dotnet restore

# COPY tests/ .
# RUN dotnet build --no-restore

# ENTRYPOINT ["dotnet", "test", "--logger:trx", "--no-build"]


FROM build AS publish
WORKDIR /source/CowabungaPizza
RUN dotnet publish --no-restore -o /app

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "CowabungaPizza.dll"]