# rpi-buster-docker-x86_64
### Note: this repo is currently unstable and subject to change. I'm currently modifying the shell script to accept custom container runtimes, in addition to building the default latest image with podman to enable systemd.

A docker image containing the latest Raspbian Buster modified with qemu-arm-static to emulate armv4l on x86-64 machines.

```
./
├── Dockerfile : Example that builds from the latest image with node version manager
├── Makefile : To build and run the Dockerfile, execute the command **make all**
├── README.md
└── rpi-build-docker-img.sh : Dockerize a different distro. Heck, it doesn't need to be Raspbian! Read comments for more.
```