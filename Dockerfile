FROM amazonlinux:2

# Need to set "ulimit -n" to a small value to stop yum from hanging:
# https://bugzilla.redhat.com/show_bug.cgi?id=1715254#c1
RUN ulimit -n 1024 && yum -y update && yum -y install \
	git \
	gcc \
	python38 \
	python38-pip \
	python38-devel \
	jq \
	nano \
	unzip \
	zip \
	&& yum clean all

COPY requirements.txt quilt/requirements.txt

RUN python3 -m pip install pip==21.1.1

# Requirements copied from lambda Python 3.6, but not in base image
# (Plus Cython which is a build-time requirement for numpy)
RUN python3 -m pip install -r quilt/requirements.txt

# Make it possible to build numpy:
# https://github.com/numpy/numpy/issues/14147
ENV CFLAGS=-std=c99
