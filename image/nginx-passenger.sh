#!/bin/bash
set -e
source /build/buildconfig
set -x

## Install Phusion Passenger.
if [[ "$PASSENGER_ENTERPRISE" ]]; then
	apt-get install -y nginx-extras passenger-enterprise
else
	apt-get install -y nginx-extras passenger
fi

## Precompile Ruby extensions.
if [[ -e /usr/bin/ruby2.1 ]]; then
	ruby2.1 -S passenger-config build-native-support
	setuser app ruby2.1 -S passenger-config build-native-support
fi
if [[ -e /usr/bin/ruby2.0 ]]; then
	ruby2.0 -S passenger-config build-native-support
	setuser app ruby2.0 -S passenger-config build-native-support
fi
if [[ -e /usr/bin/ruby1.9.1 ]]; then
	ruby1.9.1 -S passenger-config build-native-support
	setuser app ruby1.9.1 -S passenger-config build-native-support
fi
