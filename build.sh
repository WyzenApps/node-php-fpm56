#!/bin/sh

TAG=${1:-"node-php-fpm56"}

docker build -f Dockerfile --tag ${TAG}:latest .

