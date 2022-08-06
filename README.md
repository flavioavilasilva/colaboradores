# Aplicação de colaboradores

This simple API has been written with the intent of show the sample of rest api.

Topics:

- Depends
- Building the container
- Running the rubocop lint
- Running the tests
- Cheking the coverage of tests on the API
- Running the application on docker
- Written by

## Depends

Docker/Docker-compose (https://docs.docker.com/get-docker/)

## Building and starting the container with the API running

The API is executable on docker container, to build the container, just do it:

To build the container image
```bash
docker-compose build
```
To create a instance of the imagem
```bash
docker-compose up -d
```
Now you should have a container running, to check, execute the follow command:
```bash
docker ps
```
The running APP should be expose on localhost:3000, try (http://localhost:3000/). Probably returns a template rails with versions information of ruby rails framework.

To down container if necessary, execute follow command:
```bash
docker-compose down
```

## Running the rubocop lint

To check lint code using rubocop, remember to have a running container and execute the follow command:

```bash
docker-compose run --no-deps web rubocop
```

## Running the tests

To execute rspec tests, remember to have a running container and execute the follow command:

```bash
docker-compose run --no-deps web rspec
```

## Cheking the coverage of tests on the API

After running the rspec tests, one file will be create on coverage folder 'coverage/index.html', just open it:

```bash
 open coverage/index.html
```

## Written by

*Flavio Avila*<br>
flavio.avila.silva@outlook.com<br>
https://github.com/flavioavilasilva<br>
https://www.linkedin.com/in/flavio-avila-7775702b/