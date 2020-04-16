FROM amazonlinux:2018.03

COPY requirements.txt quilt/requirements.txt

# Need to set "ulimit -n" to a small value to stop yum from hanging:
# https://bugzilla.redhat.com/show_bug.cgi?id=1715254#c1
RUN ulimit -n 1024 && yum -y update && yum -y install \
    git \
    gcc \
    python36 \
    python36-pip \
    python36-devel \
    zip \
    && yum clean all

RUN python3 -m pip install pip==18.1

# Requirements copied form lambda Python 3.6, but not in base image
RUN pip install -r quilt/requirements.txt

# Required to build numpy, but not listed as a dependency.
RUN python3 -m pip install Cython

# Make it possible to build numpy:
# https://github.com/numpy/numpy/issues/14147
ENV CFLAGS=-std=c99
