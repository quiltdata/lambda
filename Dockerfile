FROM amazonlinux:2017.03

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

RUN python3 -m pip install --upgrade pip \
    # boto3 is available to lambda processes by default,
    # but it's not in the amazonlinux image
    && python3 -m pip install boto3

# Make it possible to build numpy:
# https://github.com/numpy/numpy/issues/14147
ENV CFLAGS=-std=c99
