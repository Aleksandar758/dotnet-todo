# Build stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY . ./
RUN dotnet restore "TodoApi.csproj"
RUN dotnet publish "TodoApi.csproj" -c Release -o /app/publish /p:PublishTrimmed=true /p:PublishSingleFile=true /p:PublishReadyToRun=true

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
# Create non-root user
RUN useradd -m appuser && mkdir -p /app && chown -R appuser /app
USER appuser
COPY --from=build /app/publish ./
ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000
ENTRYPOINT ["./TodoApi"]
