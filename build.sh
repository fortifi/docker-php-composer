#!/bin/bash

docker pull debian:stretch
docker build -t=fortifi/php-composer .
