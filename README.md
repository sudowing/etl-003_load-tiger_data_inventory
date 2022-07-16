# etl-003_load

# Development (running locally)

```sh
docker run --rm \
	--network mynetwork \
	--env-file .env \
	-v $(pwd)/src:/etl/src \
	--name etl_demo \
	base_001_postgres:latest
```

##### NOTE: Only need `--network` if DB is on same docker network.

# Docker Image Development & Publication

## Build Updated Image

```sh
docker build -t etl-003_load:develop -f ./Dockerfile .
```

## Run Fresh Build

The only thing to pass in at runtime is input directory and a `.env`

```sh
docker run --rm \
	--network mynetwork \
	-v $(pwd)/src/input:/etl/src/input \
	--env-file .env \
	--name etl_demo \
	etl-003_load:develop
```

##### NOTE: Only need `--network` if DB is on same docker network.

## Release
```sh
docker tag \
	etl-003_load:develop \
	etl-003_load:latest
```

## Publish
```sh
docker push etl-003_load:latest
```
