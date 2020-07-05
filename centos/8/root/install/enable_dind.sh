#!/bin/sh

test -S /install/docker.sock && ln -s /install/docker.sock /var/run/docker.sock