#!/bin/bash

apt-get install -y --no-install-recommends \
	build-essential \
	git \
	apt-transport-https \
	ca-certificates \
	gnupg \
	libssl-dev \
	libffi-dev \
	curl \
	libpq-dev \
	python3-dev \
	python3.4-venv \
	python3-setuptools \
	postgresql-client \
	openssh-client
apt-get build-dep -y psycopg2
apt-get build-dep -y python-pygraphviz
