#!/bin/bash
set -e
source /build/buildconfig
set -x

## Create a user for the web app.
addgroup --gid 9999 app
adduser --uid 9999 --gid 9999 --disabled-password --gecos "Application" app
usermod -L app
mkdir /app
chown app:app /app/
