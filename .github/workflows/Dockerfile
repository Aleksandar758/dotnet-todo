# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy .csproj and restore dependencies
COPY ["TodoApi.csproj", "./"]
RUN dotnet restore "TodoApi.csproj"

# Copy the rest of the source code and build the app
COPY . .
RUN dotnet build "TodoApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TodoApi.csproj" -c Release -o /app/publish

# Stage 2: Run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TodoApi.dll"]
