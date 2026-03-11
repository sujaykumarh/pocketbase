# PocketBase Docker Image

This Docker image provides a pre-configured and ready-to-run instance of [PocketBase](https://pocketbase.io/). It simplifies deploying PocketBase for development, testing, and small-scale production environments.

## Description

This image is based on the official PocketBase project [github.com/pocketbase](https://github.com/pocketbase/pocketbase). It's designed to be easily deployed with Docker Compose or directly via Docker run.

## Usage

Check the sample [docker-compose.yml](/sample/docker-compose.yml) file. You can visit `http://localhost:8080/_/` to access pocketbase admin console. 

For initial setup in docker logs you will find setup url similar to ` http://0.0.0.0:80/_/#/pbinstal/<..token..>` replace 80 with your port to get started, or you can use `pocketbase superuser upsert <EMAIL> <PASS>` to setup superuser inside container.

or run directly

```shell
docker pull ghcr.io/sujaykumarh/pocketbase:latest

docker run -p 8080:80 ghcr.io/sujaykumarh/pocketbase:latest
```

<br>

## License

This project is licensed under the [MIT License](/LICENSE)