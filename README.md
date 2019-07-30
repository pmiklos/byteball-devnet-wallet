# obyte-devnet-wallet
Docker image for the Obyte devnet GUI wallet.

A prebuilt image is available at docker hub, see [pmiklos/obyte-devnet-wallet](https://hub.docker.com/r/pmiklos/obyte-devnet-wallet/).

## Usage

The simplest way to create the docker image for obyte-devnet-wallet is below.

```console
$ docker build -t obyte-devnet-wallet .
```

As this is a GUI app, you need some tricks to be able to draw on your display. This is how you can run this container to quickly check if it works (note: the `--rm` flag is gonna delete the container after exiting the app):

```console
$ docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix obyte-devnet-wallet
```

This approach also assumes that the user you are logged in on your docker host machine has a uid=1000. There is a fix to support any uids but I haven't implemented it yet.

If you want to log in and look around inside the container as root you can do this:

```console
$ docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -u root obyte-devnet-wallet /bin/bash
```

The wallet is installed in the home of the `obyte` user in the `/home/obyte/obyte-gui-wallet` folder. You can easily switch to that user with `su - obyte`.
