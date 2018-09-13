# Dockerfile for Sandy

A straightforward and complete next-generation sequencing read simulator

## Getting Started

These instructions will cover installation and usage information for the docker container.

### Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Acquiring Sandy Image

#### Manual Installation

Inside the docker folder:

`$ docker build -t sandy .`

#### Pulling Image

Pull **Sandy** image from [dockerhub](https://hub.docker.com) registry:

`$ docker pull thiagomiller/sandy`

### Usage

#### Container Examples

`$ docker run thiagomiller/sandy`

By default **Sandy** runs in a container-private folder. You can change this using flags, like user (-u),
current directory, and volumes (-w and -v). E.g. this behaves like an executable standalone and gives you
the power to process files outside the container:

```
$ docker run \
	--rm \
	-u $(id -u):$(id -g) \
	-v $(pwd):$(pwd) \
	-w $(pwd) \
	thiagomiller/sandy genome example.fa
```

How to get a shell started in your container:

`$ docker run -ti --entrypoint bash thiagomiller/sandy`

### Thank You

So long, and thanks for all the fish!