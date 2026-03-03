# Week 05: Containerization Lab - TCP Server

This lab demonstrates how to containerize the Java TCP Server created in the previous weeks using Docker.

## Prerequisites

- Docker Desktop installed and running.
- Java Development Kit (JDK) 21.

## Project Structure

- `src/TCPServer.java`: The multi-threaded TCP Server source code.
- `src/TCPClient.java`: The TCP Client source code.
- `Dockerfile`: Instructions to build the Docker image for the server.
- `entrypoint.sh`: The script executed when the Docker container starts.
- `Makefile`: Script to compile and run the Java code locally.

## Step 1: Compile the Java Code Locally

Before building the Docker image, compile the Java source code to generate the `.class` files in the `bin/` directory.

```bash
make compile
```

This will create `bin/TCPServer.class` and `bin/TCPServer$ClientHandler.class`.

## Step 2: Build the Docker Image

Build the Docker image using the provided `Dockerfile`. We will tag the image as `transcriptor:v1`.

```bash
docker build -t transcriptor:v1 .
```

*Note: The Dockerfile relies on Ubuntu 24.10, installs Headless OpenJDK 21, and copies the `.class` files from the `bin/` directory into the image.*

## Step 3: Run the Docker Container

Run the Docker container in detached mode (`-d`), mapping port `12345` on your host machine to port `12345` inside the container.

```bash
docker run -d -p 12345:12345 --name tcp-server-container transcriptor:v1
```

Verify the container is running:
```bash
docker ps
```

## Step 4: Connect the Local Client

Run the TCP Client locally to connect to the Dockerized server.

```bash
# Compile if you haven't already
make compile

# Run the client
java -cp bin TCPClient
```

Type messages into your terminal. You should see them echoed back by the server running securely inside the Docker container. 
Type `exit` to close the client connection.

## Step 5: Clean Up

Stop and remove the running Docker container:

```bash
docker stop tcp-server-container
docker rm tcp-server-container
```

Remove the compiled `.class` files:
```bash
make clean
```
